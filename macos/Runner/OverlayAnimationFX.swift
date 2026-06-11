import Cocoa

/// Animation feedback — 7 styles triggered on click.
/// All styles use CAKeyframeAnimation with pre-computed keyframes.
class OverlayAnimationFX {
    func spawn(at point: NSPoint, config: ActionConfig.ConfigData, parent: CALayer) {
        let style = config.animationStyle ?? "聚焦脉冲"
        let duration = Double(config.animationDuration ?? 720) / 1000.0
        let baseOpacity = CGFloat(config.animationOpacity ?? 100) / 100.0
        let easing = config.animationEasing ?? "缓出"
        let scaleFactor = CGFloat(config.animationScale ?? 100) / 100.0
        let offsetX = CGFloat(config.animationOffsetX ?? 0)
        let offsetY = CGFloat(config.animationOffsetY ?? -10)
        let animColor = hexColor(config.animationColor)
        let glow = config.animationGlow == true
        let baseDelay = Double(config.animationDelay ?? 0) / 1000.0

        switch style {
        case "聚焦脉冲":
            spawnFocusPulse(at: point, duration: duration, baseOpacity: baseOpacity,
                            easing: easing, scaleFactor: scaleFactor, color: animColor,
                            glow: glow, delay: baseDelay, parent: parent)
        case "斜切闪片":
            spawnSlashFlash(at: point, duration: duration, baseOpacity: baseOpacity,
                            easing: easing, offsetX: offsetX, color: animColor,
                            delay: baseDelay, parent: parent)
        case "弹跳徽记":
            spawnBounceBadge(at: point, duration: duration, baseOpacity: baseOpacity,
                             scaleFactor: scaleFactor, color: animColor,
                             glow: glow, delay: baseDelay, parent: parent)
        case "漩涡旋转":
            spawnVortex(at: point, duration: duration, baseOpacity: baseOpacity,
                        easing: easing, scaleFactor: scaleFactor, offsetX: offsetX,
                        color: animColor, delay: baseDelay, parent: parent)
        case "星光闪耀":
            spawnStarShimmer(at: point, duration: duration, baseOpacity: baseOpacity,
                             easing: easing, scaleFactor: scaleFactor, color: animColor,
                             glow: glow, delay: baseDelay, parent: parent)
        case "轨道环绕":
            spawnOrbit(at: point, duration: duration, baseOpacity: baseOpacity,
                       easing: easing, scaleFactor: scaleFactor, offsetX: offsetX,
                       color: animColor, delay: baseDelay, parent: parent)
        case "螺旋上升":
            spawnSpiralRise(at: point, duration: duration, baseOpacity: baseOpacity,
                            easing: easing, offsetX: offsetX, offsetY: offsetY,
                            color: animColor, delay: baseDelay, parent: parent)
        default:
            break
        }
    }

    // MARK: - 聚焦脉冲

    private func spawnFocusPulse(at point: NSPoint, duration: CFTimeInterval, baseOpacity: CGFloat,
                                  easing: String, scaleFactor: CGFloat, color: NSColor,
                                  glow: Bool, delay: CFTimeInterval, parent: CALayer) {
        let size: CGFloat = 60
        let layer = CAShapeLayer()
        layer.path = CGPath(ellipseIn: CGRect(x: -size / 2, y: -size / 2, width: size, height: size), transform: nil)
        layer.fillColor = color.withAlphaComponent(0.25).cgColor
        layer.strokeColor = color.withAlphaComponent(baseOpacity * 0.6).cgColor
        layer.lineWidth = 2
        layer.position = point
        if glow {
            layer.shadowOpacity = 0.5
            layer.shadowRadius = 12
            layer.shadowColor = color.cgColor
            layer.shadowOffset = NSSize.zero
        }
        let startOpacity = Float(baseOpacity)

        // Pre-sample glow if needed
        var shadowOpacityValues: [Float]?
        var shadowRadiusValues: [CGFloat]?
        if glow {
            let frameCount = max(Int(duration * 30), 10)
            var sOp: [Float] = []
            var sRad: [CGFloat] = []
            for i in 0...frameCount {
                let t = Double(i) / Double(frameCount)
                sOp.append(Float(0.5 * (1.0 - t * 0.5)))
                sRad.append(12 + 4 * (1 - CGFloat(t)))
            }
            shadowOpacityValues = sOp
            shadowRadiusValues = sRad
        }

        // Model values = final state (set before addSublayer to avoid flicker)
        layer.transform = CATransform3DMakeScale(scaleFactor * 0.9, scaleFactor * 0.9, 1)
        layer.opacity = Float(startOpacity * 0.3)
        parent.addSublayer(layer)

        CATransaction.begin()
        CATransaction.setCompletionBlock { layer.removeFromSuperlayer() }

        // Scale: 0.6 → 1.2 (t<0.35) → 1.0 (0.35<t<0.7) → 0.9 (t>0.7) — scaled by scaleFactor
        let scaleAnim = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnim.values = [0.6 * scaleFactor, 1.2 * scaleFactor, 1.0 * scaleFactor, 0.9 * scaleFactor]
        scaleAnim.keyTimes = [0, 0.35, 0.7, 1.0]
        scaleAnim.duration = duration
        scaleAnim.beginTime = CACurrentMediaTime() + delay
        scaleAnim.fillMode = .backwards
        layer.add(scaleAnim, forKey: "transform.scale")

        // Opacity: fade out to 30%
        let opacityAnim = CABasicAnimation(keyPath: "opacity")
        opacityAnim.fromValue = startOpacity
        opacityAnim.toValue = startOpacity * 0.3
        opacityAnim.duration = duration
        opacityAnim.beginTime = CACurrentMediaTime() + delay
        opacityAnim.timingFunction = CAMediaTimingFunction(name: .linear)
        opacityAnim.fillMode = .backwards
        layer.add(opacityAnim, forKey: "opacity")

        // Glow animations
        if let sOp = shadowOpacityValues {
            let shadowOpAnim = CAKeyframeAnimation(keyPath: "shadowOpacity")
            shadowOpAnim.values = sOp
            shadowOpAnim.duration = duration
            shadowOpAnim.beginTime = CACurrentMediaTime() + delay
            shadowOpAnim.fillMode = .backwards
            layer.add(shadowOpAnim, forKey: "shadowOpacity")
        }
        if let sRad = shadowRadiusValues {
            let shadowRadAnim = CAKeyframeAnimation(keyPath: "shadowRadius")
            shadowRadAnim.values = sRad
            shadowRadAnim.duration = duration
            shadowRadAnim.beginTime = CACurrentMediaTime() + delay
            shadowRadAnim.fillMode = .backwards
            layer.add(shadowRadAnim, forKey: "shadowRadius")
        }

        CATransaction.commit()
    }

    // MARK: - 斜切闪片

    private func spawnSlashFlash(at point: NSPoint, duration: CFTimeInterval, baseOpacity: CGFloat,
                                  easing: String, offsetX: CGFloat, color: NSColor,
                                  delay: CFTimeInterval, parent: CALayer) {
        let width: CGFloat = 120
        let height: CGFloat = 4
        let layer = CAShapeLayer()
        layer.path = CGPath(rect: CGRect(x: -width / 2, y: -height / 2, width: width, height: height), transform: nil)
        layer.fillColor = color.withAlphaComponent(baseOpacity * 0.7).cgColor
        layer.position = CGPoint(x: point.x - width / 2, y: point.y)

        let startPos = CGPoint(x: point.x - width / 2, y: point.y)
        let endPos = CGPoint(x: point.x + width / 2, y: point.y)

        // Model values = final state (set before addSublayer to avoid flicker)
        layer.position = endPos
        layer.transform = CATransform3DMakeRotation(.pi / 4, 0, 0, 1)
        layer.opacity = 0
        parent.addSublayer(layer)

        CATransaction.begin()
        CATransaction.setCompletionBlock { layer.removeFromSuperlayer() }

        // Position: sweep left to right
        let posAnim = CABasicAnimation(keyPath: "position")
        posAnim.fromValue = startPos
        posAnim.toValue = endPos
        posAnim.duration = duration
        posAnim.beginTime = CACurrentMediaTime() + delay
        posAnim.timingFunction = easingFunction(easing)
        posAnim.fillMode = .backwards
        layer.add(posAnim, forKey: "position")

        // Rotation: 45° fixed
        let rotAnim = CABasicAnimation(keyPath: "transform.rotation")
        rotAnim.fromValue = CGFloat.pi / 4
        rotAnim.toValue = CGFloat.pi / 4
        rotAnim.duration = duration
        rotAnim.beginTime = CACurrentMediaTime() + delay
        rotAnim.fillMode = .backwards
        layer.add(rotAnim, forKey: "transform.rotation")

        // Opacity: sin(π*t) curve
        let frameCount = max(Int(duration * 60), 20)
        var opacityValues: [Float] = []
        for i in 0...frameCount {
            let t = CGFloat(i) / CGFloat(frameCount)
            opacityValues.append(Float(baseOpacity) * Float(sin(.pi * t)))
        }
        let opacityAnim = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnim.values = opacityValues
        opacityAnim.duration = duration
        opacityAnim.beginTime = CACurrentMediaTime() + delay
        opacityAnim.fillMode = .backwards
        layer.add(opacityAnim, forKey: "opacity")

        CATransaction.commit()
    }

    // MARK: - 弹跳徽记

    private func spawnBounceBadge(at point: NSPoint, duration: CFTimeInterval, baseOpacity: CGFloat,
                                   scaleFactor: CGFloat, color: NSColor,
                                   glow: Bool, delay: CFTimeInterval, parent: CALayer) {
        let size: CGFloat = 48 * scaleFactor
        let layer = CAShapeLayer()
        layer.path = CGPath(ellipseIn: CGRect(x: -size / 2, y: -size / 2, width: size, height: size), transform: nil)
        layer.fillColor = color.withAlphaComponent(0.3).cgColor
        layer.strokeColor = color.withAlphaComponent(baseOpacity).cgColor
        layer.lineWidth = 2.5
        layer.position = point
        if glow {
            layer.shadowOpacity = 0.6
            layer.shadowRadius = 10
            layer.shadowColor = color.cgColor
            layer.shadowOffset = NSSize.zero
        }
        let startOpacity = Float(baseOpacity)

        // Pre-sample glow if needed
        var shadowOpacityValues: [Float]?
        var shadowRadiusValues: [CGFloat]?
        if glow {
            let frameCount = max(Int(duration * 30), 10)
            var sOp: [Float] = []
            var sRad: [CGFloat] = []
            for i in 0...frameCount {
                let t = Double(i) / Double(frameCount)
                sOp.append(Float(0.6 * (1.0 - t * 0.5)))
                sRad.append(8 + 4 * (1 - CGFloat(t)))
            }
            shadowOpacityValues = sOp
            shadowRadiusValues = sRad
        }

        // Model values = final state (set before addSublayer to avoid flicker)
        layer.transform = CATransform3DMakeScale(1.0, 1.0, 1)
        layer.opacity = Float(startOpacity * 0.7)
        parent.addSublayer(layer)

        CATransaction.begin()
        CATransaction.setCompletionBlock { layer.removeFromSuperlayer() }

        // Scale: 0 → 1.15 (t<0.5) → 0.95 (0.5<t<0.8) → 1.0 (t>0.8)
        let scaleAnim = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnim.values = [0, 1.15, 0.95, 1.0]
        scaleAnim.keyTimes = [0, 0.5, 0.8, 1.0]
        scaleAnim.duration = duration
        scaleAnim.beginTime = CACurrentMediaTime() + delay
        scaleAnim.timingFunction = easingFunction("弹性")
        scaleAnim.fillMode = .backwards
        layer.add(scaleAnim, forKey: "transform.scale")

        // Opacity: fade to 70%
        let opacityAnim = CABasicAnimation(keyPath: "opacity")
        opacityAnim.fromValue = startOpacity
        opacityAnim.toValue = startOpacity * 0.7
        opacityAnim.duration = duration
        opacityAnim.beginTime = CACurrentMediaTime() + delay
        opacityAnim.timingFunction = CAMediaTimingFunction(name: .linear)
        opacityAnim.fillMode = .backwards
        layer.add(opacityAnim, forKey: "opacity")

        if let sOp = shadowOpacityValues {
            let shadowOpAnim = CAKeyframeAnimation(keyPath: "shadowOpacity")
            shadowOpAnim.values = sOp
            shadowOpAnim.duration = duration
            shadowOpAnim.beginTime = CACurrentMediaTime() + delay
            shadowOpAnim.fillMode = .backwards
            layer.add(shadowOpAnim, forKey: "shadowOpacity")
        }
        if let sRad = shadowRadiusValues {
            let shadowRadAnim = CAKeyframeAnimation(keyPath: "shadowRadius")
            shadowRadAnim.values = sRad
            shadowRadAnim.duration = duration
            shadowRadAnim.beginTime = CACurrentMediaTime() + delay
            shadowRadAnim.fillMode = .backwards
            layer.add(shadowRadAnim, forKey: "shadowRadius")
        }

        CATransaction.commit()
    }

    // MARK: - 漩涡旋转

    private func spawnVortex(at point: NSPoint, duration: CFTimeInterval, baseOpacity: CGFloat,
                              easing: String, scaleFactor: CGFloat, offsetX: CGFloat,
                              color: NSColor, delay: CFTimeInterval, parent: CALayer) {
        let count = 8
        for i in 0..<count {
            let dotSize: CGFloat = 6
            let dotLayer = CAShapeLayer()
            dotLayer.path = CGPath(ellipseIn: CGRect(x: -dotSize / 2, y: -dotSize / 2, width: dotSize, height: dotSize), transform: nil)
            dotLayer.fillColor = color.withAlphaComponent(baseOpacity).cgColor
            dotLayer.position = point

            let startOpacity = Float(baseOpacity)
            let dotDelay = delay + Double(i) * 0.04

            // Pre-sample spiral position + rotation
            let frameCount = max(Int(duration * 60), 20)
            var positions: [NSPoint] = []
            var rotations: [CGFloat] = []
            for j in 0...frameCount {
                let t = Double(j) / Double(frameCount)
                let e = CGFloat(ease(easing, t))
                let r = offsetX * e
                let angle = 2 * .pi * 2 * e
                positions.append(CGPoint(
                    x: point.x + cos(angle) * r,
                    y: point.y + sin(angle) * r
                ))
                rotations.append(angle)
            }

            // Model values = final state (set before addSublayer to avoid flicker)
            if let lastPos = positions.last { dotLayer.position = lastPos }
            if let lastRot = rotations.last {
                dotLayer.transform = CATransform3DMakeRotation(lastRot, 0, 0, 1)
            }
            dotLayer.opacity = 0
            parent.addSublayer(dotLayer)

            CATransaction.begin()
            CATransaction.setCompletionBlock { dotLayer.removeFromSuperlayer() }

            let posAnim = CAKeyframeAnimation(keyPath: "position")
            posAnim.values = positions
            posAnim.duration = duration
            posAnim.beginTime = CACurrentMediaTime() + dotDelay
            posAnim.fillMode = .backwards
            dotLayer.add(posAnim, forKey: "position")

            let rotAnim = CAKeyframeAnimation(keyPath: "transform.rotation")
            rotAnim.values = rotations
            rotAnim.duration = duration
            rotAnim.beginTime = CACurrentMediaTime() + dotDelay
            rotAnim.fillMode = .backwards
            dotLayer.add(rotAnim, forKey: "transform.rotation")

            let opacityAnim = CABasicAnimation(keyPath: "opacity")
            opacityAnim.fromValue = startOpacity
            opacityAnim.toValue = 0
            opacityAnim.duration = duration
            opacityAnim.beginTime = CACurrentMediaTime() + dotDelay
            opacityAnim.timingFunction = CAMediaTimingFunction(name: .linear)
            opacityAnim.fillMode = .backwards
            dotLayer.add(opacityAnim, forKey: "opacity")

            CATransaction.commit()
        }
    }

    // MARK: - 星光闪耀

    private func spawnStarShimmer(at point: NSPoint, duration: CFTimeInterval, baseOpacity: CGFloat,
                                   easing: String, scaleFactor: CGFloat, color: NSColor,
                                   glow: Bool, delay: CFTimeInterval, parent: CALayer) {
        let size: CGFloat = 32 * scaleFactor
        let starLayer = CAShapeLayer()
        starLayer.path = makeStarPath(size: size, points: 5)
        starLayer.fillColor = color.withAlphaComponent(baseOpacity).cgColor
        starLayer.position = point
        if glow {
            starLayer.shadowOpacity = 0.5
            starLayer.shadowRadius = 8
            starLayer.shadowColor = color.cgColor
            starLayer.shadowOffset = NSSize.zero
        }
        let startOpacity = Float(baseOpacity)

        // Pre-sample rotation + shimmer opacity
        let frameCount = max(Int(duration * 60), 20)
        var rotations: [CGFloat] = []
        var opacityValues: [Float] = []
        for i in 0...frameCount {
            let t = Double(i) / Double(frameCount)
            let e = CGFloat(ease(easing, t))
            rotations.append(2 * .pi * 2 * e)
            let shimmer = 0.5 + 0.5 * sin(2 * .pi * 3 * CGFloat(t))
            opacityValues.append(startOpacity * Float(shimmer * (1.0 - CGFloat(t) * 0.5)))
        }

        // Model values = final state (set before addSublayer to avoid flicker)
        if let lastRot = rotations.last {
            starLayer.transform = CATransform3DMakeRotation(lastRot, 0, 0, 1)
        }
        starLayer.opacity = 0
        parent.addSublayer(starLayer)

        CATransaction.begin()
        CATransaction.setCompletionBlock { starLayer.removeFromSuperlayer() }

        let rotAnim = CAKeyframeAnimation(keyPath: "transform.rotation")
        rotAnim.values = rotations
        rotAnim.duration = duration
        rotAnim.beginTime = CACurrentMediaTime() + delay
        rotAnim.fillMode = .backwards
        starLayer.add(rotAnim, forKey: "transform.rotation")

        let opacityAnim = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnim.values = opacityValues
        opacityAnim.duration = duration
        opacityAnim.beginTime = CACurrentMediaTime() + delay
        opacityAnim.fillMode = .backwards
        starLayer.add(opacityAnim, forKey: "opacity")

        CATransaction.commit()
    }

    // MARK: - 轨道环绕

    private func spawnOrbit(at point: NSPoint, duration: CFTimeInterval, baseOpacity: CGFloat,
                             easing: String, scaleFactor: CGFloat, offsetX: CGFloat,
                             color: NSColor, delay: CFTimeInterval, parent: CALayer) {
        let orbitRadius: CGFloat = 40 * scaleFactor
        let dotCount = 6
        for i in 0..<dotCount {
            let dotSize: CGFloat = 5
            let dotLayer = CAShapeLayer()
            dotLayer.path = CGPath(ellipseIn: CGRect(x: -dotSize / 2, y: -dotSize / 2, width: dotSize, height: dotSize), transform: nil)
            dotLayer.fillColor = color.withAlphaComponent(baseOpacity).cgColor
            let startAngle = (2 * .pi / CGFloat(dotCount)) * CGFloat(i)
            dotLayer.position = CGPoint(
                x: point.x + cos(startAngle) * orbitRadius,
                y: point.y + sin(startAngle) * orbitRadius
            )

            let startOpacity = Float(baseOpacity)
            let dotDelay = delay + Double(i) * 0.06

            // Circular arc path
            let arcPath = CGMutablePath()
            arcPath.addArc(center: point, radius: orbitRadius,
                           startAngle: startAngle,
                           endAngle: startAngle + 2 * .pi,
                           clockwise: false)

            // Model values = final state (set before addSublayer to avoid flicker)
            dotLayer.opacity = Float(startOpacity * 0.5)
            parent.addSublayer(dotLayer)

            CATransaction.begin()
            CATransaction.setCompletionBlock { dotLayer.removeFromSuperlayer() }

            let posAnim = CAKeyframeAnimation(keyPath: "position")
            posAnim.path = arcPath
            posAnim.duration = duration
            posAnim.beginTime = CACurrentMediaTime() + dotDelay
            posAnim.timingFunction = easingFunction(easing)
            posAnim.fillMode = .backwards
            dotLayer.add(posAnim, forKey: "position")

            let opacityAnim = CABasicAnimation(keyPath: "opacity")
            opacityAnim.fromValue = startOpacity
            opacityAnim.toValue = startOpacity * 0.5
            opacityAnim.duration = duration
            opacityAnim.beginTime = CACurrentMediaTime() + dotDelay
            opacityAnim.timingFunction = CAMediaTimingFunction(name: .linear)
            opacityAnim.fillMode = .backwards
            dotLayer.add(opacityAnim, forKey: "opacity")

            CATransaction.commit()
        }
    }

    // MARK: - 螺旋上升

    private func spawnSpiralRise(at point: NSPoint, duration: CFTimeInterval, baseOpacity: CGFloat,
                                  easing: String, offsetX: CGFloat, offsetY: CGFloat,
                                  color: NSColor, delay: CFTimeInterval, parent: CALayer) {
        let dotCount = 12
        let spread: CGFloat = offsetX
        let riseDistance: CGFloat = abs(offsetY)

        for i in 0..<dotCount {
            let dotSize: CGFloat = 4
            let dotLayer = CAShapeLayer()
            dotLayer.path = CGPath(ellipseIn: CGRect(x: -dotSize / 2, y: -dotSize / 2, width: dotSize, height: dotSize), transform: nil)
            dotLayer.fillColor = color.withAlphaComponent(baseOpacity).cgColor
            dotLayer.position = point

            let startOpacity = Float(baseOpacity)
            let dotDelay = delay + Double(i) * 0.03

            // Pre-sample spiral + rise position
            let frameCount = max(Int(duration * 60), 20)
            var positions: [NSPoint] = []
            for j in 0...frameCount {
                let t = Double(j) / Double(frameCount)
                let e = CGFloat(ease(easing, t))
                let radius = spread * e
                let angle = 2 * .pi * 3 * e
                let rise = -riseDistance * e
                positions.append(CGPoint(
                    x: point.x + cos(angle) * radius,
                    y: point.y + sin(angle) * radius + rise
                ))
            }

            // Model values = final state (set before addSublayer to avoid flicker)
            if let lastPos = positions.last { dotLayer.position = lastPos }
            dotLayer.opacity = 0
            parent.addSublayer(dotLayer)

            CATransaction.begin()
            CATransaction.setCompletionBlock { dotLayer.removeFromSuperlayer() }

            let posAnim = CAKeyframeAnimation(keyPath: "position")
            posAnim.values = positions
            posAnim.duration = duration
            posAnim.beginTime = CACurrentMediaTime() + dotDelay
            posAnim.fillMode = .backwards
            dotLayer.add(posAnim, forKey: "position")

            let opacityAnim = CABasicAnimation(keyPath: "opacity")
            opacityAnim.fromValue = startOpacity
            opacityAnim.toValue = 0
            opacityAnim.duration = duration
            opacityAnim.beginTime = CACurrentMediaTime() + dotDelay
            opacityAnim.timingFunction = CAMediaTimingFunction(name: .linear)
            opacityAnim.fillMode = .backwards
            dotLayer.add(opacityAnim, forKey: "opacity")

            CATransaction.commit()
        }
    }

    // MARK: - Shape helpers

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
}
