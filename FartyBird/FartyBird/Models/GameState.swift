import Foundation
import CoreGraphics

struct GameState {
    var currentScore: Int
    var isPlaying: Bool
    var isPaused: Bool
    var characterPosition: CGPoint
    
    static var initial: GameState {
        return GameState(
            currentScore: 0,
            isPlaying: false,
            isPaused: false,
            characterPosition: .zero
        )
    }
}
