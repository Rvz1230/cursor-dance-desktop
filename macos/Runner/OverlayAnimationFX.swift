import Cocoa

// MARK: - AnimationRecord

class AnimationRecord: AnimatableRecord {
    let layer: CALayer
    let style: String
    let startX: CGFloat
    let startY: CGFloat
    let startScale: CGFloat
    let startOpacity: Float
    let duration: CFTimeInterval
    let startDelay: CFTimeInterval
    let easing: String
    let offsetX: CGFloat
    let offsetY: CGFloat
    let color: NSColor
    let glow: Bool
    var elapsed: CFTimeInterval = 0
    var finished = false

    init(layer: CALayer,
         style: String,
         startX: CGFloat, startY: CGFloat,
         startScale: CGFloat,
         startOpacity: Float,
         duration: CFTimeInterval,
         easing: String,
         startDelay: CFTimeInterval = 0,
         offsetX: CGFloat = 0, offsetY: CGFloat = 0,
         color: NSColor = .white,
         glow: Bool = false)
    {
        self.layer = layer
        self.style = style
        self.startX = startX; self.startY = startY
        self.startScale = startScale
        self.startOpacity = startOpacity
        self.duration = duration
        self.easing = easing
        self.startDelay = startDelay
        self.offsetX = offsetX; self.offsetY = offsetY
        self.color = color
        self.glow = glow
        layer.actions = ["position": NSNull(), "opacity": NSNull(), "transform": NSNull()]
    }

    func advance(by dt: CFTimeInterval) {
        elapsed += dt
        let effective = elapsed - startDelay
        guard effective > 0 else { return }
        let t = min(effective / duration, 1.0)
        let e = CGFloat(ease(easing, t))

        switch style {
        case "聚焦脉冲":
            // Scale: 0.6 → 1.2 → 0.9 over duration
            let scale: CGFloat
            if t < 0.35 {
                scale = 0.6 + (1.2 - 0.6) * (CGFloat(t) / 0.35)
            } else if t < 0.7 {
                scale = 1.2 - (1.2 - 1.0) * ((CGFloat(t) - 0.35) / 0.35)
            } else {
                scale = 1.0 - (1.0 - 0.9) * ((CGFloat(t) - 0.7) / 0.3)
            }
            layer.transform = CATransform3DMakeScale(scale, scale, 1)
            layer.opacity = startOpacity * Float(1.0 - t * 0.7)

        case "斜切闪片":
            // Sweep: position shifts from left to right, rotate 45°, fade
            let sweepX = -offsetX + (offsetX * 2) * e
            layer.position = CGPoint(x: startX + sweepX, y: startY)
            layer.transform = CATransform3DMakeRotation(.pi / 4, 0, 0, 1)
            layer.opacity = startOpacity * Float(sin(.pi * t))

        case "弹跳徽记":
            // Overshoot bounce: 0 → 1.15 → 0.95 → 1.0
            let scale: CGFloat
            if t < 0.5 {
                let bounceEase = CGFloat(ease(easing, t / 0.5))
                scale = 1.15 * bounceEase
            } else if t < 0.8 {
                let bounceEase = CGFloat(ease(easing, (t - 0.5) / 0.3))
                scale = 1.15 - (1.15 - 0.95) * bounceEase
            } else {
                let bounceEase = CGFloat(ease(easing, (t - 0.8) / 0.2))
                scale = 0.95 + (1.0 - 0.95) * bounceEase
            }
            layer.transform = CATransform3DMakeScale(scale, scale, 1)
            layer.opacity = startOpacity * Float(1.0 - t * 0.3)
            // Glow pulse
            if glow {
                layer.shadowOpacity = Float(0.6 * (1.0 - t * 0.5))
                layer.shadowRadius = 8 + 4 * (1.0 - t)
            }

        case "漩涡旋转":
            // Spiral outward + rotation
            let radius = offsetX * e
            let angle = 2 * .pi * 2 * e
            layer.position = CGPoint(
                x: startX + cos(angle) * radius,
                y: startY + sin(angle) * radius
            )
            layer.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
            layer.opacity = startOpacity * Float(1.0 - t)

        case "星光闪耀":
            // Rotate star shape + shimmer opacity
            let rotation = 2 * .pi * 2 * e
            layer.transform = CATransform3DMakeRotation(rotation, 0, 0, 1)
            // Pulsing opacity for shimmer effect
            let shimmer = 0.5 + 0.5 * sin(2 * .pi * 3 * CGFloat(t))
            layer.opacity = startOpacity * Float(shimmer * (1.0 - t * 0.5))

        case "轨道环绕":
            // Single orbiting dot around center
            let radius = offsetX
            let angle = 2 * .pi * e
            layer.position = CGPoint(
                x: startX + cos(angle) * radius,
                y: startY + sin(angle) * radius
            )
            layer.opacity = startOpacity * Float(1.0 - t * 0.5)

        case "螺旋上升":
            // Spiral upward: expanding circle + rising
            let radius = offsetX * e
            let angle = 2 * .pi * 3 * e
            let rise = -offsetY * e
            layer.position = CGPoint(
                x: startX + cos(angle) * radius,
                y: startY + sin(angle) * radius + rise
            )
            layer.opacity = startOpacity * Float(1.0 - t)

        default:
            // Fallback: simple fade out
            layer.opacity = startOpacity * Float(1.0 - t)
        }

        if t >= 1.0 { finished = true }
    }
}

// MARK: - OverlayAnimationFX

/// Animation feedback — 7 styles triggered on click.
class OverlayAnimationFX {
    func spawn(at point: NSPoint, config: ActionConfig.ConfigData, parent: CALayer, driver: AnimationDriver) {
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
            let size: CGFloat = 60
            let layer = CAShapeLayer()
            layer.path = CGPath(ellipseIn: CGRect(x: -size / 2, y: -size / 2, width: size, height: size), transform: nil)
            layer.fillColor = animColor.withAlphaComponent(0.25).cgColor
            layer.strokeColor = animColor.withAlphaComponent(baseOpacity * 0.6).cgColor
            layer.lineWidth = 2
            layer.position = point
            if glow {
                layer.shadowOpacity = 0.5
                layer.shadowRadius = 12
                layer.shadowColor = animColor.cgColor
                layer.shadowOffset = NSSize.zero
            }
            parent.addSublayer(layer)

            let record = AnimationRecord(
                layer: layer, style: style,
                startX: point.x, startY: point.y,
                startScale: scaleFactor, startOpacity: Float(baseOpacity),
                duration: duration, easing: easing,
                startDelay: baseDelay,
                color: animColor, glow: glow
            )
            driver.add(record)

        case "斜切闪片":
            let width: CGFloat = 120
            let height: CGFloat = 4
            let layer = CAShapeLayer()
            layer.path = CGPath(rect: CGRect(x: -width / 2, y: -height / 2, width: width, height: height), transform: nil)
            layer.fillColor = animColor.withAlphaComponent(baseOpacity * 0.7).cgColor
            layer.position = CGPoint(x: point.x - width / 2, y: point.y)
            parent.addSublayer(layer)

            let record = AnimationRecord(
                layer: layer, style: style,
                startX: point.x - width / 2, startY: point.y,
                startScale: scaleFactor, startOpacity: Float(baseOpacity),
                duration: duration, easing: easing,
                startDelay: baseDelay,
                offsetX: width, offsetY: 0,
                color: animColor
            )
            driver.add(record)

        case "弹跳徽记":
            let size: CGFloat = 48 * scaleFactor
            let layer = CAShapeLayer()
            layer.path = CGPath(ellipseIn: CGRect(x: -size / 2, y: -size / 2, width: size, height: size), transform: nil)
            layer.fillColor = animColor.withAlphaComponent(0.3).cgColor
            layer.strokeColor = animColor.withAlphaComponent(baseOpacity).cgColor
            layer.lineWidth = 2.5
            layer.position = point
            if glow {
                layer.shadowOpacity = 0.6
                layer.shadowRadius = 10
                layer.shadowColor = animColor.cgColor
                layer.shadowOffset = NSSize.zero
            }
            parent.addSublayer(layer)

            let record = AnimationRecord(
                layer: layer, style: style,
                startX: point.x, startY: point.y,
                startScale: scaleFactor, startOpacity: Float(baseOpacity),
                duration: duration, easing: "弹性",
                startDelay: baseDelay,
                color: animColor, glow: glow
            )
            driver.add(record)

        case "漩涡旋转":
            let count = 8
            let radius: CGFloat = 30
            for i in 0..<count {
                let dotSize: CGFloat = 6
                let dotLayer = CAShapeLayer()
                dotLayer.path = CGPath(ellipseIn: CGRect(x: -dotSize / 2, y: -dotSize / 2, width: dotSize, height: dotSize), transform: nil)
                dotLayer.fillColor = animColor.withAlphaComponent(baseOpacity).cgColor
                dotLayer.position = point
                parent.addSublayer(dotLayer)

                let record = AnimationRecord(
                    layer: dotLayer, style: style,
                    startX: point.x, startY: point.y,
                    startScale: scaleFactor, startOpacity: Float(baseOpacity),
                    duration: duration, easing: easing,
                    startDelay: baseDelay + Double(i) * 0.04,
                    offsetX: radius, offsetY: 0,
                    color: animColor
                )
                driver.add(record)
            }

        case "星光闪耀":
            let size: CGFloat = 32 * scaleFactor
            let starLayer = CAShapeLayer()
            starLayer.path = makeStarPath(size: size, points: 5)
            starLayer.fillColor = animColor.withAlphaComponent(baseOpacity).cgColor
            starLayer.position = point
            if glow {
                starLayer.shadowOpacity = 0.5
                starLayer.shadowRadius = 8
                starLayer.shadowColor = animColor.cgColor
                starLayer.shadowOffset = NSSize.zero
            }
            parent.addSublayer(starLayer)

            let record = AnimationRecord(
                layer: starLayer, style: style,
                startX: point.x, startY: point.y,
                startScale: scaleFactor, startOpacity: Float(baseOpacity),
                duration: duration, easing: easing,
                startDelay: baseDelay,
                color: animColor, glow: glow
            )
            driver.add(record)

        case "轨道环绕":
            let orbitRadius: CGFloat = 40 * scaleFactor
            let dotCount = 6
            for i in 0..<dotCount {
                let dotSize: CGFloat = 5
                let dotLayer = CAShapeLayer()
                dotLayer.path = CGPath(ellipseIn: CGRect(x: -dotSize / 2, y: -dotSize / 2, width: dotSize, height: dotSize), transform: nil)
                dotLayer.fillColor = animColor.withAlphaComponent(baseOpacity).cgColor
                let angle = (2 * .pi / CGFloat(dotCount)) * CGFloat(i)
                dotLayer.position = CGPoint(
                    x: point.x + cos(angle) * orbitRadius,
                    y: point.y + sin(angle) * orbitRadius
                )
                parent.addSublayer(dotLayer)

                let record = AnimationRecord(
                    layer: dotLayer, style: style,
                    startX: point.x, startY: point.y,
                    startScale: scaleFactor, startOpacity: Float(baseOpacity),
                    duration: duration, easing: easing,
                    startDelay: baseDelay + Double(i) * 0.06,
                    offsetX: orbitRadius, offsetY: 0,
                    color: animColor
                )
                driver.add(record)
            }

        case "螺旋上升":
            let dotCount = 12
            let spread: CGFloat = offsetX
            let riseDistance: CGFloat = abs(offsetY)
            for i in 0..<dotCount {
                let dotSize: CGFloat = 4
                let dotLayer = CAShapeLayer()
                dotLayer.path = CGPath(ellipseIn: CGRect(x: -dotSize / 2, y: -dotSize / 2, width: dotSize, height: dotSize), transform: nil)
                dotLayer.fillColor = animColor.withAlphaComponent(baseOpacity).cgColor
                dotLayer.position = point
                parent.addSublayer(dotLayer)

                let record = AnimationRecord(
                    layer: dotLayer, style: style,
                    startX: point.x, startY: point.y,
                    startScale: scaleFactor, startOpacity: Float(baseOpacity),
                    duration: duration, easing: easing,
                    startDelay: baseDelay + Double(i) * 0.03,
                    offsetX: spread, offsetY: -riseDistance,
                    color: animColor
                )
                driver.add(record)
            }

        default:
            break
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
