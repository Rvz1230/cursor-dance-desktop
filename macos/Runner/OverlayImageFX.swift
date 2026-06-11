import Cocoa

/// Image sticker feedback — displays an image that fades in, holds, then fades out with a slight float.
/// Uses CABasicAnimation for position + CAKeyframeAnimation for 3-phase opacity.
class OverlayImageFX {
    func spawn(at point: NSPoint, config: ActionConfig.ConfigData, parent: CALayer) {
        guard let urlString = config.imageDataUrl, !urlString.isEmpty else { return }

        let size = CGFloat(config.imageSize ?? 56)
        let duration = Double(config.imageDuration ?? 780) / 1000.0
        let baseOpacity = CGFloat(config.imageOpacity ?? 100) / 100.0
        let offsetX = CGFloat(config.imageOffsetX ?? 0)
        let offsetY = CGFloat(config.imageOffsetY ?? -18)
        let baseDelay = Double(config.imageDelay ?? 0) / 1000.0

        // Decode base64 image
        guard let image = decodeImage(from: urlString) else { return }

        let imageLayer = CALayer()
        imageLayer.contents = image
        imageLayer.contentsGravity = .resizeAspect
        let imageSize = min(size, 120)
        imageLayer.frame = CGRect(
            x: point.x - imageSize / 2 + offsetX,
            y: point.y - imageSize / 2 + offsetY,
            width: imageSize,
            height: imageSize
        )
        let startPos = imageLayer.position
        let floatDistance: CGFloat = -8
        let endPos = CGPoint(x: startPos.x, y: startPos.y + floatDistance)
        let startOpacity = Float(baseOpacity)

        // Model values = final state (set before addSublayer to avoid flicker)
        imageLayer.position = endPos
        imageLayer.opacity = 0
        parent.addSublayer(imageLayer)

        CATransaction.begin()
        CATransaction.setCompletionBlock { imageLayer.removeFromSuperlayer() }

        // Position: slight float upward
        let posAnim = CABasicAnimation(keyPath: "position")
        posAnim.fromValue = startPos
        posAnim.toValue = endPos
        posAnim.duration = duration
        posAnim.beginTime = CACurrentMediaTime() + baseDelay
        posAnim.timingFunction = CAMediaTimingFunction(name: .linear)
        posAnim.fillMode = .backwards
        imageLayer.add(posAnim, forKey: "position")

        // Opacity: fade in → hold → fade out
        let opacityAnim = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnim.values = [0, startOpacity, startOpacity, 0]
        opacityAnim.keyTimes = [0, 0.15, 0.65, 1.0]
        opacityAnim.duration = duration
        opacityAnim.beginTime = CACurrentMediaTime() + baseDelay
        opacityAnim.fillMode = .backwards
        imageLayer.add(opacityAnim, forKey: "opacity")

        CATransaction.commit()
    }

    private func decodeImage(from dataUrl: String) -> CGImage? {
        let base64: String
        if dataUrl.contains(",") {
            base64 = String(dataUrl.split(separator: ",").last ?? "")
        } else {
            base64 = dataUrl
        }
        guard let data = Data(base64Encoded: base64),
              let image = NSImage(data: data) else { return nil }
        return image.cgImage(forProposedRect: nil, context: nil, hints: nil)
    }
}
