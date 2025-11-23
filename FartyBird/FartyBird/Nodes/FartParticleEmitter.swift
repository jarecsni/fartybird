import SpriteKit

class FartParticleEmitter {
    
    static func createFartParticles() -> SKEmitterNode {
        let emitter = SKEmitterNode()
        
        // Particle texture (small circle)
        emitter.particleTexture = SKTexture(imageNamed: "spark") // Will use default if not found
        
        // Birth rate
        emitter.particleBirthRate = 100
        emitter.numParticlesToEmit = 20
        
        // Lifetime
        emitter.particleLifetime = 0.5
        emitter.particleLifetimeRange = 0.2
        
        // Position range
        emitter.particlePositionRange = CGVector(dx: 10, dy: 10)
        
        // Speed
        emitter.particleSpeed = 50
        emitter.particleSpeedRange = 20
        
        // Emission angle (downward)
        emitter.emissionAngle = CGFloat.pi * 1.5 // 270 degrees (down)
        emitter.emissionAngleRange = CGFloat.pi * 0.25
        
        // Scale
        emitter.particleScale = 0.3
        emitter.particleScaleRange = 0.1
        emitter.particleScaleSpeed = -0.2
        
        // Color (white/yellow for fart cloud)
        emitter.particleColor = .white
        emitter.particleColorBlendFactor = 1.0
        emitter.particleColorSequence = nil
        
        // Alpha
        emitter.particleAlpha = 0.8
        emitter.particleAlphaRange = 0.2
        emitter.particleAlphaSpeed = -1.5
        
        // Blend mode
        emitter.particleBlendMode = .alpha
        
        // Z position
        emitter.zPosition = -1
        
        // Target node (so particles don't move with character)
        emitter.targetNode = nil // Will be set to scene when added
        
        return emitter
    }
}
