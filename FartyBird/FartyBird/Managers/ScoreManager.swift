import Foundation

class ScoreManager {
    static let shared = ScoreManager()
    
    private var currentScore: Int = 0
    private var highScore: Int = 0
    
    private let highScoreKey = "FartyBird.HighScore"
    
    private init() {
        loadHighScore()
    }
    
    // MARK: - Score Management
    
    func incrementScore() {
        currentScore += 1
    }
    
    func getCurrentScore() -> Int {
        return currentScore
    }
    
    func resetScore() {
        currentScore = 0
    }
    
    // MARK: - High Score
    
    func getHighScore() -> Int {
        return highScore
    }
    
    func updateHighScore(_ score: Int) {
        if score > highScore {
            highScore = score
            saveHighScore()
        }
    }
    
    // MARK: - Persistence
    
    private func saveHighScore() {
        UserDefaults.standard.set(highScore, forKey: highScoreKey)
    }
    
    private func loadHighScore() {
        highScore = UserDefaults.standard.integer(forKey: highScoreKey)
        // integer(forKey:) returns 0 if key doesn't exist, which is perfect for our use case
    }
}
