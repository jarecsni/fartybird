import SpriteKit

class ObstacleNode: SKNode {
    
    private let pipeTopSprite: SKSpriteNode
    private let pipeBottomSprite: SKSpriteNode
    private let scoreZone: SKNode
    
    let gapSize: CGFloat
    var hasScoredPoint: Bool = false
    
    init(topTexture: SKTexture, bottomTexture: SKTexture, gapSize: CGFloat, gapCenterY: CGFloat, screenHeight: CGFloat) {
        self.gapSize = gapSize
        
        // Create pipe sprites
        pipeTopSprite = SKSpriteNode(texture: topTexture)
        pipeBottomSprite = SKSpriteNode(texture: bottomTexture)
        
        // Create score zone
        scoreZone = SKNode()
        
        super.init()
        
        // Position pipes
        let halfGap = gapSize / 2
        
        // Top pipe (hangs down from top)
        pipeTopSprite.anchorPoint = CGPoint(x: 0.5, y: 0)
        pipeTopSprite.position = CGPoint(x: 0, y: gapCenterY + halfGap)
        
        // Bottom pipe (rises from bottom)
        pipeBottomSprite.anchorPoint = CGPoint(x: 0.5, y: 1)
        pipeBottomSprite.position = CGPoint(x: 0, y: gapCenterY - halfGap)
        
        // Set up physics for pipes
        setupPipePhysics(pipeTopSprite)
        setupPipePhysics(pipeBottomSprite)
        
        // Set up score zone
        setupScoreZone(gapCenterY: gapCenterY)
        
        // Add children
        addChild(pipeTopSprite)
        addChild(pipeBottomSprite)
        addChild(scoreZone)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPipePhysics(_ pipe: SKSpriteNode) {
        pipe.physicsBody = SKPhysicsBody(rectangleOf: pipe.size)
        pipe.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
        pipe.physicsBody?.contactTestBitMask = PhysicsCategory.character
        pipe.physicsBody?.collisionBitMask = 0
        pipe.physicsBody?.isDynamic = false
    }
    
    private func setupScoreZone(gapCenterY: CGFloat) {
        let zoneWidth: CGFloat = 10
        let zoneHeight = gapSize
        
        scoreZone.position = CGPoint(x: 0, y: gapCenterY)
        
        let zoneBody = SKPhysicsBody(rectangleOf: CGSize(width: zoneWidth, height: zoneHeight))
        zoneBody.categoryBitMask = PhysicsCategory.scoreZone
        zoneBody.contactTestBitMask = PhysicsCategory.character
        zoneBody.collisionBitMask = 0
        zoneBody.isDynamic = false
        
        scoreZone.physicsBody = zoneBody
    }
    
    func getWidth() -> CGFloat {
        return pipeTopSprite.size.width
    }
}
