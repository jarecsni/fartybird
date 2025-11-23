import Foundation
import CoreGraphics

struct GameConfiguration: Codable {
    var difficulty: Difficulty
    var obstacleGapSize: CGFloat
    var obstacleSpawnInterval: TimeInterval
    var scrollSpeed: CGFloat
    var characterThrust: CGFloat
    var gravity: CGFloat
    
    enum Difficulty: String, Codable {
        case easy
        case normal
        
        func configuration() -> GameConfiguration {
            switch self {
            case .easy:
                return GameConfiguration(
                    difficulty: .easy,
                    obstacleGapSize: 180,
                    obstacleSpawnInterval: 2.4,
                    scrollSpeed: 150,
                    characterThrust: 350,
                    gravity: -9.8
                )
            case .normal:
                return GameConfiguration(
                    difficulty: .normal,
                    obstacleGapSize: 140,
                    obstacleSpawnInterval: 2.0,
                    scrollSpeed: 150,
                    characterThrust: 350,
                    gravity: -9.8
                )
            }
        }
    }
    
    static var `default`: GameConfiguration {
        return Difficulty.normal.configuration()
    }
}
