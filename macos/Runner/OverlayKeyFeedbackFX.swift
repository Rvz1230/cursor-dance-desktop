import Cocoa

/// Key press visual feedback renderer.
/// Uses CAKeyframeAnimation for position, scale, and opacity.
/// Raindrop mode pre-samples wobble trajectory; bounce uses CABasicAnimation for position.
class OverlayKeyFeedbackFX {
    private var activeCount = 0

    func activeLayerCount() -> Int { activeCount }

    /// Spawn a key character animation.
    func spawn(keyCode: Int, character: String, config: KeyFeedbackConfigData, parent: CALayer) {
        guard activeCount < (config.maxSimultaneous ?? 20) else { return }

        let screenWidth = parent.bounds.width
        let screenHeight = parent.bounds.height
        let fontSize = CGFloat(config.fontSize ?? 48)
        let duration = Double(config.duration ?? 900) / 1000.0
        let opacity = Float(config.opacity ?? 90) / 100.0
        let style = config.animationStyle ?? "bounce"
        let originEdge = config.originEdge ?? "bottom"
        let bounceHeight = CGFloat(config.bounceHeight ?? 140)
        let gravity = config.gravity ?? 0.3
        let scale = CGFloat(config.scale ?? 1.0)
        let startDelay = Double(config.delay ?? 0) / 1000.0

        // Calculate X position from key layout mapping
        let normalizedX: CGFloat
        if config.originMapping == "center" {
            normalizedX = CGFloat(config.globalOffsetX ?? 0.5)
        } else {
            normalizedX = CGFloat(keyLayoutNormalizedX(keyCode))
        }
        let posX = screenWidth * normalizedX

        // Calculate start/end Y based on origin edge and animation style
        let startY: CGFloat
        let endY: CGFloat
        let margin = screenHeight * CGFloat(config.globalOffsetY ?? 0.08)

        switch (style, originEdge) {
        case ("raindrop", _):
            startY = screenHeight + fontSize
            endY = screenHeight * 0.35 + CGFloat.random(in: -40...40)
        case (_, "top"):
            startY = screenHeight + fontSize
            endY = screenHeight - margin
        default:
            startY = -fontSize
            endY = margin + bounceHeight + CGFloat.random(in: -20...20)
        }

        let textLayer = CATextLayer()
        textLayer.alignmentMode = .center
        textLayer.contentsScale = NSScreen.main?.backingScaleFactor ?? 2.0
        textLayer.string = config.uppercase == true ? character.uppercased() : character
        textLayer.fontSize = fontSize * scale
        textLayer.foregroundColor = hexColor(config.color).withAlphaComponent(CGFloat(opacity)).cgColor

        // Font
        applyFont(to: textLayer, family: config.fontFamily, weight: config.fontWeight, fontSize: fontSize * scale)

        let layerWidth: CGFloat = max(fontSize * 2.5, 80)
        let layerHeight: CGFloat = fontSize * 1.3
        textLayer.frame = CGRect(x: posX - layerWidth / 2, y: startY - layerHeight / 2, width: layerWidth, height: layerHeight)

        // Glow
        if config.glow == true {
            textLayer.shadowOpacity = 0.8
            textLayer.shadowRadius = CGFloat(config.glowRadius ?? 8)
            textLayer.shadowColor = hexColor(config.glowColor).cgColor
            textLayer.shadowOffset = .zero
        }

        activeCount += 1

        let easing = config.easing ?? "弹跳"

        switch style {
        case "raindrop":
            animateRaindrop(layer: textLayer, posX: posX, startY: startY, endY: endY,
                            startOpacity: opacity, duration: duration, easing: easing,
                            gravity: gravity, startDelay: startDelay, parent: parent)
        default:
            animateBounce(layer: textLayer, posX: posX, startY: startY, endY: endY,
                          startOpacity: opacity, duration: duration, easing: easing,
                          startDelay: startDelay, parent: parent)
        }
    }

    // MARK: - Bounce animation

    private func animateBounce(layer: CALayer, posX: CGFloat, startY: CGFloat, endY: CGFloat,
                                startOpacity: Float, duration: CFTimeInterval, easing: String,
                                startDelay: CFTimeInterval, parent: CALayer) {
        let startPos = CGPoint(x: posX, y: startY)
        let endPos = CGPoint(x: posX, y: endY)

        // Model values = final state (set before addSublayer to avoid flicker)
        layer.position = endPos
        layer.transform = CATransform3DMakeScale(1.0, 1.0, 1)
        layer.opacity = 0
        parent.addSublayer(layer)

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            layer.removeFromSuperlayer()
            self.activeCount -= 1
        }

        // Position: fall down with easing
        let posAnim = CABasicAnimation(keyPath: "position")
        posAnim.fromValue = startPos
        posAnim.toValue = endPos
        posAnim.duration = duration
        posAnim.beginTime = CACurrentMediaTime() + startDelay
        posAnim.timingFunction = easingFunction(easing)
        posAnim.fillMode = .backwards
        layer.add(posAnim, forKey: "position")

        // Scale: 0.3 → 1.15 (t<0.7) → 1.0 (t>0.7)
        let scaleAnim = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnim.values = [0.3, 1.15, 1.0]
        scaleAnim.keyTimes = [0, 0.7, 1.0]
        scaleAnim.duration = duration
        scaleAnim.beginTime = CACurrentMediaTime() + startDelay
        scaleAnim.fillMode = .backwards
        layer.add(scaleAnim, forKey: "transform.scale")

        // Opacity: fade in → hold → fade out
        let opacityAnim = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnim.values = [0, startOpacity, startOpacity, 0]
        opacityAnim.keyTimes = [0, 0.1, 0.8, 1.0]
        opacityAnim.duration = duration
        opacityAnim.beginTime = CACurrentMediaTime() + startDelay
        opacityAnim.fillMode = .backwards
        layer.add(opacityAnim, forKey: "opacity")

        CATransaction.commit()
    }

    // MARK: - Raindrop animation

    private func animateRaindrop(layer: CALayer, posX: CGFloat, startY: CGFloat, endY: CGFloat,
                                  startOpacity: Float, duration: CFTimeInterval, easing: String,
                                  gravity: Double, startDelay: CFTimeInterval, parent: CALayer) {
        // Pre-sample position with gravity + wobble
        let frameCount = max(Int(duration * 60), 30)
        var positions: [NSPoint] = []
        for i in 0...frameCount {
            let t = Double(i) / Double(frameCount)
            let e = ease(easing, t)
            let gravityE = CGFloat(e + (1 - e) * CGFloat(gravity) * (1 - CGFloat(t)))
            let wobble = sin(CGFloat(t) * .pi * 3) * 3.0 * CGFloat(1 - t)
            positions.append(CGPoint(
                x: posX + wobble,
                y: startY - (startY - endY) * gravityE
            ))
        }

        // Model values = final state (set before addSublayer to avoid flicker)
        if let lastPos = positions.last { layer.position = lastPos }
        layer.opacity = 0
        parent.addSublayer(layer)

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            layer.removeFromSuperlayer()
            self.activeCount -= 1
        }

        let posAnim = CAKeyframeAnimation(keyPath: "position")
        posAnim.values = positions
        posAnim.duration = duration
        posAnim.beginTime = CACurrentMediaTime() + startDelay
        posAnim.fillMode = .backwards
        layer.add(posAnim, forKey: "position")

        // Opacity: fade in → hold → fade out
        let opacityAnim = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnim.values = [0, startOpacity, startOpacity, 0]
        opacityAnim.keyTimes = [0, 0.2, 0.7, 1.0]
        opacityAnim.duration = duration
        opacityAnim.beginTime = CACurrentMediaTime() + startDelay
        opacityAnim.fillMode = .backwards
        layer.add(opacityAnim, forKey: "opacity")

        CATransaction.commit()
    }

    // MARK: - Font helper

    private func applyFont(to textLayer: CATextLayer, family: String?, weight: String?, fontSize: CGFloat) {
        guard let family = family, family != "系统默认" else { return }
        let ctWeight: CGFloat
        switch weight {
        case "特细": ctWeight = -0.4
        case "细体": ctWeight = 0.0
        case "标准": ctWeight = 0.23
        case "中等": ctWeight = 0.28
        case "半粗": ctWeight = 0.5
        case "加粗": ctWeight = 0.56
        default: ctWeight = 0.56
        }
        let traits = [kCTFontWeightTrait: ctWeight]
        var attributes: [String: Any] = [kCTFontFamilyNameAttribute as String: family]
        attributes[kCTFontTraitsAttribute as String] = traits
        let fontDescriptor = CTFontDescriptorCreateWithAttributes(attributes as CFDictionary)
        let ctFont = CTFontCreateWithFontDescriptor(fontDescriptor, fontSize, nil)
        textLayer.font = ctFont
    }
}
