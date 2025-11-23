import XCTest
import SwiftCheck
@testable import FartyBird

class ScoreManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Clear UserDefaults before each test
        UserDefaults.standard.removeObject(forKey: "FartyBird.HighScore")
    }
    
    // Feature: farty-bird, Property 13: High score persistence
    // Validates: Requirements 4.4, 5.1
    func testHighScorePersistence() {
        property("High score persists across manager instances") <- forAll { (score: Int) in
            // Ensure score is positive
            let positiveScore = abs(score)
            
            // Update high score
            ScoreManager.shared.updateHighScore(positiveScore)
            
            // Create a new instance (simulating app restart)
            let newManager = ScoreManager()
            
            // Verify the high score was persisted
            return newManager.getHighScore() == positiveScore
        }.verbose
    }
    
    func testScoreIncrement() {
        let manager = ScoreManager.shared
        manager.resetScore()
        
        let initialScore = manager.getCurrentScore()
        manager.incrementScore()
        
        XCTAssertEqual(manager.getCurrentScore(), initialScore + 1)
    }
    
    func testScoreReset() {
        let manager = ScoreManager.shared
        manager.incrementScore()
        manager.incrementScore()
        manager.resetScore()
        
        XCTAssertEqual(manager.getCurrentScore(), 0)
    }
    
    func testHighScoreUpdate() {
        let manager = ScoreManager.shared
        
        manager.updateHighScore(10)
        XCTAssertEqual(manager.getHighScore(), 10)
        
        // Lower score shouldn't update
        manager.updateHighScore(5)
        XCTAssertEqual(manager.getHighScore(), 10)
        
        // Higher score should update
        manager.updateHighScore(15)
        XCTAssertEqual(manager.getHighScore(), 15)
    }
}
