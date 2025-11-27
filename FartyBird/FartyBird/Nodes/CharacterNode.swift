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
        
        // Scale down the sprite to 40% of original size for better gameplay
        let scaledSize = CGSize(
            width: initialTexture.size().width * 0.4,
            height: initialTexture.size().height * 0.4
        )
        
        super.init(texture: initialTexture, color: .clear, size: scaledSize)
        
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
        // Use a smaller collision radius for more forgiving gameplay
        // Match the visual size more closely - 60% of sprite width
        let collisionRadius = size.width * 0.3  // 60% diameter = 30% radius on each side
        physicsBody = SKPhysicsBody(circleOfRadius: collisionRadius)
        physicsBody?.categoryBitMask = PhysicsCategory.character
        physicsBody?.contactTestBitMask = PhysicsCategory.obstacle | PhysicsCategory.ground | PhysicsCategory.scoreZone
        physicsBody?.collisionBitMask = PhysicsCategory.ground
        physicsBody?.isDynamic = true
        physicsBody?.allowsRotation = false
        physicsBody?.restitution = 0
        
        // Debug logging
        print("🐔 Character physics setup:")
        print("  Visual size: \(size)")
        print("  Collision radius: \(collisionRadius) (60% of visual width)")
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
        guard isAlive else {
            // Even when dead, apply rotation for falling effect
            if let velocity = physicsBody?.velocity.dy {
                let targetRotation = velocity / 1000
                let clampedRotation = max(-CGFloat.pi / 2, min(CGFloat.pi / 4, targetRotation))
                let rotationSpeed: CGFloat = 3.0
                let rotationDelta = (clampedRotation - zRotation) * rotationSpeed * CGFloat(deltaTime)
                zRotation += rotationDelta
            }
            return
        }
        
        // Clamp to top boundary
        if position.y > topBoundary {
            position.y = topBoundary
            physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        
        // Update rotation based on velocity (tilt up when rising, down when falling)
        if let velocity = physicsBody?.velocity.dy {
            // Rotate character based on vertical velocity
            // Positive velocity (rising) = tilt up (positive rotation)
            // Negative velocity (falling) = tilt down (negative rotation)
            let targetRotation = velocity / 1000 // Scale factor for rotation
            let clampedRotation = max(-CGFloat.pi / 4, min(CGFloat.pi / 4, targetRotation)) // Clamp to ±45°
            
            // Smoothly interpolate to target rotation
            let rotationSpeed: CGFloat = 5.0
            let rotationDelta = (clampedRotation - zRotation) * rotationSpeed * CGFloat(deltaTime)
            zRotation += rotationDelta
            
            // Update animation based on velocity (don't switch back to idle during free fall)
            if velocity < -150 && currentState != .farting && currentState != .dead {
                playFallingAnimation()
            } else if velocity > 50 && currentState == .falling {
                // Only return to idle if actively rising (not just slowing down)
                playIdleAnimation()
            }
        }
    }
    
    func die() {
        // Don't set isAlive = false yet - let update() continue to handle animation
        physicsBody?.isDynamic = true // Allow falling
        
        // After a delay, mark as dead to stop update logic
        let wait = SKAction.wait(forDuration: 0.5)
        let markDead = SKAction.run { [weak self] in
            self?.isAlive = false
            self?.currentState = .dead
        }
        run(SKAction.sequence([wait, markDead]))
    }
}
