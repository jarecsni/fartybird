import XCTest
import SwiftCheck
@testable import FartyBird

class ScoreManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Clear UserDefaults before each test
        UserDefaults.standard.removeObject(forKey: "FartyBird.HighScore")
        // Force reload from UserDefaults
        ScoreManager.shared.updateHighScore(0)
    }
    
    // Feature: farty-bird, Property 13: High score persistence
    // Validates: Requirements 4.4, 5.1
    func testHighScorePersistence() {
        property("High score persists to UserDefaults") <- forAll { (score: Int) in
            // Ensure score is positive and non-zero
            let positiveScore = max(1, abs(score) % 10000)
            
            // Clear and reset before each iteration
            UserDefaults.standard.removeObject(forKey: "FartyBird.HighScore")
            ScoreManager.shared.reloadHighScore()
            
            // Update high score
            ScoreManager.shared.updateHighScore(positiveScore)
            
            // Verify it was saved to UserDefaults
            let savedValue = UserDefaults.standard.integer(forKey: "FartyBird.HighScore")
            
            return savedValue == positiveScore
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
        
        // Reset to known state
        UserDefaults.standard.removeObject(forKey: "FartyBird.HighScore")
        manager.reloadHighScore()
        
        manager.updateHighScore(10)
        XCTAssertEqual(manager.getHighScore(), 10)
        
        // Lower score shouldn't update
        manager.updateHighScore(5)
        XCTAssertEqual(manager.getHighScore(), 10)
        
        // Higher score should update
        manager.updateHighScore(15)
        XCTAssertEqual(manager.getHighScore(), 15)
    }
    
    // Feature: farty-bird, Property 12: High score comparison
    // Validates: Requirements 4.3
    func testHighScoreComparison() {
        property("High score only updates when new score exceeds current high score") <- forAll { (currentHigh: Int, newScore: Int) in
            // Ensure scores are positive
            let positiveHigh = abs(currentHigh)
            let positiveNew = abs(newScore)
            
            // Set initial high score
            ScoreManager.shared.updateHighScore(positiveHigh)
            let initialHigh = ScoreManager.shared.getHighScore()
            
            // Attempt to update with new score
            ScoreManager.shared.updateHighScore(positiveNew)
            let finalHigh = ScoreManager.shared.getHighScore()
            
            // High score should be the maximum of the two
            return finalHigh == max(initialHigh, positiveNew)
        }.verbose
    }
    
    // Feature: farty-bird, Property 22: Score reset on new game
    // Validates: Requirements 9.5
    func testScoreResetOnNewGame() {
        property("Starting a new game resets score to zero") <- forAll { (randomScore: Int) in
            let manager = ScoreManager.shared
            
            // Set score to some random value
            let positiveScore = abs(randomScore) % 1000
            for _ in 0..<positiveScore {
                manager.incrementScore()
            }
            
            // Reset score (simulating new game start)
            manager.resetScore()
            
            // Score should be zero
            return manager.getCurrentScore() == 0
        }.verbose
    }
}
