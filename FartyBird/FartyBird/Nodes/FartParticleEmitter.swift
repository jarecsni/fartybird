import SpriteKit

class FartParticleEmitter {
    
    static func createFartParticles() -> SKEmitterNode {
        let emitter = SKEmitterNode()
        
        // Create a circular particle texture programmatically
        let size = CGSize(width: 32, height: 32)
        let renderer = UIGraphicsImageRenderer(size: size)
        let circleImage = renderer.image { context in
            // Draw a soft circular gradient
            let rect = CGRect(origin: .zero, size: size)
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let radius = size.width / 2
            
            // Create radial gradient (white center fading to transparent)
            let colors = [UIColor.white.cgColor, UIColor.white.withAlphaComponent(0).cgColor]
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: [0.0, 1.0])!
            
            context.cgContext.drawRadialGradient(
                gradient,
                startCenter: center,
                startRadius: 0,
                endCenter: center,
                endRadius: radius,
                options: []
            )
        }
        
        emitter.particleTexture = SKTexture(image: circleImage)
        
        // Birth rate - create a nice visible puff cloud
        emitter.particleBirthRate = 300
        emitter.numParticlesToEmit = 25
        
        // Lifetime - cloud expands then disappears
        emitter.particleLifetime = 0.7
        emitter.particleLifetimeRange = 0.2
        
        // Position range - tight cluster
        emitter.particlePositionRange = CGVector(dx: 5, dy: 5)
        
        // Speed - slow expansion
        emitter.particleSpeed = 25
        emitter.particleSpeedRange = 15
        
        // Emission angle (downward and backward)
        emitter.emissionAngle = CGFloat.pi * 1.25 // 225 degrees (down-left)
        emitter.emissionAngleRange = CGFloat.pi * 0.5
        
        // Scale - start small, grow to half chicken size
        emitter.particleScale = 0.3
        emitter.particleScaleRange = 0.1
        emitter.particleScaleSpeed = 1.5 // Grow big
        
        // Color (gray cloud)
        emitter.particleColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
        emitter.particleColorBlendFactor = 1.0
        emitter.particleColorSequence = nil
        
        // Alpha - more visible
        emitter.particleAlpha = 0.85
        emitter.particleAlphaRange = 0.15
        emitter.particleAlphaSpeed = -1.3 // Fade as it grows
        
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
