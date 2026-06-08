import Cocoa

/// Mirrors EffectsEngine._spawnText in lib/effects/effects_engine.dart.
/// Creates CATextLayer and registers TextRecord with AnimationDriver.
class OverlayTextFX {
    func spawn(at point: NSPoint, config: ActionConfig.ConfigData, parent: CALayer, driver: AnimationDriver) {
        let content: String
        if let textContent = config.textContent, !textContent.isEmpty {
            content = textContent
        } else {
            content = "\u{2726}"
        }
        let fontSize = CGFloat(config.fontSize ?? 24)
        let duration = Double(config.textDuration ?? 1000) / 1000.0
        let textColor = hexColor(config.textColor)
        let opacity = CGFloat(config.textOpacity ?? 100) / 100.0
        let offsetY = CGFloat(config.textOffsetY ?? -28)
        let floatDistance = abs(offsetY)
        let offsetX = CGFloat(config.textOffsetX ?? 0)

        let textLayer = CATextLayer()
        textLayer.string = content
        textLayer.fontSize = fontSize
        textLayer.foregroundColor = textColor.withAlphaComponent(opacity).cgColor
        textLayer.alignmentMode = .center
        textLayer.contentsScale = NSScreen.main?.backingScaleFactor ?? 2.0

        // Font family / weight (mirrors TextFeedbackCard UI options)
        if let family = config.textFontFamily, family != "系统默认" {
            let ctWeight: CGFloat
            switch config.textWeight {
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

        // Outline (stroke)
        let outlineWidth = CGFloat(config.textOutlineWidth ?? 0)
        if outlineWidth > 0 {
            textLayer.shouldRasterize = true
            textLayer.rasterizationScale = NSScreen.main?.backingScaleFactor ?? 2.0
        }

        // Shadow
        if let shadowStyle = config.textShadow, shadowStyle != "无" {
            textLayer.shadowOpacity = 0.35
            textLayer.shadowRadius = shadowStyle == "强" ? 4 : 3
            textLayer.shadowOffset = NSSize(width: 0, height: -1)
            textLayer.shadowColor = NSColor.black.cgColor
        }

        // Layout: center around the click point with offset
        let textWidth: CGFloat = 200
        textLayer.frame = CGRect(
            x: point.x - textWidth / 2 + offsetX,
            y: point.y - fontSize + offsetY,
            width: textWidth,
            height: fontSize * 1.4
        )
        textLayer.opacity = Float(opacity)

        parent.addSublayer(textLayer)

        // Capture start position (center of frame) for manual animation
        let startPos = textLayer.position

        let record = TextRecord(
            layer: textLayer,
            startX: startPos.x, startY: startPos.y,
            offsetX: offsetX,
            floatDistance: floatDistance,
            startOpacity: Float(opacity),
            duration: duration,
            easing: config.textEasing ?? "缓出"
        )
        driver.addText(record)
    }
}
