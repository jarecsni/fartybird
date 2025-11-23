import XCTest
import SwiftCheck
@testable import FartyBird

class AssetManagerTests: XCTestCase {
    
    // Feature: farty-bird, Property 25: Asset loading from theme directory
    // Validates: Requirements 11.1
    func testAssetLoadingFromThemeDirectory() {
        let manager = AssetManager.shared
        let theme = manager.getCurrentTheme()
        
        // Load character sprites
        let characterSprites = manager.loadCharacterSprites(for: theme)
        XCTAssertFalse(characterSprites.isEmpty, "Character sprites should be loaded")
        XCTAssertNotNil(characterSprites["idle"])
        XCTAssertNotNil(characterSprites["fart"])
        XCTAssertNotNil(characterSprites["falling"])
        
        // Load obstacle sprites
        let obstacleSprites = manager.loadObstacleSprites(for: theme)
        XCTAssertFalse(obstacleSprites.isEmpty, "Obstacle sprites should be loaded")
        XCTAssertNotNil(obstacleSprites["pipeTop"])
        XCTAssertNotNil(obstacleSprites["pipeBottom"])
        
        // Load background sprites
        let backgroundSprites = manager.loadBackgroundSprites(for: theme)
        XCTAssertFalse(backgroundSprites.isEmpty, "Background sprites should be loaded")
        XCTAssertNotNil(backgroundSprites["sky"])
        XCTAssertNotNil(backgroundSprites["ground"])
    }
    
    // Feature: farty-bird, Property 27: Missing asset handling
    // Validates: Requirements 11.5
    func testMissingAssetHandling() {
        property("Game continues with placeholders when assets are missing") <- forAll { (themeName: String) in
            let manager = AssetManager.shared
            
            // Try to load from a non-existent theme
            let sprites = manager.loadCharacterSprites(for: themeName)
            
            // Should return placeholders, not crash
            return !sprites.isEmpty
        }.verbose
    }
    
    func testThemeSwitching() {
        let manager = AssetManager.shared
        let initialTheme = manager.getCurrentTheme()
        
        // Set a new theme
        manager.setCurrentTheme("chicken")
        XCTAssertEqual(manager.getCurrentTheme(), "chicken")
        
        // Try to set invalid theme (should not change)
        manager.setCurrentTheme("nonexistent")
        XCTAssertEqual(manager.getCurrentTheme(), "chicken")
    }
    
    func testUISpritesLoading() {
        let manager = AssetManager.shared
        let uiSprites = manager.loadUISprites()
        
        XCTAssertNotNil(uiSprites["playButton"])
        XCTAssertNotNil(uiSprites["titleLogo"])
        XCTAssertNotNil(uiSprites["settingsIcon"])
        XCTAssertNotNil(uiSprites["soundOnIcon"])
        XCTAssertNotNil(uiSprites["soundOffIcon"])
    }
}
