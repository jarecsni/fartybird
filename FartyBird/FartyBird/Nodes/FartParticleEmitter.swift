import SpriteKit

class FartParticleEmitter {
    
    static func createFartParticles() -> SKEmitterNode {
        let emitter = SKEmitterNode()
        
        // Particle texture (small circle)
        emitter.particleTexture = SKTexture(imageNamed: "spark") // Will use default if not found
        
        // Birth rate - REDUCED to not cover chicken
        emitter.particleBirthRate = 30
        emitter.numParticlesToEmit = 8
        
        // Lifetime
        emitter.particleLifetime = 0.3
        emitter.particleLifetimeRange = 0.1
        
        // Position range
        emitter.particlePositionRange = CGVector(dx: 5, dy: 5)
        
        // Speed
        emitter.particleSpeed = 30
        emitter.particleSpeedRange = 10
        
        // Emission angle (downward)
        emitter.emissionAngle = CGFloat.pi * 1.5 // 270 degrees (down)
        emitter.emissionAngleRange = CGFloat.pi * 0.25
        
        // Scale - SMALLER
        emitter.particleScale = 0.15
        emitter.particleScaleRange = 0.05
        emitter.particleScaleSpeed = -0.3
        
        // Color (white/yellow for fart cloud)
        emitter.particleColor = .white
        emitter.particleColorBlendFactor = 1.0
        emitter.particleColorSequence = nil
        
        // Alpha - MORE TRANSPARENT
        emitter.particleAlpha = 0.4
        emitter.particleAlphaRange = 0.1
        emitter.particleAlphaSpeed = -2.0
        
        // Blend mode
        emitter.particleBlendMode = .alpha
        
        // Z position
        emitter.zPosition = -1
        
        // Target node (so particles don't move with character)
        emitter.targetNode = nil // Will be set to scene when added
        
        // Explicitly ensure no physics body
        emitter.physicsBody = nil
        
        return emitter
    }
}
