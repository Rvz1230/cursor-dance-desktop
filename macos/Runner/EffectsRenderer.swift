import Cocoa

// MARK: - Easing utilities

/// Newton-Raphson solver for cubic bezier x(t) → y(t).
/// Used for pre-computing keyframe values where CAKeyframeAnimation needs sampled positions.
private func solveBezier(_ x: Double, _ cp1x: Double, _ cp1y: Double, _ cp2x: Double, _ cp2y: Double) -> Double {
    var t = x
    for _ in 0..<10 {
        let mt = 1.0 - t
        let xSamp = 3.0 * mt * mt * t * cp1x + 3.0 * mt * t * t * cp2x + t * t * t
        let dx = 3.0 * mt * mt * cp1x + 6.0 * mt * t * (cp2x - cp1x) + 3.0 * t * t * (1.0 - cp2x)
        if abs(dx) < 1e-10 { break }
        t -= (xSamp - x) / dx
        t = min(max(t, 0.0), 1.0)
    }
    let mt = 1.0 - t
    return 3.0 * mt * mt * t * cp1y + 3.0 * mt * t * t * cp2y + t * t * t
}

/// Easing function for keyframe pre-computation.
/// Chinese names match the Dart side and CAMediaTimingFunction control points.
func ease(_ name: String, _ t: Double) -> Double {
    switch name {
    case "线性":
        return t
    case "缓入":
        return t * t
    case "缓出":
        return 1.0 - (1.0 - t) * (1.0 - t)
    case "缓入缓出":
        return t < 0.5 ? 2.0 * t * t : 1.0 - (-2.0 * t + 2.0) * (-2.0 * t + 2.0) / 2.0
    case "弹跳":
        return solveBezier(t, 0.34, 1.56, 0.64, 1.0)
    case "弹性":
        return solveBezier(t, 0.22, 1.0, 0.36, 1.18)
    default:
        return 1.0 - (1.0 - t) * (1.0 - t) // easeOut
    }
}

/// Easing name → CAMediaTimingFunction mapping for CAAnimation.
func easingFunction(_ name: String) -> CAMediaTimingFunction {
    switch name {
    case "线性":     return .init(name: .linear)
    case "缓入":     return .init(name: .easeIn)
    case "缓出":     return .init(name: .easeOut)
    case "缓入缓出": return .init(name: .easeInEaseOut)
    case "弹跳":     return .init(controlPoints: 0.34, 1.56, 0.64, 1.0)
    case "弹性":     return .init(controlPoints: 0.22, 1.0, 0.36, 1.18)
    default:         return .init(name: .easeOut)
    }
}

/// Shared FX renderer used by both OverlayManager and PreviewRenderer.
/// Guarantees overlay and preview call the same playClickEffects() —
/// identical rendering for any given ActionConfig.
class EffectsRenderer {
    private let particleFX = OverlayParticleFX()
    private let textFX = OverlayTextFX()
    private let rippleFX = OverlayRippleFX()
    private let animationFX = OverlayAnimationFX()
    private let imageFX = OverlayImageFX()

    /// Spawn all enabled click effects at the given point.
    func playClickEffects(at point: NSPoint, config: ActionConfig.ConfigData,
                          parent: CALayer, runIndex: Int = 1) {
        if config.textEnabled == true {
            textFX.spawn(at: point, config: config, parent: parent, runIndex: runIndex)
        }
        if config.particle == true {
            particleFX.spawn(at: point, config: config, parent: parent)
        }
        if config.ripple == true {
            rippleFX.spawn(at: point, config: config, parent: parent)
        }
        if config.animationEnabled == true {
            animationFX.spawn(at: point, config: config, parent: parent)
        }
        if config.imageEnabled == true {
            imageFX.spawn(at: point, config: config, parent: parent)
        }
    }
}
