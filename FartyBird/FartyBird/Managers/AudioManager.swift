import Foundation
import SpriteKit

class AudioManager {
    static let shared = AudioManager()
    
    private var isMutedValue: Bool = false
    private let muteKey = "FartyBird.IsMuted"
    
    // Sound file names
    private let fartSoundFile = "fart.wav"
    private let collisionSoundFile = "collision.wav"
    private let scoreSoundFile = "score.wav"
    
    private init() {
        loadMuteState()
    }
    
    // MARK: - Sound Playback
    
    func playFartSound() {
        guard !isMutedValue else { return }
        playSound(named: fartSoundFile)
    }
    
    func playCollisionSound() {
        guard !isMutedValue else { return }
        playSound(named: collisionSoundFile)
    }
    
    func playScoreSound() {
        guard !isMutedValue else { return }
        playSound(named: scoreSoundFile)
    }
    
    private func playSound(named filename: String) {
        // This will be called from SKScene, so we return an SKAction
        // The actual playback will be handled by the scene
        // For now, we just log (actual implementation will use SKAction.playSoundFileNamed)
        #if DEBUG
        print("Playing sound: \(filename)")
        #endif
    }
    
    // MARK: - Settings
    
    func setMuted(_ muted: Bool) {
        isMutedValue = muted
        saveMuteState()
    }
    
    func isMuted() -> Bool {
        return isMutedValue
    }
    
    // MARK: - Persistence
    
    private func saveMuteState() {
        UserDefaults.standard.set(isMutedValue, forKey: muteKey)
    }
    
    private func loadMuteState() {
        isMutedValue = UserDefaults.standard.bool(forKey: muteKey)
        // bool(forKey:) returns false if key doesn't exist, which is perfect (unmuted by default)
    }
    
    // MARK: - Helper for Scenes
    
    func soundAction(for soundType: SoundType) -> SKAction? {
        guard !isMutedValue else { return nil }
        
        let filename: String
        switch soundType {
        case .fart:
            filename = fartSoundFile
        case .collision:
            filename = collisionSoundFile
        case .score:
            filename = scoreSoundFile
        }
        
        return SKAction.playSoundFileNamed(filename, waitForCompletion: false)
    }
    
    enum SoundType {
        case fart
        case collision
        case score
    }
}
