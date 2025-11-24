import XCTest
import SwiftCheck
@testable import FartyBird

class AudioManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Clear UserDefaults before each test
        UserDefaults.standard.removeObject(forKey: "FartyBird.IsMuted")
    }
    
    // Feature: farty-bird, Property 31: Mute functionality
    // Validates: Requirements 12.4
    func testMuteFunctionality() {
        property("When muted, sound actions return nil") <- forAll { (soundType: Int) in
            let manager = AudioManager.shared
            manager.setMuted(true)
            
            // Map int to sound type
            let type: AudioManager.SoundType
            switch abs(soundType) % 3 {
            case 0: type = .fart
            case 1: type = .collision
            default: type = .score
            }
            
            let action = manager.soundAction(for: type)
            return action == nil
        }.verbose
    }
    
    // Feature: farty-bird, Property 32: Mute setting persistence
    // Validates: Requirements 12.5
    func testMutePersistence() {
        property("Mute setting persists to UserDefaults") <- forAll { (shouldMute: Bool) in
            let manager = AudioManager.shared
            manager.setMuted(shouldMute)
            
            // Verify it was saved to UserDefaults
            let savedValue = UserDefaults.standard.bool(forKey: "FartyBird.IsMuted")
            
            return savedValue == shouldMute
        }.verbose
    }
    
    func testMuteToggle() {
        let manager = AudioManager.shared
        
        manager.setMuted(false)
        XCTAssertFalse(manager.isMuted())
        
        manager.setMuted(true)
        XCTAssertTrue(manager.isMuted())
    }
    
    func testSoundActionWhenUnmuted() {
        let manager = AudioManager.shared
        manager.setMuted(false)
        
        let action = manager.soundAction(for: .fart)
        XCTAssertNotNil(action)
    }
    
    func testSoundActionWhenMuted() {
        let manager = AudioManager.shared
        manager.setMuted(true)
        
        let action = manager.soundAction(for: .fart)
        XCTAssertNil(action)
    }
}
