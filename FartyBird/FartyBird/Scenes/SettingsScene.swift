import SpriteKit

class SettingsScene: SKScene {
    
    private var titleLabel: SKLabelNode!
    private var easyButton: SKSpriteNode!
    private var normalButton: SKSpriteNode!
    private var soundButton: SKSpriteNode!
    private var backButton: SKSpriteNode!
    
    private var easyLabel: SKLabelNode!
    private var normalLabel: SKLabelNode!
    private var soundLabel: SKLabelNode!
    
    private let difficultyKey = "FartyBird.Difficulty"
    
    override func didMove(to view: SKView) {
        setupScene()
    }
    
    private func setupScene() {
        backgroundColor = .cyan
        
        // Title
        setupTitle()
        
        // Difficulty buttons
        setupDifficultyButtons()
        
        // Sound toggle
        setupSoundButton()
        
        // Back button
        setupBackButton()
        
        // Update button states
        updateButtonStates()
    }
    
    private func setupTitle() {
        titleLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        titleLabel.text = "SETTINGS"
        titleLabel.fontSize = 48
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.8)
        titleLabel.zPosition = 1
        addChild(titleLabel)
    }
    
    private func setupDifficultyButtons() {
        // Easy button
        easyButton = SKSpriteNode(color: .green, size: CGSize(width: 200, height: 60))
        easyButton.position = CGPoint(x: size.width / 2 - 120, y: size.height * 0.6)
        easyButton.name = "easyButton"
        easyButton.zPosition = 1
        addChild(easyButton)
        
        easyLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        easyLabel.text = "EASY"
        easyLabel.fontSize = 32
        easyLabel.fontColor = .white
        easyLabel.verticalAlignmentMode = .center
        easyLabel.position = CGPoint(x: 0, y: 0)
        easyButton.addChild(easyLabel)
        
        // Normal button
        normalButton = SKSpriteNode(color: .orange, size: CGSize(width: 200, height: 60))
        normalButton.position = CGPoint(x: size.width / 2 + 120, y: size.height * 0.6)
        normalButton.name = "normalButton"
        normalButton.zPosition = 1
        addChild(normalButton)
        
        normalLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        normalLabel.text = "NORMAL"
        normalLabel.fontSize = 32
        normalLabel.fontColor = .white
        normalLabel.verticalAlignmentMode = .center
        normalLabel.position = CGPoint(x: 0, y: 0)
        normalButton.addChild(normalLabel)
    }
    
    private func setupSoundButton() {
        soundButton = SKSpriteNode(color: .blue, size: CGSize(width: 300, height: 60))
        soundButton.position = CGPoint(x: size.width / 2, y: size.height * 0.4)
        soundButton.name = "soundButton"
        soundButton.zPosition = 1
        addChild(soundButton)
        
        soundLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        soundLabel.fontSize = 32
        soundLabel.fontColor = .white
        soundLabel.verticalAlignmentMode = .center
        soundLabel.position = CGPoint(x: 0, y: 0)
        soundButton.addChild(soundLabel)
    }
    
    private func setupBackButton() {
        backButton = SKSpriteNode(color: .gray, size: CGSize(width: 200, height: 60))
        backButton.position = CGPoint(x: size.width / 2, y: size.height * 0.2)
        backButton.name = "backButton"
        backButton.zPosition = 1
        addChild(backButton)
        
        let backLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        backLabel.text = "BACK"
        backLabel.fontSize = 32
        backLabel.fontColor = .white
        backLabel.verticalAlignmentMode = .center
        backLabel.position = CGPoint(x: 0, y: 0)
        backButton.addChild(backLabel)
    }
    
    private func updateButtonStates() {
        // Update difficulty button appearance
        let currentDifficulty = loadDifficulty()
        
        if currentDifficulty == .easy {
            easyButton.alpha = 1.0
            normalButton.alpha = 0.5
        } else {
            easyButton.alpha = 0.5
            normalButton.alpha = 1.0
        }
        
        // Update sound button text
        let isMuted = AudioManager.shared.isMuted()
        soundLabel.text = isMuted ? "SOUND: OFF" : "SOUND: ON"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        for node in touchedNodes {
            switch node.name {
            case "easyButton":
                selectDifficulty(.easy)
            case "normalButton":
                selectDifficulty(.normal)
            case "soundButton":
                toggleSound()
            case "backButton":
                goBack()
            default:
                break
            }
        }
    }
    
    private func selectDifficulty(_ difficulty: GameConfiguration.Difficulty) {
        saveDifficulty(difficulty)
        updateButtonStates()
        
        // Visual feedback
        let selectedButton = difficulty == .easy ? easyButton : normalButton
        let pulse = SKAction.sequence([
            SKAction.scale(to: 1.1, duration: 0.1),
            SKAction.scale(to: 1.0, duration: 0.1)
        ])
        selectedButton?.run(pulse)
    }
    
    private func toggleSound() {
        let currentMute = AudioManager.shared.isMuted()
        AudioManager.shared.setMuted(!currentMute)
        updateButtonStates()
        
        // Visual feedback
        let pulse = SKAction.sequence([
            SKAction.scale(to: 1.1, duration: 0.1),
            SKAction.scale(to: 1.0, duration: 0.1)
        ])
        soundButton.run(pulse)
    }
    
    private func goBack() {
        let menuScene = MenuScene(size: size)
        menuScene.scaleMode = scaleMode
        
        let transition = SKTransition.fade(withDuration: 0.5)
        view?.presentScene(menuScene, transition: transition)
    }
    
    // MARK: - Persistence
    
    private func saveDifficulty(_ difficulty: GameConfiguration.Difficulty) {
        UserDefaults.standard.set(difficulty.rawValue, forKey: difficultyKey)
    }
    
    private func loadDifficulty() -> GameConfiguration.Difficulty {
        let rawValue = UserDefaults.standard.string(forKey: difficultyKey) ?? "normal"
        return GameConfiguration.Difficulty(rawValue: rawValue) ?? .normal
    }
}
