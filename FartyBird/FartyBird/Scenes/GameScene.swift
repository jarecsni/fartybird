import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Game components
    private var character: CharacterNode!
    private var obstacleManager: ObstacleManager!
    private var physicsManager: PhysicsManager!
    
    // Background and ground
    private var background1: SKSpriteNode!
    private var background2: SKSpriteNode!
    private var ground1: SKSpriteNode!
    private var ground2: SKSpriteNode!
    
    // UI
    private var scoreLabel: SKLabelNode!
    
    // Game state
    private var gameState: GameState = .initial
    private var isGameOver: Bool = false
    
    // Configuration
    private var config: GameConfiguration!
    
    // MARK: - Scene Setup
    
    override func didMove(to view: SKView) {
        setupScene()
    }
    
    private func setupScene() {
        // Load configuration
        config = GameConfiguration.default
        
        // Set up physics
        physicsManager = PhysicsManager()
        physicsManager.setupPhysicsWorld(for: self)
        physicsWorld.contactDelegate = self
        
        // Enable physics debug drawing
        #if DEBUG
        if let view = self.view {
            view.showsPhysics = true
        }
        #endif
        
        // Load assets
        let assetManager = AssetManager.shared
        let characterSprites = assetManager.loadCharacterSprites(for: assetManager.getCurrentTheme())
        let obstacleSprites = assetManager.loadObstacleSprites(for: assetManager.getCurrentTheme())
        let backgroundSprites = assetManager.loadBackgroundSprites(for: assetManager.getCurrentTheme())
        
        // Set up background
        setupBackground(texture: backgroundSprites["sky"]!)
        
        // Set up ground
        setupGround(texture: backgroundSprites["ground"]!)
        
        // Set up character
        setupCharacter(textures: characterSprites)
        
        // Set up obstacle manager
        setupObstacleManager(
            topTexture: obstacleSprites["pipeTop"]!,
            bottomTexture: obstacleSprites["pipeBottom"]!
        )
        
        // Set up UI
        setupScoreLabel()
        
        // Reset score
        ScoreManager.shared.resetScore()
        
        // Start game
        gameState.isPlaying = true
    }
    
    private func setupBackground(texture: SKTexture) {
        // Create two backgrounds for seamless scrolling
        background1 = SKSpriteNode(texture: texture)
        background1.anchorPoint = CGPoint(x: 0, y: 0)
        background1.position = CGPoint(x: 0, y: 0)
        background1.zPosition = -2
        background1.size = CGSize(width: size.width, height: size.height)
        addChild(background1)
        
        background2 = SKSpriteNode(texture: texture)
        background2.anchorPoint = CGPoint(x: 0, y: 0)
        background2.position = CGPoint(x: size.width, y: 0)
        background2.zPosition = -2
        background2.size = CGSize(width: size.width, height: size.height)
        addChild(background2)
    }
    
    private func setupGround(texture: SKTexture) {
        let groundHeight: CGFloat = 64
        
        // Create two ground sprites for seamless scrolling
        ground1 = SKSpriteNode(texture: texture)
        ground1.anchorPoint = CGPoint(x: 0, y: 0)
        ground1.position = CGPoint(x: 0, y: 0)
        ground1.zPosition = 1
        ground1.size = CGSize(width: size.width, height: groundHeight)
        addChild(ground1)
        
        ground2 = SKSpriteNode(texture: texture)
        ground2.anchorPoint = CGPoint(x: 0, y: 0)
        ground2.position = CGPoint(x: size.width, y: 0)
        ground2.zPosition = 1
        ground2.size = CGSize(width: size.width, height: groundHeight)
        addChild(ground2)
        
        // Add physics body to ground
        let groundBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width * 2, height: groundHeight))
        groundBody.categoryBitMask = PhysicsCategory.ground
        groundBody.contactTestBitMask = PhysicsCategory.character
        groundBody.collisionBitMask = PhysicsCategory.character
        groundBody.isDynamic = false
        
        let groundNode = SKNode()
        groundNode.position = CGPoint(x: size.width, y: groundHeight / 2)
        groundNode.physicsBody = groundBody
        addChild(groundNode)
    }
    
    private func setupCharacter(textures: [String: SKTexture]) {
        let startX = size.width * 0.35  // Position so pipes scroll from right to left past the character
        let startY = size.height * 0.5
        
        character = CharacterNode(textures: textures, topBoundary: size.height - 50)
        character.position = CGPoint(x: startX, y: startY)
        character.zPosition = 0
        addChild(character)
    }
    
    private func setupObstacleManager(topTexture: SKTexture, bottomTexture: SKTexture) {
        obstacleManager = ObstacleManager(
            config: config,
            topTexture: topTexture,
            bottomTexture: bottomTexture,
            screenSize: size
        )
    }
    
    private func setupScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        scoreLabel.fontSize = 48
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 100)
        scoreLabel.zPosition = 10
        scoreLabel.text = "0"
        addChild(scoreLabel)
    }
    
    // MARK: - Game Loop
    
    override func update(_ currentTime: TimeInterval) {
        guard gameState.isPlaying && !isGameOver else { return }
        
        let deltaTime: TimeInterval = 1.0 / 60.0
        
        // Update character
        character.update(deltaTime: deltaTime)
        
        // Update obstacles
        obstacleManager.updateObstacles(deltaTime: deltaTime)
        obstacleManager.removeOffscreenObstacles()
        
        // Spawn new obstacles
        if obstacleManager.shouldSpawnObstacle() {
            obstacleManager.generateNextObstacle(in: self)
        }
        
        // Update scrolling background
        updateBackground(deltaTime: deltaTime)
        
        // Update scrolling ground
        updateGround(deltaTime: deltaTime)
        
        // Update score display
        updateScoreDisplay()
    }
    
    private func updateBackground(deltaTime: TimeInterval) {
        let scrollSpeed = config.scrollSpeed * 0.3 // Background scrolls slower
        
        background1.position.x -= scrollSpeed * CGFloat(deltaTime)
        background2.position.x -= scrollSpeed * CGFloat(deltaTime)
        
        // Reset positions for seamless scrolling
        if background1.position.x <= -size.width {
            background1.position.x = background2.position.x + size.width
        }
        if background2.position.x <= -size.width {
            background2.position.x = background1.position.x + size.width
        }
    }
    
    private func updateGround(deltaTime: TimeInterval) {
        let scrollSpeed = config.scrollSpeed
        
        ground1.position.x -= scrollSpeed * CGFloat(deltaTime)
        ground2.position.x -= scrollSpeed * CGFloat(deltaTime)
        
        // Reset positions for seamless scrolling
        if ground1.position.x <= -size.width {
            ground1.position.x = ground2.position.x + size.width
        }
        if ground2.position.x <= -size.width {
            ground2.position.x = ground1.position.x + size.width
        }
    }
    
    private func updateScoreDisplay() {
        scoreLabel.text = "\(ScoreManager.shared.getCurrentScore())"
    }
    
    // MARK: - Touch Handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard gameState.isPlaying && !isGameOver else { return }
        
        // Apply fart thrust
        character.applyFartThrust()
        
        // Play fart sound
        if let soundAction = AudioManager.shared.soundAction(for: .fart) {
            run(soundAction)
        }
    }
    
    // MARK: - Collision Detection
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard !isGameOver else { return }
        
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        // Debug logging
        print("🔴 COLLISION DETECTED!")
        print("  Body A: \(contact.bodyA.node?.name ?? "unnamed") - Category: \(contact.bodyA.categoryBitMask)")
        if let nodeA = contact.bodyA.node {
            print("    Position: \(nodeA.position)")
            print("    Parent position: \(nodeA.parent?.position ?? CGPoint.zero)")
            print("    Frame: \(nodeA.frame)")
        }
        print("  Body B: \(contact.bodyB.node?.name ?? "unnamed") - Category: \(contact.bodyB.categoryBitMask)")
        if let nodeB = contact.bodyB.node {
            print("    Position: \(nodeB.position)")
            print("    Parent position: \(nodeB.parent?.position ?? CGPoint.zero)")
            print("    Frame: \(nodeB.frame)")
        }
        print("  Character position: \(character.position)")
        print("  Character frame: \(character.frame)")
        print("  Collision bitmask: \(collision)")
        print("  Contact point: \(contact.contactPoint)")
        
        // Check for character-obstacle or character-ground collision
        if collision == (PhysicsCategory.character | PhysicsCategory.obstacle) ||
           collision == (PhysicsCategory.character | PhysicsCategory.ground) {
            print("💀 GAME OVER TRIGGERED")
            handleGameOver()
        }
        
        // Check for character-scoreZone contact
        if collision == (PhysicsCategory.character | PhysicsCategory.scoreZone) {
            print("⭐ SCORE ZONE HIT")
            handleScoring(contact: contact)
        }
    }
    
    private func handleScoring(contact: SKPhysicsContact) {
        // Increment score
        ScoreManager.shared.incrementScore()
        
        // Play score sound
        if let soundAction = AudioManager.shared.soundAction(for: .score) {
            run(soundAction)
        }
        
        // Remove score zone
        if contact.bodyA.categoryBitMask == PhysicsCategory.scoreZone {
            contact.bodyA.node?.removeFromParent()
        } else {
            contact.bodyB.node?.removeFromParent()
        }
    }
    
    private func handleGameOver() {
        isGameOver = true
        gameState.isPlaying = false
        
        // Stop all movement
        obstacleManager.updateObstacles(deltaTime: 0)
        
        // Kill character
        character.die()
        
        // Play collision sound
        if let soundAction = AudioManager.shared.soundAction(for: .collision) {
            run(soundAction)
        }
        
        // Wait for character to fall, then show tombstone
        let wait = SKAction.wait(forDuration: 1.0)
        let showTombstone = SKAction.run { [weak self] in
            self?.showTombstone()
        }
        run(SKAction.sequence([wait, showTombstone]))
    }
    
    private func showTombstone() {
        // Load tombstone texture
        let assetManager = AssetManager.shared
        let backgroundSprites = assetManager.loadBackgroundSprites(for: assetManager.getCurrentTheme())
        
        guard let tombstoneTexture = backgroundSprites["tombstone"] else { return }
        
        // Create tombstone
        let tombstone = SKSpriteNode(texture: tombstoneTexture)
        tombstone.position = CGPoint(x: character.position.x, y: 100)
        tombstone.zPosition = 5
        
        // Add score text to tombstone
        let scoreText = SKLabelNode(fontNamed: "Arial-BoldMT")
        scoreText.fontSize = 20
        scoreText.fontColor = .black
        scoreText.text = "\(ScoreManager.shared.getCurrentScore())"
        scoreText.position = CGPoint(x: 0, y: 0)
        tombstone.addChild(scoreText)
        
        addChild(tombstone)
        
        // Animate tombstone rising from ground
        tombstone.position.y = 32
        let rise = SKAction.moveTo(y: 100, duration: 0.5)
        tombstone.run(rise)
        
        // Transition to game over scene after delay
        let wait = SKAction.wait(forDuration: 2.0)
        let transition = SKAction.run { [weak self] in
            self?.transitionToGameOver()
        }
        run(SKAction.sequence([wait, transition]))
    }
    
    private func transitionToGameOver() {
        // Update high score
        let currentScore = ScoreManager.shared.getCurrentScore()
        ScoreManager.shared.updateHighScore(currentScore)
        
        // Transition to GameOverScene
        let gameOverScene = GameOverScene(size: size, score: currentScore)
        gameOverScene.scaleMode = scaleMode
        
        let transition = SKTransition.fade(withDuration: 0.5)
        view?.presentScene(gameOverScene, transition: transition)
    }
}
