import Cocoa

/// Cursor feedback — override cursor appearance and shake on click.
/// Uses CAKeyframeAnimation with pre-sampled shake trajectory.
class OverlayCursorFX {
    func spawn(at point: NSPoint, config: ActionConfig.ConfigData, parent: CALayer) {
        let shakeValue = CGFloat(config.shake ?? 0)
        let hasOverride = hasCursorOverride(config.cursorOverride)
        let hasTrail = config.cursorTrailEnabled == true

        guard shakeValue > 0 || hasOverride || hasTrail else { return }

        let cursorSize = CGFloat(config.cursorSize ?? 48)
        let duration: CFTimeInterval = 0.3
        let startOpacity: Float = 0.92

        let layer = createCursorLayer(override: config.cursorOverride, size: cursorSize)

        animateCursor(layer: layer, startX: point.x, startY: point.y,
                      shake: shakeValue, startOpacity: startOpacity, duration: duration,
                      parent: parent)

        // ── Trail ghosts ──
        if hasTrail {
            let trailCount = min(config.cursorTrailCount ?? 5, 12)
            let trailOpacity = CGFloat(config.cursorTrailOpacity ?? 50) / 100.0
            for i in 0..<trailCount {
                let ghostSize = cursorSize * (1.0 - CGFloat(i) * 0.06)
                let ghostLayer = createTrailLayer(size: ghostSize, opacity: trailOpacity)
                animateCursor(layer: ghostLayer, startX: point.x, startY: point.y,
                              shake: shakeValue * 0.5, startOpacity: Float(trailOpacity),
                              duration: 0.2 + Double(i) * 0.04, parent: parent)
            }
        }
    }

    // MARK: - Animation

    private func animateCursor(layer: CALayer, startX: CGFloat, startY: CGFloat,
                                shake: CGFloat, startOpacity: Float, duration: CFTimeInterval,
                                parent: CALayer) {
        // Pre-sample shake trajectory
        let frameCount = max(Int(duration * 60), 20)
        var positions: [NSPoint] = []
        for i in 0...frameCount {
            let t = Double(i) / Double(frameCount)
            let shakeDecay = shake * CGFloat(1.0 - t)
            let sx = CGFloat.random(in: -shakeDecay...shakeDecay)
            let sy = CGFloat.random(in: -shakeDecay...shakeDecay)
            positions.append(CGPoint(x: startX + sx, y: startY + sy))
        }

        // Scale: 0.86 → 1.0 (t<0.2) → 1.0 (0.2<t<0.5) → 0.9 (t>0.5)
        let scaleValues: [CGFloat] = [0.86, 1.0, 1.0, 0.9]
        let scaleKeyTimes: [NSNumber] = [0, 0.2, 0.5, 1.0]

        // Opacity: hold → fade out (t>0.5)
        let opacityValues: [Float] = [startOpacity, startOpacity, 0]
        let opacityKeyTimes: [NSNumber] = [0, 0.5, 1.0]

        // Model values = final state (set before addSublayer to avoid flicker)
        if let lastPos = positions.last { layer.position = lastPos }
        layer.transform = CATransform3DMakeScale(0.9, 0.9, 1)
        layer.opacity = 0
        parent.addSublayer(layer)

        CATransaction.begin()
        CATransaction.setCompletionBlock { layer.removeFromSuperlayer() }

        let posAnim = CAKeyframeAnimation(keyPath: "position")
        posAnim.values = positions
        posAnim.duration = duration
        posAnim.timingFunction = easingFunction("缓出")
        posAnim.fillMode = .backwards
        layer.add(posAnim, forKey: "position")

        let scaleAnim = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnim.values = scaleValues
        scaleAnim.keyTimes = scaleKeyTimes
        scaleAnim.duration = duration
        scaleAnim.fillMode = .backwards
        layer.add(scaleAnim, forKey: "transform.scale")

        let opacityAnim = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnim.values = opacityValues
        opacityAnim.keyTimes = opacityKeyTimes
        opacityAnim.duration = duration
        opacityAnim.fillMode = .backwards
        layer.add(opacityAnim, forKey: "opacity")

        CATransaction.commit()
    }

    // MARK: - Layer creation

    private func createCursorLayer(override: String?, size: CGFloat) -> CALayer {
        let kind = cursorOverrideKind(override)
        let layer = CAShapeLayer()
        layer.path = CGPath(ellipseIn: CGRect(x: -size / 2, y: -size / 2, width: size, height: size), transform: nil)

        switch kind {
        case "boost":
            layer.fillColor = CGColor(red: 253/255, green: 224/255, blue: 71/255, alpha: 0.95)
            layer.strokeColor = CGColor(red: 180/255, green: 83/255, blue: 9/255, alpha: 0.9)
            layer.lineWidth = 2
        case "press":
            layer.fillColor = CGColor(red: 251/255, green: 191/255, blue: 36/255, alpha: 0.92)
            layer.strokeColor = CGColor(red: 146/255, green: 64/255, blue: 14/255, alpha: 0.9)
            layer.lineWidth = 2
            layer.path = CGPath(ellipseIn: CGRect(x: -size / 2, y: -size / 2, width: size, height: size * 1.12), transform: nil)
        case "woodfish", "pointer":
            layer.fillColor = CGColor(red: 252/255, green: 211/255, blue: 77/255, alpha: 0.94)
            layer.strokeColor = CGColor(red: 180/255, green: 83/255, blue: 9/255, alpha: 0.85)
            layer.lineWidth = 2
        default:
            return layer
        }

        layer.shadowOpacity = 0.3
        layer.shadowRadius = 6
        layer.shadowOffset = NSSize(width: 0, height: 2)
        layer.shadowColor = NSColor.black.cgColor

        return layer
    }

    private func createTrailLayer(size: CGFloat, opacity: CGFloat) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.path = CGPath(ellipseIn: CGRect(x: -size / 2, y: -size / 2, width: size, height: size), transform: nil)
        layer.fillColor = NSColor.white.withAlphaComponent(opacity * 0.3).cgColor
        layer.strokeColor = NSColor.white.withAlphaComponent(opacity * 0.5).cgColor
        layer.lineWidth = 1
        layer.opacity = Float(opacity)
        return layer
    }

    // MARK: - Helpers

    private func hasCursorOverride(_ override: String?) -> Bool {
        return cursorOverrideKind(override) != nil
    }

    private func cursorOverrideKind(_ override: String?) -> String? {
        guard let o = override else { return nil }
        if o == "木鱼（增强态）" { return "boost" }
        if o == "木鱼（按压态）" { return "press" }
        if o == "木鱼（继承默认）" { return "woodfish" }
        if o == "切换到 pointer" { return "pointer" }
        return nil
    }
}
