import SpriteKit

class ObstacleManager {
    
    var spawnInterval: TimeInterval
    var scrollSpeed: CGFloat
    var gapSize: CGFloat
    
    private var obstacles: [ObstacleNode] = []
    private var timeSinceLastSpawn: TimeInterval = 0
    
    private let topTexture: SKTexture
    private let bottomTexture: SKTexture
    private let screenWidth: CGFloat
    private let screenHeight: CGFloat
    
    private let minGapY: CGFloat
    private let maxGapY: CGFloat
    
    init(config: GameConfiguration, topTexture: SKTexture, bottomTexture: SKTexture, screenSize: CGSize) {
        self.spawnInterval = config.obstacleSpawnInterval
        self.scrollSpeed = config.scrollSpeed
        self.gapSize = config.obstacleGapSize
        
        self.topTexture = topTexture
        self.bottomTexture = bottomTexture
        self.screenWidth = screenSize.width
        self.screenHeight = screenSize.height
        
        // Calculate valid gap position range (keep gap away from edges)
        let margin: CGFloat = 100
        self.minGapY = margin + gapSize / 2
        self.maxGapY = screenHeight - margin - gapSize / 2
    }
    
    // MARK: - Spawning
    
    func spawnObstacle(at position: CGPoint, in scene: SKScene) {
        let gapCenterY = randomGapPosition()
        
        let obstacle = ObstacleNode(
            topTexture: topTexture,
            bottomTexture: bottomTexture,
            gapSize: gapSize,
            gapCenterY: gapCenterY,
            screenHeight: screenHeight
        )
        
        obstacle.position = position
        scene.addChild(obstacle)
        obstacles.append(obstacle)
    }
    
    func generateNextObstacle(in scene: SKScene) {
        let spawnX = screenWidth + 50 // Spawn off-screen to the right
        let spawnY: CGFloat = 0 // Y position doesn't matter, obstacle handles its own positioning
        
        spawnObstacle(at: CGPoint(x: spawnX, y: spawnY), in: scene)
    }
    
    private func randomGapPosition() -> CGFloat {
        return CGFloat.random(in: minGapY...maxGapY)
    }
    
    // MARK: - Movement
    
    func updateObstacles(deltaTime: TimeInterval) {
        // Update spawn timer
        timeSinceLastSpawn += deltaTime
        
        // Move all obstacles
        for obstacle in obstacles {
            obstacle.position.x -= scrollSpeed * CGFloat(deltaTime)
        }
    }
    
    func shouldSpawnObstacle() -> Bool {
        if timeSinceLastSpawn >= spawnInterval {
            timeSinceLastSpawn = 0
            return true
        }
        return false
    }
    
    func removeOffscreenObstacles() {
        obstacles.removeAll { obstacle in
            if obstacle.position.x < -100 {
                obstacle.removeFromParent()
                return true
            }
            return false
        }
    }
    
    // MARK: - Getters
    
    func getObstacles() -> [ObstacleNode] {
        return obstacles
    }
    
    func getObstacleCount() -> Int {
        return obstacles.count
    }
    
    // MARK: - Reset
    
    func reset() {
        for obstacle in obstacles {
            obstacle.removeFromParent()
        }
        obstacles.removeAll()
        timeSinceLastSpawn = 0
    }
}
