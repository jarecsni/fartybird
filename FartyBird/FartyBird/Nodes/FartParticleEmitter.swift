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
        
        // Birth rate - explosive burst
        emitter.particleBirthRate = 800
        emitter.numParticlesToEmit = 40
        
        // Lifetime - cloud expands then disappears
        emitter.particleLifetime = 0.5
        emitter.particleLifetimeRange = 0.1
        
        // Position range - single point source
        emitter.particlePositionRange = CGVector(dx: 1, dy: 1)
        
        // Speed - very fast explosive burst
        emitter.particleSpeed = 120
        emitter.particleSpeedRange = 50
        
        // Emission angle (focused backward jet)
        emitter.emissionAngle = CGFloat.pi // 180 degrees (straight left)
        emitter.emissionAngleRange = CGFloat.pi * 0.25 // Tighter cone
        
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
        
        // Acceleration - strong drag to slow down the burst
        emitter.xAcceleration = 100 // Strong drag effect
        emitter.yAcceleration = -30 // Downward drift
        
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
