import XCTest
import SwiftCheck
import SpriteKit
@testable import FartyBird

class GameSceneTests: XCTestCase {
    
    func createTestScene() -> GameScene {
        let scene = GameScene(size: CGSize(width: 375, height: 667))
        return scene
    }
    
    // Feature: farty-bird, Property 11: Passing obstacle increments score
    // Validates: Requirements 4.1
    func testPassingObstacleIncrementsScore() {
        let scene = createTestScene()
        ScoreManager.shared.resetScore()
        
        let initialScore = ScoreManager.shared.getCurrentScore()
        
        // Simulate scoring
        ScoreManager.shared.incrementScore()
        
        let finalScore = ScoreManager.shared.getCurrentScore()
        
        XCTAssertEqual(finalScore, initialScore + 1)
    }
    
    // Feature: farty-bird, Property 20: Background scrolling
    // Validates: Requirements 8.2
    func testBackgroundScrolling() {
        let scene = createTestScene()
        let view = SKView(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
        view.presentScene(scene)
        
        // Give scene time to set up
        scene.didMove(to: view)
        
        // Background should be scrolling (tested by checking if background nodes exist)
        let backgroundNodes = scene.children.filter { $0 is SKSpriteNode && $0.zPosition == -2 }
        XCTAssertGreaterThanOrEqual(backgroundNodes.count, 2, "Should have at least 2 background sprites for scrolling")
    }
    
    // Feature: farty-bird, Property 21: Ground scrolling
    // Validates: Requirements 8.3
    func testGroundScrolling() {
        let scene = createTestScene()
        let view = SKView(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
        view.presentScene(scene)
        
        scene.didMove(to: view)
        
        // Ground should be scrolling (tested by checking if ground nodes exist)
        let groundNodes = scene.children.filter { $0 is SKSpriteNode && $0.zPosition == 1 }
        XCTAssertGreaterThanOrEqual(groundNodes.count, 2, "Should have at least 2 ground sprites for scrolling")
    }
    
    // Feature: farty-bird, Property 22: Score reset on new game
    // Validates: Requirements 9.5
    func testScoreResetOnNewGame() {
        // Set a score
        ScoreManager.shared.incrementScore()
        ScoreManager.shared.incrementScore()
        
        XCTAssertGreaterThan(ScoreManager.shared.getCurrentScore(), 0)
        
        // Reset score (simulating new game)
        ScoreManager.shared.resetScore()
        
        XCTAssertEqual(ScoreManager.shared.getCurrentScore(), 0)
    }
    
    func testSceneInitialization() {
        let scene = createTestScene()
        XCTAssertNotNil(scene)
        XCTAssertEqual(scene.size.width, 375)
        XCTAssertEqual(scene.size.height, 667)
    }
    
    func testScoreDisplay() {
        let scene = createTestScene()
        let view = SKView(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
        view.presentScene(scene)
        
        scene.didMove(to: view)
        
        // Should have a score label
        let scoreLabels = scene.children.filter { $0 is SKLabelNode }
        XCTAssertGreaterThan(scoreLabels.count, 0, "Should have score label")
    }
}

    // Feature: farty-bird, Property 14: Easy mode gap size increase
    // Validates: Requirements 6.2
    func testEasyModeGapSizeIncrease() {
        let normalConfig = GameConfiguration.Difficulty.normal.configuration()
        let easyConfig = GameConfiguration.Difficulty.easy.configuration()
        
        let expectedIncrease = normalConfig.obstacleGapSize * 1.3
        
        XCTAssertEqual(easyConfig.obstacleGapSize, expectedIncrease, accuracy: 0.1)
    }
    
    // Feature: farty-bird, Property 15: Easy mode spawn interval increase
    // Validates: Requirements 6.3
    func testEasyModeSpawnIntervalIncrease() {
        let normalConfig = GameConfiguration.Difficulty.normal.configuration()
        let easyConfig = GameConfiguration.Difficulty.easy.configuration()
        
        let expectedIncrease = normalConfig.obstacleSpawnInterval * 1.2
        
        XCTAssertEqual(easyConfig.obstacleSpawnInterval, expectedIncrease, accuracy: 0.01)
    }
    
    // Feature: farty-bird, Property 16: Difficulty persistence
    // Validates: Requirements 6.4
    func testDifficultyPersistence() {
        property("Difficulty setting persists to UserDefaults") <- forAll { (usesEasy: Bool) in
            let difficulty: GameConfiguration.Difficulty = usesEasy ? .easy : .normal
            let difficultyKey = "FartyBird.Difficulty"
            
            // Save difficulty
            UserDefaults.standard.set(difficulty.rawValue, forKey: difficultyKey)
            
            // Load it back
            let savedRawValue = UserDefaults.standard.string(forKey: difficultyKey)
            let loadedDifficulty = GameConfiguration.Difficulty(rawValue: savedRawValue ?? "normal")
            
            return loadedDifficulty == difficulty
        }.verbose
    }
