import XCTest
import SwiftCheck
import SpriteKit
@testable import FartyBird

class ObstacleManagerTests: XCTestCase {
    
    func createTestManager() -> ObstacleManager {
        let config = GameConfiguration.default
        let topTexture = SKTexture()
        let bottomTexture = SKTexture()
        let screenSize = CGSize(width: 375, height: 667)
        
        return ObstacleManager(
            config: config,
            topTexture: topTexture,
            bottomTexture: bottomTexture,
            screenSize: screenSize
        )
    }
    
    // Feature: farty-bird, Property 4: Regular obstacle spawning
    // Validates: Requirements 2.1
    func testRegularObstacleSpawning() {
        let manager = createTestManager()
        let scene = SKScene()
        
        let spawnInterval = manager.spawnInterval
        
        // Update for spawn interval duration
        manager.updateObstacles(deltaTime: spawnInterval)
        
        // Should be ready to spawn
        XCTAssertTrue(manager.shouldSpawnObstacle())
        
        // Spawn obstacle
        manager.generateNextObstacle(in: scene)
        
        // Should have one obstacle
        XCTAssertEqual(manager.getObstacleCount(), 1)
    }
    
    // Feature: farty-bird, Property 5: Constant obstacle scroll speed
    // Validates: Requirements 2.2
    func testConstantObstacleScrollSpeed() {
        let manager = createTestManager()
        let scene = SKScene()
        
        // Spawn multiple obstacles
        manager.generateNextObstacle(in: scene)
        manager.generateNextObstacle(in: scene)
        manager.generateNextObstacle(in: scene)
        
        let obstacles = manager.getObstacles()
        let initialPositions = obstacles.map { $0.position.x }
        
        // Update obstacles
        let deltaTime: TimeInterval = 0.1
        manager.updateObstacles(deltaTime: deltaTime)
        
        let finalPositions = obstacles.map { $0.position.x }
        
        // Calculate distances moved
        let distances = zip(initialPositions, finalPositions).map { $0 - $1 }
        
        // All distances should be equal (same speed)
        let firstDistance = distances.first ?? 0
        let allEqual = distances.allSatisfy { abs($0 - firstDistance) < 0.01 }
        
        XCTAssertTrue(allEqual, "All obstacles should move at the same speed")
    }
    
    // Feature: farty-bird, Property 6: Offscreen obstacle cleanup
    // Validates: Requirements 2.3
    func testOffscreenObstacleCleanup() {
        let manager = createTestManager()
        let scene = SKScene()
        
        // Spawn obstacle
        manager.spawnObstacle(at: CGPoint(x: -150, y: 0), in: scene)
        
        XCTAssertEqual(manager.getObstacleCount(), 1)
        
        // Remove offscreen obstacles
        manager.removeOffscreenObstacles()
        
        // Should be removed
        XCTAssertEqual(manager.getObstacleCount(), 0)
    }
    
    // Feature: farty-bird, Property 7: Obstacle gap size consistency
    // Validates: Requirements 2.4
    func testObstacleGapSizeConsistency() {
        let manager = createTestManager()
        let scene = SKScene()
        
        // Spawn multiple obstacles
        for _ in 0..<5 {
            manager.generateNextObstacle(in: scene)
        }
        
        let obstacles = manager.getObstacles()
        let gapSizes = obstacles.map { $0.gapSize }
        
        // All gap sizes should match the configured gap size
        let expectedGapSize = manager.gapSize
        let allMatch = gapSizes.allSatisfy { $0 == expectedGapSize }
        
        XCTAssertTrue(allMatch, "All obstacles should have the same gap size")
    }
    
    // Feature: farty-bird, Property 8: Gap position variation
    // Validates: Requirements 2.5
    func testGapPositionVariation() {
        property("Gap positions vary across obstacles") <- forAll { (seed: Int) in
            let manager = self.createTestManager()
            let scene = SKScene()
            
            // Spawn many obstacles to ensure variation
            for _ in 0..<50 {
                manager.generateNextObstacle(in: scene)
            }
            
            let obstacles = manager.getObstacles()
            
            // Get gap center Y positions (they vary based on random gap position)
            let gapPositions = obstacles.map { $0.gapCenterY }
            
            // Check if there's variation (not all the same)
            let uniquePositions = Set(gapPositions)
            
            // With 50 random gap positions, we should definitely have variation
            // Require at least 5 different positions to account for rounding
            return uniquePositions.count >= 5
        }.verbose
    }
    
    func testObstacleMovement() {
        let manager = createTestManager()
        let scene = SKScene()
        
        manager.generateNextObstacle(in: scene)
        
        let obstacle = manager.getObstacles().first!
        let initialX = obstacle.position.x
        
        manager.updateObstacles(deltaTime: 0.1)
        
        let finalX = obstacle.position.x
        
        // Obstacle should have moved left
        XCTAssertLessThan(finalX, initialX)
    }
    
    func testReset() {
        let manager = createTestManager()
        let scene = SKScene()
        
        // Spawn obstacles
        manager.generateNextObstacle(in: scene)
        manager.generateNextObstacle(in: scene)
        
        XCTAssertEqual(manager.getObstacleCount(), 2)
        
        // Reset
        manager.reset()
        
        XCTAssertEqual(manager.getObstacleCount(), 0)
    }
}
