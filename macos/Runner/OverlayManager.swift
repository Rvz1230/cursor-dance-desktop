import Cocoa
import FlutterMacOS

class OverlayManager {
    private var overlayWindow: NSWindow?
    private var eventMonitor: Any?
    private var channel: FlutterMethodChannel?

    private var color: Int = 0xFFFF8C00
    private var size: Double = 12
    private var speed: Double = 5

    func setup(messenger: FlutterBinaryMessenger) {
        channel = FlutterMethodChannel(
            name: "cursor_dance/overlay",
            binaryMessenger: messenger
        )
        channel?.setMethodCallHandler { [weak self] call, result in
            switch call.method {
            case "startOverlay":
                if let args = call.arguments as? [String: Any] {
                    self?.applyArgs(args)
                }
                self?.start()
                result(nil)
            case "stopOverlay":
                self?.stop()
                result(nil)
            case "updateConfig":
                if let args = call.arguments as? [String: Any] {
                    self?.applyArgs(args)
                }
                result(nil)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }

    private func applyArgs(_ args: [String: Any]) {
        if let v = args["color"] as? Int { color = v }
        if let v = args["size"] as? Double { size = v }
        if let v = args["speed"] as? Double { speed = v }
    }

    private func start() {
        guard overlayWindow == nil else { return }
        guard let screen = NSScreen.main else { return }
        let frame = screen.frame

        let window = NSWindow(
            contentRect: frame,
            styleMask: .borderless,
            backing: .buffered,
            defer: false
        )
        window.level = .floating
        window.isOpaque = false
        window.backgroundColor = .clear
        window.ignoresMouseEvents = true
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]

        let view = NSView(frame: frame)
        view.wantsLayer = true
        window.contentView = view
        window.orderFront(nil)

        overlayWindow = window

        eventMonitor = NSEvent.addGlobalMonitorForEvents(
            matching: .leftMouseDown
        ) { [weak self] _ in
            self?.handleClick()
        }
    }

    private func stop() {
        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
            eventMonitor = nil
        }
        overlayWindow?.contentView?.layer?.sublayers?.forEach { $0.removeFromSuperlayer() }
        overlayWindow?.orderOut(nil)
        overlayWindow = nil
    }

    private func handleClick() {
        let point = NSEvent.mouseLocation
        spawnParticles(at: point)
    }

    private func spawnParticles(at point: NSPoint) {
        guard let contentView = overlayWindow?.contentView,
              let layer = contentView.layer else { return }

        let count = 12 + Int.random(in: 0...8)
        let baseSpeed = speed * 120
        let duration = max(0.3, 2.5 - (speed - 1) * 0.25)

        for _ in 0..<count {
            let angle = Double.random(in: 0...(2 * .pi))
            let particleSpeed = baseSpeed * Double.random(in: 0.4...1.0)
            let radius = size * Double.random(in: 0.4...1.0)

            let circle = CAShapeLayer()
            circle.path = CGPath(
                ellipseIn: CGRect(
                    x: -radius / 2, y: -radius / 2,
                    width: radius, height: radius
                ),
                transform: nil
            )
            circle.fillColor = argbToNSColor(color).cgColor
            circle.position = point
            circle.opacity = 1.0

            layer.addSublayer(circle)

            let dx = cos(angle) * particleSpeed
            let dy = sin(angle) * particleSpeed

            let moveX = CABasicAnimation(keyPath: "position.x")
            moveX.byValue = dx
            moveX.duration = duration

            let moveY = CABasicAnimation(keyPath: "position.y")
            moveY.byValue = dy
            moveY.duration = duration

            let fadeOut = CABasicAnimation(keyPath: "opacity")
            fadeOut.fromValue = 1.0
            fadeOut.toValue = 0.0
            fadeOut.duration = duration

            let group = CAAnimationGroup()
            group.animations = [moveX, moveY, fadeOut]
            group.duration = duration
            group.fillMode = .forwards
            group.isRemovedOnCompletion = false

            circle.add(group, forKey: "burst")

            DispatchQueue.main.asyncAfter(deadline: .now() + duration + 0.05) {
                circle.removeFromSuperlayer()
            }
        }
    }

    private func argbToNSColor(_ argb: Int) -> NSColor {
        let a = CGFloat((argb >> 24) & 0xFF) / 255.0
        let r = CGFloat((argb >> 16) & 0xFF) / 255.0
        let g = CGFloat((argb >> 8) & 0xFF) / 255.0
        let b = CGFloat(argb & 0xFF) / 255.0
        return NSColor(red: r, green: g, blue: b, alpha: a)
    }
}
