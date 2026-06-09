import Cocoa

/// Full text feedback implementation.
/// Mirrors the plugin's renderText() + compute-specs.js getTextContent() pipeline.
class OverlayTextFX {
    func spawn(at point: NSPoint, config: ActionConfig.ConfigData, parent: CALayer, driver: AnimationDriver, runIndex: Int = 1) {
        let content = getTextContent(config: config, runIndex: runIndex)
        let fontSize = CGFloat(config.fontSize ?? 24)
        let duration = Double(config.textDuration ?? 1000) / 1000.0
        let opacity = CGFloat(config.textOpacity ?? 100) / 100.0
        let offsetY = CGFloat(config.textOffsetY ?? -28)
        let floatDistance = abs(offsetY)
        let offsetX = CGFloat(config.textOffsetX ?? 0)
        let startDelay = Double(config.textDelay ?? 0) / 1000.0

        // ── Gradient text → CAGradientLayer mask ──
        let isGradient = config.textGradient == true
        let textColor = hexColor(config.textColor)

        let textLayer = CATextLayer()
        textLayer.string = content
        textLayer.fontSize = fontSize
        textLayer.foregroundColor = isGradient ? NSColor.white.cgColor : textColor.withAlphaComponent(opacity).cgColor
        textLayer.alignmentMode = .center
        textLayer.contentsScale = NSScreen.main?.backingScaleFactor ?? 2.0

        // Font family / weight
        applyFont(to: textLayer, family: config.textFontFamily, weight: config.textWeight, fontSize: fontSize)

        // Outline (NSAttributedString stroke)
        let outlineWidth = CGFloat(config.textOutlineWidth ?? 0)
        if outlineWidth > 0 {
            let attribs = NSAttributedString(string: content, attributes: [
                .strokeWidth: -outlineWidth * 2.0,
                .strokeColor: NSColor.white.withAlphaComponent(0.82),
                .foregroundColor: isGradient ? NSColor.white : textColor.withAlphaComponent(opacity),
                .font: textLayer.font ?? NSFont.systemFont(ofSize: fontSize),
            ])
            textLayer.string = attribs
            textLayer.contentsScale = NSScreen.main?.backingScaleFactor ?? 2.0
        }

        // Shadow
        if let shadowStyle = config.textShadow, shadowStyle != "无" {
            textLayer.shadowOpacity = 0.35
            textLayer.shadowRadius = shadowStyle == "强" ? 4 : 3
            textLayer.shadowOffset = NSSize(width: 0, height: -1)
            textLayer.shadowColor = NSColor.black.cgColor
        }

        // Layout
        let textWidth: CGFloat = 200
        let textFrame = CGRect(
            x: point.x - textWidth / 2 + offsetX,
            y: point.y - fontSize + offsetY,
            width: textWidth,
            height: fontSize * 1.4
        )
        textLayer.frame = textFrame
        textLayer.opacity = Float(opacity)

        let effectiveLayer: CALayer
        if isGradient {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = textFrame
            gradientLayer.colors = [
                hexColor(config.textGradientStart).cgColor,
                hexColor(config.textGradientEnd).cgColor,
            ]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            gradientLayer.mask = textLayer
            gradientLayer.opacity = Float(opacity)
            parent.addSublayer(gradientLayer)
            effectiveLayer = gradientLayer
        } else {
            parent.addSublayer(textLayer)
            effectiveLayer = textLayer
        }

        let startPos = effectiveLayer.position

        let record = TextRecord(
            layer: effectiveLayer,
            startX: startPos.x, startY: startPos.y,
            offsetX: offsetX,
            floatDistance: floatDistance,
            startOpacity: Float(opacity),
            duration: duration,
            easing: config.textEasing ?? "缓出",
            startDelay: startDelay
        )
        driver.add(record)
    }

    // MARK: - Text content computation

    /// Formats a number according to the given style.
    func formatNumber(_ style: String?, _ number: Int) -> String {
        guard let style = style else { return String(number) }
        if style.contains("中文") {
            let values = ["一", "二", "三", "四", "五", "六", "七", "八", "九", "十"]
            return values[(number - 1) % values.count]
        }
        if style.contains("英文") {
            let values = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten"]
            return values[(number - 1) % values.count]
        }
        return String(number)
    }

    /// Returns ordered tags with primary text first.
    func getOrderedTextTags(from config: ActionConfig.ConfigData) -> [String] {
        let tags = (config.textTags ?? []).filter { !$0.isEmpty }
        guard let primary = config.textContent, !primary.isEmpty else { return tags }
        return [primary] + tags.filter { $0 != primary }
    }

    /// Computes the final text string — mirrors plugin compute-specs getTextContent().
    func getTextContent(config: ActionConfig.ConfigData, runIndex: Int) -> String {
        guard config.textEnabled == true else { return "静默" }

        if config.textKind == "文本飘字" {
            let tags = getOrderedTextTags(from: config)
            guard !tags.isEmpty else { return "未设置文本" }
            let playMode = config.textTagPlayMode ?? "按顺序显示"
            let index: Int
            if playMode == "随机显示" {
                index = (runIndex * 7) % tags.count
            } else {
                index = ((runIndex - 1) % tags.count + tags.count) % tags.count
            }
            return tags[index]
        }

        // 数字飘字
        let numberValue = (config.comboEnabled == true) ? max(1, runIndex) : 1
        let formatted = formatNumber(config.textStyle, numberValue)

        if config.textMode == "模板模式" {
            let template = config.textTemplate ?? "${number}"
            return template.replacingOccurrences(of: "${number}", with: formatted)
        }

        return "+" + formatted
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
