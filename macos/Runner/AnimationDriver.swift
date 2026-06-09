import Cocoa

// ═══════════════════════════════════════════════════════════════
// AnimatableRecord protocol — shared lifecycle for all effects
// ═══════════════════════════════════════════════════════════════

protocol AnimatableRecord: AnyObject {
    var layer: CALayer { get }
    var elapsed: CFTimeInterval { get set }
    var finished: Bool { get set }
    func advance(by dt: CFTimeInterval)
}

// ═══════════════════════════════════════════════════════════════
// Easing — mirrors lib/effects/effects_engine.dart
// ═══════════════════════════════════════════════════════════════

/// Newton-Raphson solver for cubic bezier x(t) → y(t).
/// Mirrors _solveBezier in effects_engine.dart.
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

/// Easing function matching the Dart side and CAMediaTimingFunction
/// for non-linear curves (弹跳=0.34/1.56/0.64/1, 弹性=0.22/1/0.36/1.18).
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

// ═══════════════════════════════════════════════════════════════
// Animation Record classes
// ═══════════════════════════════════════════════════════════════

class ParticleRecord: AnimatableRecord {
    let layer: CAShapeLayer
    let startX: CGFloat
    let startY: CGFloat
    let deltaX: CGFloat
    let deltaY: CGFloat
    let startOpacity: Float
    let duration: CFTimeInterval
    let startDelay: CFTimeInterval
    let easing: String
    let isOrbital: Bool
    let orbitalRadius: CGFloat
    let orbitalSpeed: CGFloat  // revolutions over duration
    let startAngle: CGFloat
    var elapsed: CFTimeInterval = 0
    var finished = false

    init(layer: CAShapeLayer,
         startX: CGFloat, startY: CGFloat,
         deltaX: CGFloat, deltaY: CGFloat,
         startOpacity: Float,
         duration: CFTimeInterval,
         easing: String,
         startDelay: CFTimeInterval = 0,
         isOrbital: Bool = false,
         orbitalRadius: CGFloat = 0,
         orbitalSpeed: CGFloat = 0,
         startAngle: CGFloat = 0)
    {
        self.layer = layer
        self.startX = startX; self.startY = startY
        self.deltaX = deltaX; self.deltaY = deltaY
        self.startOpacity = startOpacity
        self.duration = duration
        self.startDelay = startDelay
        self.easing = easing
        self.isOrbital = isOrbital
        self.orbitalRadius = orbitalRadius
        self.orbitalSpeed = orbitalSpeed
        self.startAngle = startAngle
        layer.actions = ["position": NSNull(), "opacity": NSNull(), "transform": NSNull()]
    }

    func advance(by dt: CFTimeInterval) {
        elapsed += dt
        let effective = elapsed - startDelay
        guard effective > 0 else { return }
        let t = min(effective / duration, 1.0)
        let e = CGFloat(ease(easing, t))

        if isOrbital {
            let angle = startAngle + orbitalSpeed * 2 * .pi * e
            layer.position = CGPoint(
                x: startX + cos(angle) * orbitalRadius,
                y: startY + sin(angle) * orbitalRadius
            )
        } else {
            layer.position = CGPoint(
                x: startX + deltaX * e,
                y: startY + deltaY * e
            )
        }
        layer.opacity = startOpacity * Float(1.0 - t)

        if t >= 1.0 { finished = true }
    }
}

class TextRecord: AnimatableRecord {
    let layer: CALayer
    let startX: CGFloat
    let startY: CGFloat
    let offsetX: CGFloat
    let floatDistance: CGFloat
    let startOpacity: Float
    let duration: CFTimeInterval
    let startDelay: CFTimeInterval
    let easing: String
    var elapsed: CFTimeInterval = 0
    var finished = false

    init(layer: CALayer,
         startX: CGFloat, startY: CGFloat,
         offsetX: CGFloat, floatDistance: CGFloat,
         startOpacity: Float,
         duration: CFTimeInterval,
         easing: String,
         startDelay: CFTimeInterval = 0)
    {
        self.layer = layer
        self.startX = startX; self.startY = startY
        self.offsetX = offsetX
        self.floatDistance = floatDistance
        self.startOpacity = startOpacity
        self.duration = duration
        self.easing = easing
        self.startDelay = startDelay
        layer.actions = ["position": NSNull(), "opacity": NSNull()]
    }

    func advance(by dt: CFTimeInterval) {
        elapsed += dt
        let effective = elapsed - startDelay
        guard effective > 0 else { return }
        let t = min(effective / duration, 1.0)
        let e = CGFloat(ease(easing, t))

        layer.position = CGPoint(
            x: startX + offsetX * e,
            y: startY + floatDistance * e
        )
        layer.opacity = startOpacity * Float(1.0 - t)

        if t >= 1.0 { finished = true }
    }
}

class RippleRecord: AnimatableRecord {
    let layer: CAShapeLayer
    let startDelay: CFTimeInterval
    let duration: CFTimeInterval
    let easing: String
    let startOpacity: Float
    var elapsed: CFTimeInterval = 0
    var finished = false

    init(layer: CAShapeLayer,
         startDelay: CFTimeInterval,
         duration: CFTimeInterval,
         easing: String,
         startOpacity: Float)
    {
        self.layer = layer
        self.startDelay = startDelay
        self.duration = duration
        self.easing = easing
        self.startOpacity = startOpacity
        layer.actions = ["position": NSNull(), "opacity": NSNull(), "transform": NSNull()]
    }

    func advance(by dt: CFTimeInterval) {
        elapsed += dt
        let effective = elapsed - startDelay
        guard effective > 0 else { return }
        let t = min(effective / duration, 1.0)
        let e = CGFloat(ease(easing, t))

        // Scale 0.18 → 1.0 with easing
        let scale = CGFloat(0.18 + (1.0 - 0.18) * e)
        layer.transform = CATransform3DMakeScale(scale, scale, 1)

        // Opacity fades linearly (no easing on opacity, matching CAAnimation default)
        layer.opacity = startOpacity * Float(1.0 - t)

        if t >= 1.0 { finished = true }
    }
}

class CursorRecord: AnimatableRecord {
    let layer: CALayer
    let startX: CGFloat
    let startY: CGFloat
    let shake: CGFloat
    let startOpacity: Float
    let duration: CFTimeInterval
    var elapsed: CFTimeInterval = 0
    var finished = false

    init(layer: CALayer,
         startX: CGFloat, startY: CGFloat,
         shake: CGFloat,
         startOpacity: Float,
         duration: CFTimeInterval)
    {
        self.layer = layer
        self.startX = startX; self.startY = startY
        self.shake = shake
        self.startOpacity = startOpacity
        self.duration = duration
        layer.actions = ["position": NSNull(), "opacity": NSNull(), "transform": NSNull()]
    }

    func advance(by dt: CFTimeInterval) {
        elapsed += dt
        let t = min(elapsed / duration, 1.0)
        let e = CGFloat(ease("缓出", t))

        // Shake: random offset decaying over time
        let shakeDecay = shake * (1.0 - t)
        let shakeX = CGFloat.random(in: -shakeDecay...shakeDecay)
        let shakeY = CGFloat.random(in: -shakeDecay...shakeDecay)

        layer.position = CGPoint(
            x: startX + shakeX,
            y: startY + shakeY
        )

        // Scale: 0.86 → 1.0 → 0.9
        let scale: CGFloat
        if t < 0.2 {
            scale = 0.86 + (1.0 - 0.86) * (e / 0.2)
        } else if t < 0.5 {
            scale = 1.0
        } else {
            scale = 1.0 - (1.0 - 0.9) * ((t - 0.5) / 0.5)
        }
        layer.transform = CATransform3DMakeScale(scale, scale, 1)

        // Opacity: fade out in second half
        if t > 0.5 {
            layer.opacity = startOpacity * Float(1.0 - (t - 0.5) / 0.5)
        }

        if t >= 1.0 { finished = true }
    }
}

// ═══════════════════════════════════════════════════════════════
// KeyRecord
// ═══════════════════════════════════════════════════════════════

class KeyRecord: AnimatableRecord {
    let layer: CALayer
    let startX: CGFloat
    let startY: CGFloat
    let endY: CGFloat
    let startOpacity: Float
    let duration: CFTimeInterval
    let startDelay: CFTimeInterval
    let easing: String
    let animationStyle: String
    let gravity: Double
    let fontSize: CGFloat
    var elapsed: CFTimeInterval = 0
    var finished = false

    init(layer: CALayer,
         startX: CGFloat, startY: CGFloat, endY: CGFloat,
         startOpacity: Float,
         duration: CFTimeInterval,
         easing: String,
         animationStyle: String,
         gravity: Double = 0.3,
         fontSize: CGFloat = 48,
         startDelay: CFTimeInterval = 0)
    {
        self.layer = layer
        self.startX = startX; self.startY = startY; self.endY = endY
        self.startOpacity = startOpacity
        self.duration = duration
        self.easing = easing
        self.animationStyle = animationStyle
        self.gravity = gravity
        self.fontSize = fontSize
        self.startDelay = startDelay
        layer.actions = ["position": NSNull(), "opacity": NSNull(), "transform": NSNull()]
    }

    func advance(by dt: CFTimeInterval) {
        elapsed += dt
        let effective = elapsed - startDelay
        guard effective > 0 else { return }
        let t = min(effective / duration, 1.0)
        let e = CGFloat(ease(easing, t))

        switch animationStyle {
        case "raindrop":
            let gravityE = e + (1 - e) * CGFloat(gravity) * (1 - t)
            layer.position = CGPoint(
                x: startX,
                y: startY - (startY - endY) * gravityE
            )
            if t < 0.2 {
                layer.opacity = startOpacity * Float(t / 0.2)
            } else if t > 0.7 {
                layer.opacity = startOpacity * Float((1.0 - t) / 0.3)
            } else {
                layer.opacity = startOpacity
            }
            let wobble = sin(t * .pi * 3) * 3.0 * (1 - t)
            var pos = layer.position
            pos.x += wobble
            layer.position = pos

        default: // bounce
            layer.position = CGPoint(
                x: startX,
                y: endY + (startY - endY) * (1 - e)
            )
            let scale: CGFloat
            if e < 0.7 {
                scale = 0.3 + (1.15 - 0.3) * (e / 0.7)
            } else {
                scale = 1.15 - (1.15 - 1.0) * ((e - 0.7) / 0.3)
            }
            layer.transform = CATransform3DMakeScale(scale, scale, 1)
            if t < 0.1 {
                layer.opacity = startOpacity * Float(t / 0.1)
            } else if t > 0.8 {
                layer.opacity = startOpacity * Float((1.0 - t) / 0.2)
            } else {
                layer.opacity = startOpacity
            }
        }

        if t >= 1.0 { finished = true }
    }
}

// ═══════════════════════════════════════════════════════════════
// AnimationDriver — DispatchSourceTimer-backed manual animation engine
// Uses GCD timer (not RunLoop Timer) so animation fires reliably
// even when the process is backgrounded (behind full-screen app).
// ═══════════════════════════════════════════════════════════════

class AnimationDriver {
    private var sourceTimer: DispatchSourceTimer?
    private var lastTimestamp: CFTimeInterval = 0

    private var records: [AnimatableRecord] = []

    var isRunning: Bool { sourceTimer != nil }

    deinit {
        stop()
    }

    func start() {
        guard !isRunning else { return }
        lastTimestamp = 0
        let timer = DispatchSource.makeTimerSource(queue: .main)
        timer.schedule(deadline: .now(), repeating: .milliseconds(16), leeway: .milliseconds(1))
        timer.setEventHandler { [weak self] in
            let now = CACurrentMediaTime()
            let dt = (self?.lastTimestamp ?? 0) > 0 ? now - (self?.lastTimestamp ?? now) : 0
            self?.lastTimestamp = now
            self?.advance(by: dt)
        }
        timer.resume()
        sourceTimer = timer
    }

    func stop() {
        sourceTimer?.cancel()
        sourceTimer = nil
        lastTimestamp = 0
    }

    func clear() {
        for r in records { r.layer.removeFromSuperlayer() }
        records.removeAll()
    }

    func add(_ record: AnimatableRecord) {
        records.append(record)
    }

    /// Update all records and clean up finished ones.
    func advance(by dt: CFTimeInterval) {
        for r in records { r.advance(by: dt) }
        records.removeAll { r in
            if r.finished { r.layer.removeFromSuperlayer(); return true }
            return false
        }
    }
}
