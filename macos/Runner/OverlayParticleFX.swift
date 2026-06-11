import Cocoa

/// Full particle feedback implementation.
/// Mirrors plugin computeParticleSpecs() and renderParticles().
/// Uses CABasicAnimation (burst) and CAKeyframeAnimation with CGPath (orbital).
class OverlayParticleFX {
    func spawn(at point: NSPoint, config: ActionConfig.ConfigData, parent: CALayer) {
        let count = min(config.particleCount ?? 16, 60)
        let size = CGFloat(config.particleSize ?? 12)
        let durationValue = config.particleDuration ?? 780
        let duration = Double(durationValue) / 1000.0
        let baseOpacity = CGFloat(config.particleOpacity ?? 88) / 100.0
        let palette = config.particlePalette ?? ["#F59E0B"]
        let baseColor = hexColor(palette.first)
        let style = config.particleStyle ?? "点状粒子"
        let baseDelay = Double(config.particleDelay ?? 0) / 1000.0
        let colorMode = config.particleColorMode ?? "跟随主题"

        // ── Orbital motion ──
        if config.particleMotionMode == "orbital" {
            let radius = CGFloat(config.orbitalRadius ?? 32)
            let orbits = CGFloat(config.orbitalSpeed ?? 3)

            for i in 0..<count {
                let shapeLayer = CAShapeLayer()
                let particleSize = size * CGFloat.random(in: 0.5...1.0)
                shapeLayer.path = pathForStyle(style, size: particleSize)
                shapeLayer.fillColor = particleColor(colorMode: colorMode, palette: palette, baseColor: baseColor, index: i, config: config).withAlphaComponent(baseOpacity).cgColor
                shapeLayer.position = point
                shapeLayer.opacity = Float(baseOpacity)

                let startAngle = (2 * .pi / CGFloat(count)) * CGFloat(i)

                // Pre-sample orbital positions (CGPath.addArc doesn't support multi-turn arcs)
                let frameCount = max(Int(duration * 60), 20)
                var positions: [NSPoint] = []
                for j in 0...frameCount {
                    let t = Double(j) / Double(frameCount)
                    let e = CGFloat(ease("缓出", t))
                    let angle = startAngle + orbits * 2 * .pi * e
                    positions.append(CGPoint(
                        x: point.x + cos(angle) * radius,
                        y: point.y + sin(angle) * radius
                    ))
                }

                // Model values = final state (set before addSublayer to avoid flicker)
                if let lastPos = positions.last { shapeLayer.position = lastPos }
                shapeLayer.opacity = 0
                parent.addSublayer(shapeLayer)

                CATransaction.begin()
                CATransaction.setCompletionBlock { shapeLayer.removeFromSuperlayer() }

                let posAnim = CAKeyframeAnimation(keyPath: "position")
                posAnim.values = positions
                posAnim.duration = duration
                posAnim.beginTime = CACurrentMediaTime() + baseDelay
                posAnim.fillMode = .backwards
                shapeLayer.add(posAnim, forKey: "position")

                // Opacity: linear fade
                let opacityAnim = CABasicAnimation(keyPath: "opacity")
                opacityAnim.fromValue = Float(baseOpacity)
                opacityAnim.toValue = 0
                opacityAnim.duration = duration
                opacityAnim.beginTime = CACurrentMediaTime() + baseDelay
                opacityAnim.timingFunction = CAMediaTimingFunction(name: .linear)
                opacityAnim.fillMode = .backwards
                shapeLayer.add(opacityAnim, forKey: "opacity")

                CATransaction.commit()
            }
            return
        }

        // ── Burst / directional ──
        let spread = CGFloat(config.particleSpread ?? 60)
        let direction = config.particleDirection ?? "四周扩散"
        let gravity = CGFloat(config.particleGravity ?? 0)
        let wind = CGFloat(config.particleWind ?? 0)
        let bounce = CGFloat(config.particleBounce ?? 0)
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
            let bounceY = bounce > 0 ? -dist * (bounce / 100.0) * 1.0 : 0
            let endY = sin(angle) * dist + gravity * dist * 0.03 + bounceY
            let particleSize = size * CGFloat.random(in: 0.5...1.0)

            let color = particleColor(colorMode: colorMode, palette: palette, baseColor: baseColor, index: i, config: config)

            let startPos = point
            let endPos = CGPoint(x: point.x + endX, y: point.y + endY)

            // Main particle
            let shapeLayer = makeParticleLayer(style: style, size: particleSize,
                                                color: color, opacity: baseOpacity,
                                                point: point)
            animateParticle(layer: shapeLayer, from: startPos, to: endPos,
                            startOpacity: Float(baseOpacity), duration: duration,
                            easing: "缓出", delay: baseDelay, parent: parent)

            // Trail ghosts
            if hasTrail {
                let ghostCount = 3
                for g in 0..<ghostCount {
                    let ghostOpacity = baseOpacity * CGFloat(1.0 - Double(g) * 0.25)
                    let ghostSize = particleSize * CGFloat(1.0 - Double(g) * 0.12)
                    let ghostLayer = makeParticleLayer(style: style, size: ghostSize,
                                                        color: color, opacity: ghostOpacity,
                                                        point: point)
                    let trailDelay = baseDelay + Double(g) * duration * 0.08
                    animateParticle(layer: ghostLayer, from: startPos, to: endPos,
                                    startOpacity: Float(ghostOpacity), duration: duration,
                                    easing: "缓出", delay: trailDelay, parent: parent)
                }
            }
        }
    }

    // MARK: - Animation helper

    private func animateParticle(layer: CAShapeLayer, from: NSPoint, to: NSPoint,
                                  startOpacity: Float, duration: CFTimeInterval,
                                  easing: String, delay: CFTimeInterval, parent: CALayer) {
        // Model values = final state (set before addSublayer to avoid flicker)
        layer.position = to
        layer.opacity = 0
        parent.addSublayer(layer)

        CATransaction.begin()
        CATransaction.setCompletionBlock { layer.removeFromSuperlayer() }

        let posAnim = CABasicAnimation(keyPath: "position")
        posAnim.fromValue = from
        posAnim.toValue = to
        posAnim.duration = duration
        posAnim.beginTime = CACurrentMediaTime() + delay
        posAnim.timingFunction = easingFunction(easing)
        posAnim.fillMode = .backwards
        layer.add(posAnim, forKey: "position")

        let opacityAnim = CABasicAnimation(keyPath: "opacity")
        opacityAnim.fromValue = startOpacity
        opacityAnim.toValue = 0
        opacityAnim.duration = duration
        opacityAnim.beginTime = CACurrentMediaTime() + delay
        opacityAnim.timingFunction = CAMediaTimingFunction(name: .linear)
        opacityAnim.fillMode = .backwards
        layer.add(opacityAnim, forKey: "opacity")

        CATransaction.commit()
    }

    // MARK: - Particle color

    /// Returns the appropriate color for a particle at given index.
    private func particleColor(colorMode: String, palette: [String], baseColor: NSColor, index: Int, config: ActionConfig.ConfigData) -> NSColor {
        switch colorMode {
        case "跟随飘字色":
            return hexColor(config.textColor)
        case "随机轻变化":
            let c = palette[index % palette.count]
            return hexColor(c)
        default: // 跟随主题
            return baseColor
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
        case "星光":
            return makeStarPath(size: size, points: 5)
        case "心形":
            return makeHeartPath(size: size)
        case "三角":
            let tri = CGMutablePath()
            tri.move(to: CGPoint(x: 0, y: -size / 2))
            tri.addLine(to: CGPoint(x: size / 2, y: size / 2))
            tri.addLine(to: CGPoint(x: -size / 2, y: size / 2))
            tri.closeSubpath()
            return tri
        default:
            return CGPath(ellipseIn: CGRect(x: -size / 2, y: -size / 2, width: size, height: size), transform: nil)
        }
    }

    // MARK: - Shape path generators

    private func makeStarPath(size: CGFloat, points: Int) -> CGPath {
        let path = CGMutablePath()
        let outerR = size / 2
        let innerR = outerR * 0.38
        let step = .pi / CGFloat(points)
        for i in 0..<points * 2 {
            let r = i.isMultiple(of: 2) ? outerR : innerR
            let angle = -(.pi / 2) + step * CGFloat(i)
            let x = cos(angle) * r
            let y = sin(angle) * r
            if i == 0 { path.move(to: CGPoint(x: x, y: y)) }
            else { path.addLine(to: CGPoint(x: x, y: y)) }
        }
        path.closeSubpath()
        return path
    }

    private func makeHeartPath(size: CGFloat) -> CGPath {
        let path = CGMutablePath()
        let s = size / 2
        path.move(to: CGPoint(x: 0, y: -s * 0.85))
        path.addCurve(to: CGPoint(x: s, y: -s * 0.35),
                      control1: CGPoint(x: s * 0.4, y: -s * 1.1),
                      control2: CGPoint(x: s * 1.1, y: -s * 0.7))
        path.addCurve(to: CGPoint(x: s * 0.6, y: s * 0.3),
                      control1: CGPoint(x: s * 1.1, y: s * 0.0),
                      control2: CGPoint(x: s * 0.8, y: s * 0.35))
        path.addCurve(to: CGPoint(x: 0, y: s * 0.6),
                      control1: CGPoint(x: s * 0.3, y: s * 0.4),
                      control2: CGPoint(x: s * 0.15, y: s * 0.55))
        path.addCurve(to: CGPoint(x: -s * 0.6, y: s * 0.3),
                      control1: CGPoint(x: -s * 0.15, y: s * 0.55),
                      control2: CGPoint(x: -s * 0.3, y: s * 0.4))
        path.addCurve(to: CGPoint(x: -s, y: -s * 0.35),
                      control1: CGPoint(x: -s * 0.8, y: s * 0.35),
                      control2: CGPoint(x: -s * 1.1, y: s * 0.0))
        path.addCurve(to: CGPoint(x: 0, y: -s * 0.85),
                      control1: CGPoint(x: -s * 1.1, y: -s * 0.7),
                      control2: CGPoint(x: -s * 0.4, y: -s * 1.1))
        path.closeSubpath()
        return path
    }
}
