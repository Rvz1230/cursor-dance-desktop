import Cocoa

/// Mirrors EffectsEngine._spawnRipples in lib/effects/effects_engine.dart.
/// Uses CABasicAnimation for scale + fade, CATransaction for cleanup.
class OverlayRippleFX {
    func spawn(at point: NSPoint, config: ActionConfig.ConfigData, parent: CALayer) {
        let size = CGFloat(config.rippleSize ?? 72)
        let duration = Double(config.rippleDuration ?? 860) / 1000.0
        let opacity = CGFloat(config.rippleOpacity ?? 72) / 100.0
        let lineWidth = CGFloat(config.rippleLineWidth ?? 2)
        let color = hexColor(config.rippleColor)
        let style = config.rippleStyle ?? "单环"
        let easing = config.rippleEasing ?? "缓出"

        let layers = rippleLayers(for: style, size: size, opacity: opacity,
                                  lineWidth: lineWidth, color: color)

        let baseDelay: TimeInterval = TimeInterval(config.rippleDelay ?? 0) / 1000.0
        let stagger: TimeInterval = 0.08
        for (index, layer) in layers.enumerated() {
            let delay = baseDelay + Double(index) * stagger
            let startOpacity = Float(opacity)

            // Model values = final state (set before addSublayer to avoid flicker)
            layer.position = point
            layer.transform = CATransform3DMakeScale(1, 1, 1)
            layer.opacity = 0
            parent.addSublayer(layer)

            CATransaction.begin()
            CATransaction.setCompletionBlock { layer.removeFromSuperlayer() }

            // Scale: 0.18 → 1.0 with easing
            let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
            scaleAnim.fromValue = 0.18
            scaleAnim.toValue = 1.0
            scaleAnim.duration = duration
            scaleAnim.beginTime = CACurrentMediaTime() + delay
            scaleAnim.timingFunction = easingFunction(easing)
            scaleAnim.fillMode = .backwards
            layer.add(scaleAnim, forKey: "transform.scale")

            // Opacity: linear fade
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
    }

    private func rippleLayers(
        for style: String,
        size: CGFloat,
        opacity: CGFloat,
        lineWidth: CGFloat,
        color: NSColor
    ) -> [CAShapeLayer] {
        switch style {
        case "双环":
            return [
                makeRing(size: size, lineWidth: lineWidth, color: color, opacity: opacity),
                makeRing(size: size * 1.12, lineWidth: lineWidth * 0.8, color: color, opacity: opacity * 0.82),
            ]

        case "柔和面波":
            return [
                makeFilled(size: size, color: color, opacity: opacity),
            ]

        case "脉冲波纹":
            return [
                makeFilled(size: size, color: color, opacity: opacity),
                makeRing(size: size * 1.24, lineWidth: lineWidth, color: color, opacity: opacity * 0.52),
                makeRing(size: size * 1.4, lineWidth: lineWidth * 0.6, color: color, opacity: opacity * 0.26),
            ]

        case "回声环":
            return [
                makeRing(size: size, lineWidth: lineWidth, color: color, opacity: opacity),
                makeRing(size: size * 1.1, lineWidth: lineWidth * 0.9, color: color, opacity: opacity * 0.68),
                makeRing(size: size * 1.22, lineWidth: lineWidth * 0.8, color: color, opacity: opacity * 0.44),
                makeRing(size: size * 1.36, lineWidth: lineWidth * 0.6, color: color, opacity: opacity * 0.22),
            ]

        case "能量脉冲":
            return [
                makeFilled(size: size, color: color, opacity: opacity * 1.1),
                makeRing(size: size * 1.16, lineWidth: lineWidth, color: color, opacity: opacity * 0.58),
            ]

        default: // 单环
            return [
                makeRing(size: size, lineWidth: lineWidth, color: color, opacity: opacity),
            ]
        }
    }

    private func makeRing(size: CGFloat, lineWidth: CGFloat, color: NSColor, opacity: CGFloat) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.path = CGPath(ellipseIn: CGRect(x: -size / 2, y: -size / 2, width: size, height: size), transform: nil)
        layer.strokeColor = color.withAlphaComponent(opacity).cgColor
        layer.fillColor = NSColor.clear.cgColor
        layer.lineWidth = lineWidth
        layer.opacity = Float(opacity)
        return layer
    }

    private func makeFilled(size: CGFloat, color: NSColor, opacity: CGFloat) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.path = CGPath(ellipseIn: CGRect(x: -size / 2, y: -size / 2, width: size, height: size), transform: nil)
        layer.fillColor = color.withAlphaComponent(opacity * 0.3).cgColor
        layer.opacity = Float(opacity)
        return layer
    }
}
