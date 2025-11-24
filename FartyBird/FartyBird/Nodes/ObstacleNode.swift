import SpriteKit

class ObstacleNode: SKNode {
    
    private let topPipe: SKSpriteNode
    private let bottomPipe: SKSpriteNode
    private let scoreZone: SKNode
    
    let gapSize: CGFloat
    let gapCenterY: CGFloat
    var hasScoredPoint: Bool = false
    
    init(topTexture: SKTexture, bottomTexture: SKTexture, gapSize: CGFloat, gapCenterY: CGFloat, screenHeight: CGFloat) {
        self.gapSize = gapSize
        self.gapCenterY = gapCenterY
        
        let pipeWidth: CGFloat = 52
        let halfGap = gapSize / 2
        let pipeColor = UIColor(red: 0.13, green: 0.69, blue: 0.30, alpha: 1.0)
        
        // TOP PIPE: From top of screen down to gap (inset by 1 to avoid edge artifacts)
        let topPipeHeight = screenHeight - (gapCenterY + halfGap) - 1
        topPipe = SKSpriteNode(color: pipeColor, size: CGSize(width: pipeWidth, height: topPipeHeight))
        
        // BOTTOM PIPE: From bottom of screen up to gap (inset by 1 to avoid edge artifacts)
        let bottomPipeHeight = gapCenterY - halfGap - 1
        bottomPipe = SKSpriteNode(color: pipeColor, size: CGSize(width: pipeWidth, height: bottomPipeHeight))
        
        scoreZone = SKNode()
        
        super.init()
        
        // Position pipes after super.init()
        topPipe.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        topPipe.position = CGPoint(x: 0, y: screenHeight)
        
        bottomPipe.anchorPoint = CGPoint(x: 0.5, y: 0)
        bottomPipe.position = CGPoint(x: 0, y: 0)
        
        // Physics bodies - offset to match anchor points
        // Top pipe: anchor at (0.5, 1.0) means sprite extends DOWN from anchor
        // Physics body center needs to be at -height/2 to cover the sprite
        let topPhysicsCenter = CGPoint(x: 0, y: -topPipe.size.height / 2)
        topPipe.physicsBody = SKPhysicsBody(rectangleOf: topPipe.size, center: topPhysicsCenter)
        topPipe.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
        topPipe.physicsBody?.contactTestBitMask = PhysicsCategory.character
        topPipe.physicsBody?.collisionBitMask = 0
        topPipe.physicsBody?.isDynamic = false
        
        // Bottom pipe: anchor at (0.5, 0.0) means sprite extends UP from anchor
        // Physics body center needs to be at +height/2 to cover the sprite
        let bottomPhysicsCenter = CGPoint(x: 0, y: bottomPipe.size.height / 2)
        bottomPipe.physicsBody = SKPhysicsBody(rectangleOf: bottomPipe.size, center: bottomPhysicsCenter)
        bottomPipe.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
        bottomPipe.physicsBody?.contactTestBitMask = PhysicsCategory.character
        bottomPipe.physicsBody?.collisionBitMask = 0
        bottomPipe.physicsBody?.isDynamic = false
        
        // Score zone
        scoreZone.position = CGPoint(x: 0, y: gapCenterY)
        let zoneBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: gapSize))
        zoneBody.categoryBitMask = PhysicsCategory.scoreZone
        zoneBody.contactTestBitMask = PhysicsCategory.character
        zoneBody.collisionBitMask = 0
        zoneBody.isDynamic = false
        scoreZone.physicsBody = zoneBody
        
        addChild(topPipe)
        addChild(bottomPipe)
        addChild(scoreZone)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getWidth() -> CGFloat {
        return topPipe.size.width
    }
}
