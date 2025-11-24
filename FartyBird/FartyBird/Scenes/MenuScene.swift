import SpriteKit

class MenuScene: SKScene {
    
    private var titleLogo: SKSpriteNode!
    private var playButton: SKSpriteNode!
    private var settingsButton: SKSpriteNode!
    private var highScoreLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        setupScene()
    }
    
    private func setupScene() {
        backgroundColor = .cyan
        
        // Load UI sprites
        let uiSprites = AssetManager.shared.loadUISprites()
        
        // Set up title logo
        if let titleTexture = uiSprites["titleLogo"] {
            setupTitleLogo(texture: titleTexture)
        }
        
        // Set up play button
        if let playTexture = uiSprites["playButton"] {
            setupPlayButton(texture: playTexture)
        }
        
        // Set up settings button
        if let settingsTexture = uiSprites["settingsIcon"] {
            setupSettingsButton(texture: settingsTexture)
        }
        
        // Set up high score display
        setupHighScoreLabel()
    }
    
    private func setupTitleLogo(texture: SKTexture) {
        titleLogo = SKSpriteNode(texture: texture)
        titleLogo.position = CGPoint(x: size.width / 2, y: size.height * 0.7)
        titleLogo.zPosition = 1
        addChild(titleLogo)
        
        // Add "Farty Bird" text if using placeholder
        let titleText = SKLabelNode(fontNamed: "Arial-BoldMT")
        titleText.text = "FARTY BIRD"
        titleText.fontSize = 48
        titleText.fontColor = .white
        titleText.position = CGPoint(x: 0, y: -10)
        titleLogo.addChild(titleText)
    }
    
    private func setupPlayButton(texture: SKTexture) {
        playButton = SKSpriteNode(texture: texture)
        playButton.position = CGPoint(x: size.width / 2, y: size.height * 0.4)
        playButton.name = "playButton"
        playButton.zPosition = 1
        addChild(playButton)
        
        // Add "PLAY" text
        let playText = SKLabelNode(fontNamed: "Arial-BoldMT")
        playText.text = "PLAY"
        playText.fontSize = 32
        playText.fontColor = .white
        playText.verticalAlignmentMode = .center
        playText.position = CGPoint(x: 0, y: 0)
        playButton.addChild(playText)
    }
    
    private func setupSettingsButton(texture: SKTexture) {
        settingsButton = SKSpriteNode(texture: texture)
        settingsButton.position = CGPoint(x: size.width - 50, y: size.height - 50)
        settingsButton.name = "settingsButton"
        settingsButton.zPosition = 1
        addChild(settingsButton)
    }
    
    private func setupHighScoreLabel() {
        highScoreLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        highScoreLabel.fontSize = 24
        highScoreLabel.fontColor = .white
        highScoreLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.25)
        highScoreLabel.zPosition = 1
        
        let highScore = ScoreManager.shared.getHighScore()
        highScoreLabel.text = "High Score: \(highScore)"
        
        addChild(highScoreLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        for node in touchedNodes {
            if node.name == "playButton" {
                transitionToGame()
            } else if node.name == "settingsButton" {
                transitionToSettings()
            }
        }
    }
    
    private func transitionToGame() {
        let gameScene = GameScene(size: size)
        gameScene.scaleMode = scaleMode
        
        let transition = SKTransition.fade(withDuration: 0.5)
        view?.presentScene(gameScene, transition: transition)
    }
    
    private func transitionToSettings() {
        let settingsScene = SettingsScene(size: size)
        settingsScene.scaleMode = scaleMode
        
        let transition = SKTransition.fade(withDuration: 0.5)
        view?.presentScene(settingsScene, transition: transition)
    }
}
