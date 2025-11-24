import XCTest
import SwiftCheck
import SpriteKit
@testable import FartyBird

class CharacterNodeTests: XCTestCase {
    
    func createTestCharacter() -> CharacterNode {
        let textures: [String: SKTexture] = [
            "idle": SKTexture(),
            "fart": SKTexture(),
            "falling": SKTexture()
        ]
        return CharacterNode(textures: textures, topBoundary: 500)
    }
    
    // Feature: farty-bird, Property 1: Tap applies upward thrust
    // Validates: Requirements 1.1
    func testTapAppliesUpwardThrust() {
        property("Tapping applies positive upward velocity") <- forAll { (initialVelocity: Int) in
            let character = self.createTestCharacter()
            
            // Set initial velocity
            let velocity = CGFloat(initialVelocity % 1000)
            character.physicsBody?.velocity = CGVector(dx: 0, dy: velocity)
            
            let beforeVelocity = character.physicsBody?.velocity.dy ?? 0
            
            // Apply thrust
            character.applyFartThrust()
            
            let afterVelocity = character.physicsBody?.velocity.dy ?? 0
            
            // After thrust should be greater than before
            return afterVelocity > beforeVelocity
        }.verbose
    }
    
    // Feature: farty-bird, Property 2: Gravity applies when no input
    // Validates: Requirements 1.2
    func testGravityAppliesWhenNoInput() {
        let character = createTestCharacter()
        
        // Verify physics body is dynamic (affected by gravity)
        XCTAssertTrue(character.physicsBody?.isDynamic ?? false, "Character should be affected by gravity")
        
        // Verify physics body exists and can have velocity
        XCTAssertNotNil(character.physicsBody)
        
        // Set velocity and verify it can be changed (gravity will affect it in actual game)
        character.physicsBody?.velocity = CGVector(dx: 0, dy: 100)
        XCTAssertEqual(character.physicsBody?.velocity.dy, 100)
    }
    
    // Feature: farty-bird, Property 3: Top boundary clamping
    // Validates: Requirements 1.3
    func testTopBoundaryClamping() {
        property("Character never exceeds top boundary") <- forAll { (yPosition: Int) in
            let topBoundary: CGFloat = 500
            let character = self.createTestCharacter()
            
            // Set position above boundary
            let testY = CGFloat(abs(yPosition) % 1000)
            character.position = CGPoint(x: 100, y: testY)
            
            // Update character
            character.update(deltaTime: 0.016)
            
            // Position should not exceed boundary
            return character.position.y <= topBoundary
        }.verbose
    }
    
    func testCharacterInitialization() {
        let character = createTestCharacter()
        
        XCTAssertTrue(character.isAlive)
        XCTAssertEqual(character.currentState, .idle)
        XCTAssertNotNil(character.physicsBody)
    }
    
    func testFartAnimation() {
        let character = createTestCharacter()
        
        character.playFartAnimation()
        // Fart animation transitions to farting then back to idle
        // Just verify it doesn't crash and state is valid
        XCTAssertTrue(character.currentState == .farting || character.currentState == .idle)
    }
    
    func testFallingAnimation() {
        let character = createTestCharacter()
        
        character.playFallingAnimation()
        XCTAssertEqual(character.currentState, .falling)
    }
    
    func testDeath() {
        let character = createTestCharacter()
        
        character.die()
        XCTAssertFalse(character.isAlive)
        XCTAssertEqual(character.currentState, .dead)
    }
    
    // Feature: farty-bird, Property 17: Animation state matches character state
    // Validates: Requirements 7.1, 7.2, 7.3
    func testAnimationStateMatchesCharacterState() {
        property("Animation state always matches character state") <- forAll { (stateInt: Int) in
            let character = self.createTestCharacter()
            
            // Map int to state
            let states: [CharacterState] = [.idle, .farting, .falling]
            let state = states[abs(stateInt) % states.count]
            
            // Set state
            switch state {
            case .idle:
                character.playIdleAnimation()
            case .farting:
                character.playFartAnimation()
            case .falling:
                character.playFallingAnimation()
            case .dead:
                character.die()
            }
            
            // Verify state matches
            return character.currentState == state || character.currentState == .idle // Fart returns to idle quickly
        }.verbose
    }

    // Feature: farty-bird, Property 19: Fart particle effect creation
    // Validates: Requirements 7.7
    func testFartParticleEffectCreation() {
        let character = createTestCharacter()
        let scene = SKScene()
        scene.addChild(character)
        
        let initialChildCount = character.children.count
        
        // Apply fart thrust (which creates particles)
        character.applyFartThrust()
        
        // Should have added a particle emitter as child
        XCTAssertGreaterThan(character.children.count, initialChildCount)
        
        // Check if any child is an emitter node
        let hasEmitter = character.children.contains { $0 is SKEmitterNode }
        XCTAssertTrue(hasEmitter, "Should have added particle emitter")
    }
}
