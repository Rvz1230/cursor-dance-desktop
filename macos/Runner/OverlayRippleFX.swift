import Cocoa

class OverlayRippleFX {
    func clear() {}

    func spawn(at point: NSPoint, config: ActionConfig.ConfigData, parent: CALayer) {
        let size = CGFloat(config.rippleSize ?? 72)
        let duration = Double(config.rippleDuration ?? 860) / 1000.0
        let opacity = CGFloat(config.rippleOpacity ?? 72) / 100.0
        let lineWidth = CGFloat(config.rippleLineWidth ?? 2)
        let color = hexColor(config.rippleColor)
        let style = config.rippleStyle ?? "单环"

        let layers = rippleLayers(for: style, size: size, opacity: opacity, lineWidth: lineWidth, color: color, duration: duration)

        for (layer, delay) in layers {
            layer.position = point
            parent.addSublayer(layer)

            let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
            scaleAnim.fromValue = 0.18
            scaleAnim.toValue = 1.0
            scaleAnim.duration = duration
            scaleAnim.timingFunction = timingFunction(from: config.rippleEasing)

            let fadeOut = CABasicAnimation(keyPath: "opacity")
            fadeOut.fromValue = Float(opacity)
            fadeOut.toValue = 0.0
            fadeOut.duration = duration

            let group = CAAnimationGroup()
            group.animations = [scaleAnim, fadeOut]
            group.duration = duration
            group.beginTime = CACurrentMediaTime() + delay
            group.isRemovedOnCompletion = false
            group.fillMode = .forwards

            layer.add(group, forKey: "ripple-\(delay)")

            DispatchQueue.main.asyncAfter(deadline: .now() + duration + delay + 0.05) {
                layer.removeFromSuperlayer()
            }
        }
    }

    private func rippleLayers(
        for style: String,
        size: CGFloat,
        opacity: CGFloat,
        lineWidth: CGFloat,
        color: NSColor,
        duration: Double
    ) -> [(CAShapeLayer, TimeInterval)] {
        let stagger: TimeInterval = 0.08
        switch style {
        case "双环":
            return [
                makeRing(size: size, lineWidth: lineWidth, color: color, opacity: opacity),
                makeRing(size: size * 1.12, lineWidth: lineWidth * 0.8, color: color, opacity: opacity * 0.82),
            ].enumerated().map { ($0.element, Double($0.offset) * stagger) }

        case "柔和面波":
            return [
                makeFilled(size: size, color: color, opacity: opacity),
            ].enumerated().map { ($0.element, Double($0.offset) * stagger) }

        case "脉冲波纹":
            return [
                makeFilled(size: size, color: color, opacity: opacity),
                makeRing(size: size * 1.24, lineWidth: lineWidth, color: color, opacity: opacity * 0.52),
                makeRing(size: size * 1.4, lineWidth: lineWidth * 0.6, color: color, opacity: opacity * 0.26),
            ].enumerated().map { ($0.element, Double($0.offset) * stagger) }

        case "回声环":
            return [
                makeRing(size: size, lineWidth: lineWidth, color: color, opacity: opacity),
                makeRing(size: size * 1.1, lineWidth: lineWidth * 0.9, color: color, opacity: opacity * 0.68),
                makeRing(size: size * 1.22, lineWidth: lineWidth * 0.8, color: color, opacity: opacity * 0.44),
                makeRing(size: size * 1.36, lineWidth: lineWidth * 0.6, color: color, opacity: opacity * 0.22),
            ].enumerated().map { ($0.element, Double($0.offset) * stagger) }

        case "能量脉冲":
            return [
                makeFilled(size: size, color: color, opacity: opacity * 1.1),
                makeRing(size: size * 1.16, lineWidth: lineWidth, color: color, opacity: opacity * 0.58),
            ].enumerated().map { ($0.element, Double($0.offset) * stagger) }

        default: // 单环
            return [
                makeRing(size: size, lineWidth: lineWidth, color: color, opacity: opacity),
            ].enumerated().map { ($0.element, Double($0.offset) * stagger) }
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
