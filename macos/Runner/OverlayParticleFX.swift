import Cocoa

/// Mirrors EffectsEngine._spawnParticles / _angleForDirection in
/// lib/effects/effects_engine.dart. Creates CAShapeLayers and registers
/// ParticleRecord with AnimationDriver instead of CAAnimation.
class OverlayParticleFX {
    func spawn(at point: NSPoint, config: ActionConfig.ConfigData, parent: CALayer, driver: AnimationDriver) {
        let count = min(config.particleCount ?? 16, 60)
        let size = CGFloat(config.particleSize ?? 12)
        let durationValue = config.particleDuration ?? 780
        let duration = Double(durationValue) / 1000.0
        let opacity = CGFloat(config.particleOpacity ?? 88) / 100.0
        let palette = config.particlePalette ?? ["#F59E0B"]
        let baseColor = hexColor(palette.first)
        let style = config.particleStyle ?? "点状粒子"

        // ── Orbital motion ──
        if config.particleMotionMode == "orbital" {
            let radius = CGFloat(config.orbitalRadius ?? 32)
            let orbits = CGFloat(config.orbitalSpeed ?? 3)

            for i in 0..<count {
                let shapeLayer = CAShapeLayer()
                let particleSize = size * CGFloat.random(in: 0.5...1.0)
                shapeLayer.path = pathForStyle(style, size: particleSize)
                shapeLayer.fillColor = baseColor.withAlphaComponent(opacity).cgColor
                shapeLayer.position = point
                shapeLayer.opacity = Float(opacity)
                parent.addSublayer(shapeLayer)

                let startAngle = (2 * .pi / CGFloat(count)) * CGFloat(i)
                let record = ParticleRecord(
                    layer: shapeLayer,
                    startX: point.x, startY: point.y,
                    deltaX: 0, deltaY: 0,
                    startOpacity: Float(opacity),
                    duration: duration,
                    easing: "缓出",
                    isOrbital: true,
                    orbitalRadius: radius,
                    orbitalSpeed: orbits,
                    startAngle: startAngle
                )
                driver.addParticle(record)
            }
            return
        }

        // ── Burst / directional ──
        let spread = CGFloat(config.particleSpread ?? 60)
        let direction = config.particleDirection ?? "四周扩散"
        let gravity = CGFloat(config.particleGravity ?? 0)
        let wind = CGFloat(config.particleWind ?? 0)
        let hasTrail = config.particleTrail == true

        for i in 0..<count {
            let angle: CGFloat
            switch direction {
            case "向上喷发":
                angle = CGFloat.random(in: -.pi * 0.9 ... .pi * 0.9)
            case "旋转扫射":
                let step = (.pi * 2) / CGFloat(count)
                angle = step * CGFloat(i) + CGFloat.random(in: -0.15...0.15)
            default: // 四周扩散, 随机散射
                angle = CGFloat.random(in: 0...(2 * .pi))
            }

            let dist = CGFloat.random(in: 0.4...1.0) * spread
            let endX = cos(angle) * dist + wind * dist * 0.02
            let endY = sin(angle) * dist + gravity * dist * 0.03
            let particleSize = size * CGFloat.random(in: 0.5...1.0)

            // Main particle
            let shapeLayer = makeParticleLayer(style: style, size: particleSize,
                                                color: baseColor, opacity: opacity,
                                                point: point)
            parent.addSublayer(shapeLayer)

            let record = ParticleRecord(
                layer: shapeLayer,
                startX: point.x, startY: point.y,
                deltaX: endX, deltaY: endY,
                startOpacity: Float(opacity),
                duration: duration,
                easing: "缓出"
            )
            driver.addParticle(record)

            // Trail ghosts
            if hasTrail {
                let ghostCount = 3
                for g in 0..<ghostCount {
                    let ghostOpacity = opacity * CGFloat(1.0 - Double(g) * 0.25)
                    let ghostSize = particleSize * CGFloat(1.0 - Double(g) * 0.12)
                    let ghostLayer = makeParticleLayer(style: style, size: ghostSize,
                                                        color: baseColor, opacity: ghostOpacity,
                                                        point: point)
                    parent.addSublayer(ghostLayer)

                    let trailDelay = Double(g) * duration * 0.08
                    let ghostRecord = ParticleRecord(
                        layer: ghostLayer,
                        startX: point.x, startY: point.y,
                        deltaX: endX, deltaY: endY,
                        startOpacity: Float(ghostOpacity),
                        duration: duration,
                        easing: "缓出",
                        startDelay: trailDelay
                    )
                    driver.addParticle(ghostRecord)
                }
            }
        }
    }

    // MARK: - Helpers

    private func makeParticleLayer(style: String, size: CGFloat, color: NSColor,
                                    opacity: CGFloat, point: NSPoint) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.path = pathForStyle(style, size: size)
        layer.fillColor = color.withAlphaComponent(opacity).cgColor
        layer.position = point
        layer.opacity = Float(opacity)
        return layer
    }

    private func pathForStyle(_ style: String, size: CGFloat) -> CGPath {
        switch style {
        case "方块":
            return CGPath(rect: CGRect(x: -size / 2, y: -size / 2, width: size, height: size), transform: nil)
        case "钻石":
            let diamond = CGMutablePath()
            diamond.move(to: CGPoint(x: 0, y: -size / 2))
            diamond.addLine(to: CGPoint(x: size / 2, y: 0))
            diamond.addLine(to: CGPoint(x: 0, y: size / 2))
            diamond.addLine(to: CGPoint(x: -size / 2, y: 0))
            diamond.closeSubpath()
            return diamond
        case "火花":
            let spark = CGMutablePath()
            spark.move(to: CGPoint(x: 0, y: -size / 2))
            spark.addLine(to: CGPoint(x: size / 3, y: size / 3))
            spark.addLine(to: CGPoint(x: -size / 3, y: size / 3))
            spark.closeSubpath()
            return spark
        default:
            return CGPath(ellipseIn: CGRect(x: -size / 2, y: -size / 2, width: size, height: size), transform: nil)
        }
    }
}
