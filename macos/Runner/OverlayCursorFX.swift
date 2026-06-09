import Cocoa

// MARK: - OverlayCursorFX

/// Cursor feedback — override cursor appearance and shake on click.
/// Mirrors plugin renderCursorOverride().
class OverlayCursorFX {
    func spawn(at point: NSPoint, config: ActionConfig.ConfigData, parent: CALayer, driver: AnimationDriver) {
        let shakeValue = CGFloat(config.shake ?? 0)
        let hasOverride = hasCursorOverride(config.cursorOverride)
        let hasTrail = config.cursorTrailEnabled == true

        // Ensure at least one effect is active
        guard shakeValue > 0 || hasOverride || hasTrail else { return }

        let cursorSize = CGFloat(config.cursorSize ?? 48)
        let duration: CFTimeInterval = 0.3
        let startOpacity: Float = 0.92

        let layer = createCursorLayer(override: config.cursorOverride, size: cursorSize)
        layer.position = point
        layer.opacity = startOpacity
        parent.addSublayer(layer)

        let record = CursorRecord(
            layer: layer,
            startX: point.x,
            startY: point.y,
            shake: shakeValue,
            startOpacity: startOpacity,
            duration: duration
        )
        driver.add(record)

        // ── Trail ghosts ──
        if hasTrail {
            let trailCount = min(config.cursorTrailCount ?? 5, 12)
            let trailOpacity = CGFloat(config.cursorTrailOpacity ?? 50) / 100.0
            for i in 0..<trailCount {
                let ghostSize = cursorSize * (1.0 - CGFloat(i) * 0.06)
                let ghostLayer = createTrailLayer(size: ghostSize, opacity: trailOpacity)
                ghostLayer.position = point
                parent.addSublayer(ghostLayer)

                let ghostDuration: CFTimeInterval = 0.2 + Double(i) * 0.04
                let ghostRecord = CursorRecord(
                    layer: ghostLayer,
                    startX: point.x,
                    startY: point.y,
                    shake: shakeValue * 0.5,
                    startOpacity: Float(trailOpacity),
                    duration: ghostDuration
                )
                driver.add(ghostRecord)
            }
        }
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

        // Add shadow for depth
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
