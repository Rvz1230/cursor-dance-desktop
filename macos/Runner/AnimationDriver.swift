import Cocoa

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

class ParticleRecord {
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

class TextRecord {
    let layer: CATextLayer
    let startX: CGFloat
    let startY: CGFloat
    let offsetX: CGFloat      // horizontal shift
    let floatDistance: CGFloat // upward movement in bottom-left coords
    let startOpacity: Float
    let duration: CFTimeInterval
    let easing: String
    var elapsed: CFTimeInterval = 0
    var finished = false

    init(layer: CATextLayer,
         startX: CGFloat, startY: CGFloat,
         offsetX: CGFloat, floatDistance: CGFloat,
         startOpacity: Float,
         duration: CFTimeInterval,
         easing: String)
    {
        self.layer = layer
        self.startX = startX; self.startY = startY
        self.offsetX = offsetX
        self.floatDistance = floatDistance
        self.startOpacity = startOpacity
        self.duration = duration
        self.easing = easing
        layer.actions = ["position": NSNull(), "opacity": NSNull()]
    }

    func advance(by dt: CFTimeInterval) {
        elapsed += dt
        let t = min(elapsed / duration, 1.0)
        let e = CGFloat(ease(easing, t))

        layer.position = CGPoint(
            x: startX + offsetX * e,
            y: startY + floatDistance * e
        )
        layer.opacity = startOpacity * Float(1.0 - t)

        if t >= 1.0 { finished = true }
    }
}

class RippleRecord {
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

// ═══════════════════════════════════════════════════════════════
// AnimationDriver — CADisplayLink-backed manual animation engine
// ═══════════════════════════════════════════════════════════════

class AnimationDriver {
    private var displayLink: CADisplayLink?
    private var lastTimestamp: CFTimeInterval = 0

    private var particles: [ParticleRecord] = []
    private var texts: [TextRecord] = []
    private var ripples: [RippleRecord] = []

    var isRunning: Bool { displayLink != nil }

    deinit {
        stop()
    }

    func start() {
        guard !isRunning else { return }
        displayLink = CADisplayLink(target: self, selector: #selector(tick))
        displayLink?.add(to: .main, forMode: .common)
        lastTimestamp = 0
    }

    func stop() {
        displayLink?.invalidate()
        displayLink = nil
        lastTimestamp = 0
    }

    func clear() {
        for p in particles { p.layer.removeFromSuperlayer() }
        for t in texts { t.layer.removeFromSuperlayer() }
        for r in ripples { r.layer.removeFromSuperlayer() }
        particles.removeAll()
        texts.removeAll()
        ripples.removeAll()
    }

    func addParticle(_ record: ParticleRecord) { particles.append(record) }
    func addText(_ record: TextRecord) { texts.append(record) }
    func addRipple(_ record: RippleRecord) { ripples.append(record) }

    @objc private func tick(_ link: CADisplayLink) {
        // First frame: skip with dt=0 so first frame renders at t=0
        let dt = lastTimestamp > 0 ? link.timestamp - lastTimestamp : 0
        lastTimestamp = link.timestamp
        advance(by: dt)
    }

    /// Update all records and clean up finished ones.
    /// Public so both caller can drive manually or via display link.
    func advance(by dt: CFTimeInterval) {
        // Advance all
        for p in particles { p.advance(by: dt) }
        for t in texts { t.advance(by: dt) }
        for r in ripples { r.advance(by: dt) }

        // Clean finished (remove from superlayer, remove from array)
        for p in particles where p.finished { p.layer.removeFromSuperlayer() }
        particles.removeAll { $0.finished }

        for t in texts where t.finished { t.layer.removeFromSuperlayer() }
        texts.removeAll { $0.finished }

        for r in ripples where r.finished { r.layer.removeFromSuperlayer() }
        ripples.removeAll { $0.finished }
    }
}
