import Foundation
import SpriteKit

class AssetManager {
    static let shared = AssetManager()
    
    private var assetConfig: AssetConfiguration
    private var currentTheme: String
    
    private init() {
        // Load configuration from JSON
        if let config = AssetManager.loadAssetConfiguration() {
            self.assetConfig = config
            self.currentTheme = config.currentTheme
        } else {
            // Fallback to default configuration
            self.assetConfig = AssetConfiguration.default
            self.currentTheme = "chicken"
        }
    }
    
    // MARK: - Asset Loading
    
    func loadCharacterSprites(for theme: String) -> [String: SKTexture] {
        var sprites: [String: SKTexture] = [:]
        
        // Load from asset catalog (simpler and more reliable)
        sprites["idle"] = SKTexture(imageNamed: "CharacterIdle")
        sprites["fart"] = SKTexture(imageNamed: "CharacterFart")
        sprites["falling"] = SKTexture(imageNamed: "CharacterFalling")
        
        return sprites
    }
    
    func loadObstacleSprites(for theme: String) -> [String: SKTexture] {
        var sprites: [String: SKTexture] = [:]
        
        guard let themePath = assetConfig.themes[theme]?.path else {
            return createPlaceholderObstacleSprites()
        }
        
        // Load pipe top
        if let pipeTopName = assetConfig.assetNames["pipeTop"] {
            sprites["pipeTop"] = loadTexture(named: pipeTopName, in: themePath) ?? createPlaceholderTexture(color: .green, size: CGSize(width: 64, height: 400))
        }
        
        // Load pipe bottom
        if let pipeBottomName = assetConfig.assetNames["pipeBottom"] {
            sprites["pipeBottom"] = loadTexture(named: pipeBottomName, in: themePath) ?? createPlaceholderTexture(color: .green, size: CGSize(width: 64, height: 400))
        }
        
        return sprites
    }
    
    func loadBackgroundSprites(for theme: String) -> [String: SKTexture] {
        var sprites: [String: SKTexture] = [:]
        
        guard let themePath = assetConfig.themes[theme]?.path else {
            return createPlaceholderBackgroundSprites()
        }
        
        // Load sky
        if let skyName = assetConfig.assetNames["backgroundSky"] {
            sprites["sky"] = loadTexture(named: skyName, in: themePath) ?? createPlaceholderTexture(color: .cyan, size: CGSize(width: 512, height: 512))
        }
        
        // Load ground
        if let groundName = assetConfig.assetNames["ground"] {
            sprites["ground"] = loadTexture(named: groundName, in: themePath) ?? createPlaceholderTexture(color: .brown, size: CGSize(width: 512, height: 64))
        }
        
        // Load tombstone
        if let tombstoneName = assetConfig.assetNames["tombstone"] {
            sprites["tombstone"] = loadTexture(named: tombstoneName, in: themePath) ?? createPlaceholderTexture(color: .gray, size: CGSize(width: 48, height: 64))
        }
        
        return sprites
    }
    
    func loadUISprites() -> [String: SKTexture] {
        var sprites: [String: SKTexture] = [:]
        
        // For now, return placeholders for UI elements
        sprites["playButton"] = createPlaceholderTexture(color: .green, size: CGSize(width: 128, height: 64))
        sprites["titleLogo"] = createPlaceholderTexture(color: .orange, size: CGSize(width: 256, height: 128))
        sprites["settingsIcon"] = createPlaceholderTexture(color: .gray, size: CGSize(width: 32, height: 32))
        sprites["soundOnIcon"] = createPlaceholderTexture(color: .blue, size: CGSize(width: 32, height: 32))
        sprites["soundOffIcon"] = createPlaceholderTexture(color: .red, size: CGSize(width: 32, height: 32))
        
        return sprites
    }
    
    // MARK: - Theme Management
    
    func setCurrentTheme(_ theme: String) {
        guard assetConfig.themes[theme] != nil else {
            print("Warning: Theme '\(theme)' not found")
            return
        }
        currentTheme = theme
    }
    
    func getCurrentTheme() -> String {
        return currentTheme
    }
    
    // MARK: - Private Helpers
    
    private func loadTexture(named name: String, in path: String) -> SKTexture? {
        let fullPath = "\(path)/\(name)"
        
        // Try to load from bundle
        if let image = UIImage(named: fullPath) {
            return SKTexture(image: image)
        }
        
        // Log warning if asset not found
        print("Warning: Asset '\(fullPath)' not found, using placeholder")
        return nil
    }
    
    private func createPlaceholderTexture(color: UIColor, size: CGSize) -> SKTexture {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
        return SKTexture(image: image)
    }
    
    private func createPlaceholderCharacterSprites() -> [String: SKTexture] {
        return [
            "idle": createPlaceholderTexture(color: .green, size: CGSize(width: 32, height: 32)),
            "fart": createPlaceholderTexture(color: .yellow, size: CGSize(width: 32, height: 32)),
            "falling": createPlaceholderTexture(color: .red, size: CGSize(width: 32, height: 32))
        ]
    }
    
    private func createPlaceholderObstacleSprites() -> [String: SKTexture] {
        return [
            "pipeTop": createPlaceholderTexture(color: .green, size: CGSize(width: 64, height: 400)),
            "pipeBottom": createPlaceholderTexture(color: .green, size: CGSize(width: 64, height: 400))
        ]
    }
    
    private func createPlaceholderBackgroundSprites() -> [String: SKTexture] {
        return [
            "sky": createPlaceholderTexture(color: .cyan, size: CGSize(width: 512, height: 512)),
            "ground": createPlaceholderTexture(color: .brown, size: CGSize(width: 512, height: 64)),
            "tombstone": createPlaceholderTexture(color: .gray, size: CGSize(width: 48, height: 64))
        ]
    }
    
    private static func loadAssetConfiguration() -> AssetConfiguration? {
        guard let url = Bundle.main.url(forResource: "asset_config", withExtension: "json", subdirectory: "Assets/Config"),
              let data = try? Data(contentsOf: url),
              let config = try? JSONDecoder().decode(AssetConfiguration.self, from: data) else {
            print("Warning: Could not load asset_config.json, using default configuration")
            return nil
        }
        return config
    }
}
