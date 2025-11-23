import Foundation
import SpriteKit

struct PhysicsCategory {
    static let none: UInt32 = 0
    static let character: UInt32 = 0b1      // 1
    static let obstacle: UInt32 = 0b10      // 2
    static let ground: UInt32 = 0b100       // 4
    static let scoreZone: UInt32 = 0b1000   // 8
}

class PhysicsManager {
    
    // MARK: - Physics World Setup
    
    func setupPhysicsWorld(for scene: SKScene) {
        scene.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        scene.physicsWorld.contactDelegate = scene as? SKPhysicsContactDelegate
    }
    
    // MARK: - Collision Handling
    
    func handleCollision(between nodeA: SKNode, and nodeB: SKNode, in scene: SKScene) {
        let categoryA = nodeA.physicsBody?.categoryBitMask ?? 0
        let categoryB = nodeB.physicsBody?.categoryBitMask ?? 0
        
        // Check for character collision with obstacle or ground
        if (categoryA == PhysicsCategory.character && (categoryB == PhysicsCategory.obstacle || categoryB == PhysicsCategory.ground)) ||
           (categoryB == PhysicsCategory.character && (categoryA == PhysicsCategory.obstacle || categoryA == PhysicsCategory.ground)) {
            // Trigger game over
            triggerGameOver(in: scene)
        }
        
        // Check for character passing through score zone
        if (categoryA == PhysicsCategory.character && categoryB == PhysicsCategory.scoreZone) ||
           (categoryB == PhysicsCategory.character && categoryA == PhysicsCategory.scoreZone) {
            // Increment score
            ScoreManager.shared.incrementScore()
            
            // Remove the score zone so it doesn't trigger again
            if categoryA == PhysicsCategory.scoreZone {
                nodeA.removeFromParent()
            } else {
                nodeB.removeFromParent()
            }
        }
    }
    
    private func triggerGameOver(in scene: SKScene) {
        // This will be implemented by the GameScene
        // For now, just post a notification
        NotificationCenter.default.post(name: NSNotification.Name("GameOver"), object: nil)
    }
}
