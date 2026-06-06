import Cocoa

class OverlayParticleFX {
    func clear() {}

    func spawn(at point: NSPoint, config: ActionConfig.ConfigData, parent: CALayer) {
        let count = min(config.particleCount ?? 16, 60)
        let size = CGFloat(config.particleSize ?? 12)
        let durationValue = config.particleDuration ?? 780
        let duration = Double(durationValue) / 1000.0
        let opacity = CGFloat(config.particleOpacity ?? 88) / 100.0
        let palette = config.particlePalette ?? ["#F59E0B"]
        let baseColor = hexColor(palette.first)
        let spread = CGFloat(config.particleSpread ?? 60)
        let direction = config.particleDirection ?? "四周扩散"
        let gravity = CGFloat(config.particleGravity ?? 0)
        let wind = CGFloat(config.particleWind ?? 0)

        for i in 0..<count {
            let shapeLayer = CAShapeLayer()
            let particleSize = size * CGFloat.random(in: 0.5...1.0)
            shapeLayer.path = pathForStyle(config.particleStyle ?? "点状粒子", size: particleSize)
            shapeLayer.fillColor = baseColor.withAlphaComponent(opacity).cgColor
            shapeLayer.position = point
            shapeLayer.opacity = Float(opacity)

            parent.addSublayer(shapeLayer)

            // Angle and distance
            let angle: CGFloat
            switch direction {
            case "向上喷发":
                angle = CGFloat.random(in: -.pi * 0.9 ... .pi * 0.9)
            case "旋转扫射":
                let step = (.pi * 2) / CGFloat(count)
                angle = step * CGFloat(i) + CGFloat.random(in: -0.15...0.15)
            default: // 四周扩散, 随机散射
                angle = CGFloat.random(in: 0...(2 * .pi))
            }

            let dist = CGFloat.random(in: 0.4...1.0) * spread
            let endX = cos(angle) * dist
            let endY = sin(angle) * dist

            // Apply gravity & wind as adjustments to endpoint
            let finalX = endX + wind * dist * 0.02
            let finalY = endY + gravity * dist * 0.03

            let moveX = CABasicAnimation(keyPath: "position.x")
            moveX.byValue = finalX
            moveX.duration = duration
            moveX.timingFunction = timingFunction(from: "缓出")

            let moveY = CABasicAnimation(keyPath: "position.y")
            moveY.byValue = finalY
            moveY.duration = duration
            moveY.timingFunction = timingFunction(from: "缓出")

            let fadeOut = CABasicAnimation(keyPath: "opacity")
            fadeOut.fromValue = Float(opacity)
            fadeOut.toValue = 0.0
            fadeOut.duration = duration

            let group = CAAnimationGroup()
            group.animations = [moveX, moveY, fadeOut]
            group.duration = duration
            group.isRemovedOnCompletion = false
            group.fillMode = .forwards

            shapeLayer.add(group, forKey: "particle-\(i)")

            DispatchQueue.main.asyncAfter(deadline: .now() + duration + 0.05) {
                shapeLayer.removeFromSuperlayer()
            }
        }
    }

    private func pathForStyle(_ style: String, size: CGFloat) -> CGPath {
        switch style {
        case "方块":
            return CGPath(rect: CGRect(x: -size / 2, y: -size / 2, width: size, height: size), transform: nil)
        case "钻石":
            let diamond = CGMutablePath()
            diamond.move(to: CGPoint(x: 0, y: -size / 2))
            diamond.addLine(to: CGPoint(x: size / 2, y: 0))
            diamond.addLine(to: CGPoint(x: 0, y: size / 2))
            diamond.addLine(to: CGPoint(x: -size / 2, y: 0))
            diamond.closeSubpath()
            return diamond
        case "火花":
            let spark = CGMutablePath()
            spark.move(to: CGPoint(x: 0, y: -size / 2))
            spark.addLine(to: CGPoint(x: size / 3, y: size / 3))
            spark.addLine(to: CGPoint(x: -size / 3, y: size / 3))
            spark.closeSubpath()
            return spark
        default: // 点状粒子, 星光, 心形 etc → circle
            return CGPath(ellipseIn: CGRect(x: -size / 2, y: -size / 2, width: size, height: size), transform: nil)
        }
    }
}
