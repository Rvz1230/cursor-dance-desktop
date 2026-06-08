import Cocoa

/// Key press visual feedback renderer.
/// Spawns animated character blocks on the overlay in response to keyboard events.
/// Animation records (KeyRecord) are driven by AnimationDriver; cleanup is automatic
/// when the record finishes.
class OverlayKeyFeedbackFX {
    private var activeCount = 0

    func activeLayerCount() -> Int { activeCount }

    /// Spawn a key character animation.
    func spawn(keyCode: Int, character: String, config: KeyFeedbackConfigData, parent: CALayer, driver: AnimationDriver) {
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
        parent.addSublayer(textLayer)

        let record = KeyRecord(
            layer: textLayer,
            startX: posX, startY: startY, endY: endY,
            startOpacity: opacity,
            duration: duration,
            easing: config.easing ?? "弹跳",
            animationStyle: style,
            gravity: gravity,
            fontSize: fontSize * scale,
            startDelay: startDelay
        )
        driver.addKey(record)

        // Decrement count after duration (driver handles layer removal)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration + startDelay + 0.1) { [weak self] in
            self?.activeCount -= 1
        }
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
