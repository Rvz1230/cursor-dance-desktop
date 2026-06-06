import Cocoa

class OverlayTextFX {
    func clear() {}

    func spawn(at point: NSPoint, config: ActionConfig.ConfigData, parent: CALayer) {
        guard let content = config.textContent, !content.isEmpty else { return }
        let fontSize = CGFloat(config.fontSize ?? 24)
        let duration = Double(config.textDuration ?? 1000) / 1000.0
        let textColor = hexColor(config.textColor)
        let opacity = CGFloat(config.textOpacity ?? 100) / 100.0
        let offsetY = CGFloat(config.textOffsetY ?? -28)

        let textLayer = CATextLayer()
        textLayer.string = content
        textLayer.fontSize = fontSize
        textLayer.foregroundColor = textColor.withAlphaComponent(opacity).cgColor
        textLayer.alignmentMode = .center
        textLayer.contentsScale = NSScreen.main?.backingScaleFactor ?? 2.0
        textLayer.frame = CGRect(x: point.x - 100, y: point.y - fontSize, width: 200, height: fontSize * 1.4)
        textLayer.opacity = Float(opacity)

        parent.addSublayer(textLayer)

        let moveUp = CABasicAnimation(keyPath: "position.y")
        moveUp.byValue = offsetY
        moveUp.duration = duration
        moveUp.timingFunction = timingFunction(from: config.textEasing)

        let fadeOut = CABasicAnimation(keyPath: "opacity")
        fadeOut.fromValue = Float(opacity)
        fadeOut.toValue = 0.0
        fadeOut.duration = duration

        let group = CAAnimationGroup()
        group.animations = [moveUp, fadeOut]
        group.duration = duration
        group.isRemovedOnCompletion = false
        group.fillMode = .forwards

        textLayer.add(group, forKey: "text-float")

        DispatchQueue.main.asyncAfter(deadline: .now() + duration + 0.05) {
            textLayer.removeFromSuperlayer()
        }
    }
}
