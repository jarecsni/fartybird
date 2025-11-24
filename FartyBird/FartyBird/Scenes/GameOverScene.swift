import SpriteKit

class GameOverScene: SKScene {
    
    private var gameOverLabel: SKLabelNode!
    private var currentScoreLabel: SKLabelNode!
    private var highScoreLabel: SKLabelNode!
    private var restartLabel: SKLabelNode!
    
    private let finalScore: Int
    
    init(size: CGSize, score: Int) {
        self.finalScore = score
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.finalScore = 0
        super.init(coder: aDecoder)
    }
    
    override func didMove(to view: SKView) {
        setupScene()
        updateHighScore()
    }
    
    private func setupScene() {
        backgroundColor = .cyan
        
        // Game Over title
        setupGameOverLabel()
        
        // Current score display
        setupCurrentScoreLabel()
        
        // High score display
        setupHighScoreLabel()
        
        // Restart instruction
        setupRestartLabel()
    }
    
    private func setupGameOverLabel() {
        gameOverLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.fontSize = 48
        gameOverLabel.fontColor = .red
        gameOverLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.7)
        gameOverLabel.zPosition = 1
        addChild(gameOverLabel)
    }
    
    private func setupCurrentScoreLabel() {
        currentScoreLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        currentScoreLabel.text = "Score: \(finalScore)"
        currentScoreLabel.fontSize = 36
        currentScoreLabel.fontColor = .white
        currentScoreLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.55)
        currentScoreLabel.zPosition = 1
        addChild(currentScoreLabel)
    }
    
    private func setupHighScoreLabel() {
        highScoreLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        let highScore = ScoreManager.shared.getHighScore()
        highScoreLabel.text = "High Score: \(highScore)"
        highScoreLabel.fontSize = 32
        highScoreLabel.fontColor = .yellow
        highScoreLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.45)
        highScoreLabel.zPosition = 1
        addChild(highScoreLabel)
    }
    
    private func setupRestartLabel() {
        restartLabel = SKLabelNode(fontNamed: "Arial")
        restartLabel.text = "Tap anywhere to restart"
        restartLabel.fontSize = 24
        restartLabel.fontColor = .white
        restartLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.3)
        restartLabel.zPosition = 1
        addChild(restartLabel)
        
        // Add pulsing animation
        let fadeOut = SKAction.fadeAlpha(to: 0.3, duration: 0.8)
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.8)
        let pulse = SKAction.sequence([fadeOut, fadeIn])
        restartLabel.run(SKAction.repeatForever(pulse))
    }
    
    private func updateHighScore() {
        // Compare current score with high score and update if needed
        let currentHighScore = ScoreManager.shared.getHighScore()
        
        if finalScore > currentHighScore {
            ScoreManager.shared.updateHighScore(finalScore)
            
            // Add "NEW HIGH SCORE!" indicator
            let newHighScoreLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
            newHighScoreLabel.text = "NEW HIGH SCORE!"
            newHighScoreLabel.fontSize = 28
            newHighScoreLabel.fontColor = .green
            newHighScoreLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.35)
            newHighScoreLabel.zPosition = 1
            addChild(newHighScoreLabel)
            
            // Animate the new high score label
            let scaleUp = SKAction.scale(to: 1.2, duration: 0.3)
            let scaleDown = SKAction.scale(to: 1.0, duration: 0.3)
            let pulse = SKAction.sequence([scaleUp, scaleDown])
            newHighScoreLabel.run(SKAction.repeat(pulse, count: 3))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Reset score and transition to new game
        ScoreManager.shared.resetScore()
        
        let gameScene = GameScene(size: size)
        gameScene.scaleMode = scaleMode
        
        let transition = SKTransition.fade(withDuration: 0.5)
        view?.presentScene(gameScene, transition: transition)
    }
}
