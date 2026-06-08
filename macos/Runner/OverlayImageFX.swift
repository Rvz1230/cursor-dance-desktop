import Cocoa

// MARK: - ImageRecord

class ImageRecord {
    let layer: CALayer
    let startX: CGFloat
    let startY: CGFloat
    let floatDistance: CGFloat
    let startOpacity: Float
    let duration: CFTimeInterval
    let startDelay: CFTimeInterval
    var elapsed: CFTimeInterval = 0
    var finished = false

    /// Phase timing: fadeIn = first 15%, hold = 15-65%, fadeOut = 65-100%
    private let fadeInFraction: CGFloat = 0.15
    private let fadeOutStartFraction: CGFloat = 0.65

    init(layer: CALayer,
         startX: CGFloat, startY: CGFloat,
         floatDistance: CGFloat,
         startOpacity: Float,
         duration: CFTimeInterval,
         startDelay: CFTimeInterval = 0)
    {
        self.layer = layer
        self.startX = startX; self.startY = startY
        self.floatDistance = floatDistance
        self.startOpacity = startOpacity
        self.duration = duration
        self.startDelay = startDelay
        layer.actions = ["position": NSNull(), "opacity": NSNull()]
    }

    func advance(by dt: CFTimeInterval) {
        elapsed += dt
        let effective = elapsed - startDelay
        guard effective > 0 else { return }
        let t = min(effective / duration, 1.0)

        // Position: slight float upward
        layer.position = CGPoint(
            x: startX,
            y: startY + floatDistance * CGFloat(t)
        )

        // Opacity: fade in → hold → fade out
        if t < fadeInFraction {
            // Fade in
            layer.opacity = startOpacity * Float(CGFloat(t) / fadeInFraction)
        } else if t < fadeOutStartFraction {
            // Hold
            layer.opacity = startOpacity
        } else {
            // Fade out
            let fadeProgress = (CGFloat(t) - fadeOutStartFraction) / (1.0 - fadeOutStartFraction)
            layer.opacity = startOpacity * Float(1.0 - fadeProgress)
        }

        if t >= 1.0 { finished = true }
    }
}

// MARK: - OverlayImageFX

/// Image sticker feedback — displays an image that fades in, holds, then fades out with a slight float.
class OverlayImageFX {
    func spawn(at point: NSPoint, config: ActionConfig.ConfigData, parent: CALayer, driver: AnimationDriver) {
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
        let imageSize = min(size, 120) // cap at 120
        imageLayer.frame = CGRect(
            x: point.x - imageSize / 2 + offsetX,
            y: point.y - imageSize / 2 + offsetY,
            width: imageSize,
            height: imageSize
        )
        imageLayer.opacity = 0 // start invisible
        parent.addSublayer(imageLayer)

        let record = ImageRecord(
            layer: imageLayer,
            startX: imageLayer.frame.midX,
            startY: imageLayer.frame.midY,
            floatDistance: -8, // slight upward float
            startOpacity: Float(baseOpacity),
            duration: duration,
            startDelay: baseDelay
        )
        driver.addImage(record)
    }

    private func decodeImage(from dataUrl: String) -> CGImage? {
        // Support both base64 data URLs and raw base64 strings
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
