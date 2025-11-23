import SpriteKit

enum CharacterState {
    case idle
    case farting
    case falling
    case dead
}

class CharacterNode: SKSpriteNode {
    
    var isAlive: Bool = true
    var currentState: CharacterState = .idle {
        didSet {
            updateAnimation()
        }
    }
    
    private var idleTextures: [SKTexture] = []
    private var fartTextures: [SKTexture] = []
    private var fallingTextures: [SKTexture] = []
    
    private let thrustVelocity: CGFloat = 350
    private var topBoundary: CGFloat = 0
    
    // MARK: - Initialization
    
    init(textures: [String: SKTexture], topBoundary: CGFloat) {
        // Use idle texture as initial texture
        let initialTexture = textures["idle"] ?? SKTexture()
        
        super.init(texture: initialTexture, color: .clear, size: initialTexture.size())
        
        self.topBoundary = topBoundary
        
        // Store textures for animations
        if let idleTexture = textures["idle"] {
            self.idleTextures = [idleTexture]
        }
        if let fartTexture = textures["fart"] {
            self.fartTextures = [fartTexture]
        }
        if let fallingTexture = textures["falling"] {
            self.fallingTextures = [fallingTexture]
        }
        
        setupPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Physics Setup
    
    private func setupPhysics() {
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody?.categoryBitMask = PhysicsCategory.character
        physicsBody?.contactTestBitMask = PhysicsCategory.obstacle | PhysicsCategory.ground | PhysicsCategory.scoreZone
        physicsBody?.collisionBitMask = PhysicsCategory.ground
        physicsBody?.isDynamic = true
        physicsBody?.allowsRotation = false
        physicsBody?.restitution = 0
    }
    
    // MARK: - Animation Management
    
    func playIdleAnimation() {
        currentState = .idle
    }
    
    func playFartAnimation() {
        currentState = .farting
        
        // Return to idle after a short delay
        let wait = SKAction.wait(forDuration: 0.2)
        let returnToIdle = SKAction.run { [weak self] in
            if self?.currentState == .farting {
                self?.currentState = .idle
            }
        }
        run(SKAction.sequence([wait, returnToIdle]))
    }
    
    func playFallingAnimation() {
        currentState = .falling
    }
    
    private func updateAnimation() {
        switch currentState {
        case .idle:
            if !idleTextures.isEmpty {
                texture = idleTextures[0]
            }
        case .farting:
            if !fartTextures.isEmpty {
                texture = fartTextures[0]
            }
        case .falling:
            if !fallingTextures.isEmpty {
                texture = fallingTextures[0]
            }
        case .dead:
            // Keep current texture
            break
        }
    }
    
    // MARK: - Physics Methods
    
    func applyFartThrust() {
        guard isAlive else { return }
        
        // Apply upward velocity
        physicsBody?.velocity = CGVector(dx: 0, dy: thrustVelocity)
        
        // Play fart animation
        playFartAnimation()
        
        // Create and add fart particle effect
        createFartParticles()
    }
    
    private func createFartParticles() {
        let particles = FartParticleEmitter.createFartParticles()
        particles.position = CGPoint(x: 0, y: -size.height / 2)
        particles.targetNode = self.parent
        
        addChild(particles)
        
        // Remove particles after they're done
        let wait = SKAction.wait(forDuration: 1.0)
        let remove = SKAction.removeFromParent()
        particles.run(SKAction.sequence([wait, remove]))
    }
    
    func update(deltaTime: TimeInterval) {
        guard isAlive else { return }
        
        // Clamp to top boundary
        if position.y > topBoundary {
            position.y = topBoundary
            physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        
        // Update animation based on velocity
        if let velocity = physicsBody?.velocity.dy {
            if velocity < -100 && currentState != .farting {
                playFallingAnimation()
            } else if velocity >= -100 && currentState == .falling {
                playIdleAnimation()
            }
        }
    }
    
    func die() {
        isAlive = false
        currentState = .dead
        physicsBody?.isDynamic = true // Allow falling
    }
}
