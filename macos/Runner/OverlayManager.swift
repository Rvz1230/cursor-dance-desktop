import Cocoa
import FlutterMacOS

// MARK: - ActionConfig (decoded from Flutter JSON)

struct ActionConfig: Decodable {
    let actionId: String
    let config: ConfigData

    struct ConfigData: Decodable {
        // Trigger
        let triggerTiming: String?
        let holdMs: Int?

        // Text
        let textEnabled: Bool?
        let textKind: String?
        let textContent: String?
        let textColor: String?
        let fontSize: Int?
        let textDuration: Int?
        let textEasing: String?
        let textOpacity: Int?
        let textOffsetX: Int?
        let textOffsetY: Int?
        let textFontFamily: String?
        let textWeight: String?
        let textOutlineWidth: Int?
        let textShadow: String?

        // Particle
        let particle: Bool?
        let particleCount: Int?
        let particleStyle: String?
        let particleSize: Int?
        let particleDuration: Int?
        let particlePalette: [String]?
        let particleGravity: Int?
        let particleWind: Int?
        let particleBounce: Int?
        let particleOpacity: Int?
        let particleDirection: String?
        let particleSpread: Int?
        let particleMotionMode: String?
        let orbitalCount: Int?
        let orbitalRadius: Int?
        let orbitalSpeed: Int?
        let particleTrail: Bool?
        let particleColorMode: String?
        let particleDelay: Int?

        // Ripple
        let ripple: Bool?
        let rippleSize: Int?
        let rippleDuration: Int?
        let rippleStyle: String?
        let rippleEasing: String?
        let rippleOpacity: Int?
        let rippleLineWidth: Int?
        let rippleColor: String?
        let rippleDelay: Int?

        // Animation
        let animationEnabled: Bool?
        let animationStyle: String?
        let animationDuration: Int?

        // Cursor
        let cursorOverride: String?
        let cursorTrailEnabled: Bool?
        let cursorGlowColor: String?
        let shake: Int?
    }
}

// MARK: - Easing mapping

func timingFunction(from easing: String?) -> CAMediaTimingFunction {
    switch easing {
    case "线性": return CAMediaTimingFunction(name: .linear)
    case "缓入": return CAMediaTimingFunction(name: .easeIn)
    case "缓出": return CAMediaTimingFunction(name: .easeOut)
    case "缓入缓出": return CAMediaTimingFunction(name: .easeInEaseOut)
    case "弹跳": return CAMediaTimingFunction(controlPoints: 0.34, 1.56, 0.64, 1)
    case "弹性": return CAMediaTimingFunction(controlPoints: 0.22, 1, 0.36, 1.18)
    default: return CAMediaTimingFunction(name: .easeOut)
    }
}

func hexColor(_ hex: String?) -> NSColor {
    guard let hex = hex, !hex.isEmpty else { return NSColor.orange }
    let sanitized = hex.replacingOccurrences(of: "#", with: "")
    guard sanitized.count == 6, let intVal = Int(sanitized, radix: 16) else { return NSColor.orange }
    let r = CGFloat((intVal >> 16) & 0xFF) / 255.0
    let g = CGFloat((intVal >> 8) & 0xFF) / 255.0
    let b = CGFloat(intVal & 0xFF) / 255.0
    return NSColor(red: r, green: g, blue: b, alpha: 1)
}

// MARK: - OverlayManager

class OverlayManager {
    private var overlayWindow: NSWindow?
    private var eventMonitor: Any?
    private var channel: FlutterMethodChannel?
    private var spaceObserver: Any?

    private let particleFX = OverlayParticleFX()
    private let textFX = OverlayTextFX()
    private let rippleFX = OverlayRippleFX()

    private var currentConfig: ActionConfig?

    var isRunning: Bool { overlayWindow != nil }

    deinit {
        if let observer = spaceObserver {
            NSWorkspace.shared.notificationCenter.removeObserver(observer)
        }
    }

    func setup(messenger: FlutterBinaryMessenger) {
        channel = FlutterMethodChannel(
            name: "cursor_dance/overlay",
            binaryMessenger: messenger
        )
        channel?.setMethodCallHandler { [weak self] call, result in
            switch call.method {
            case "startOverlay":
                self?.applyArgs(call.arguments)
                self?.start()
                result(nil)
            case "stopOverlay":
                self?.stop()
                result(nil)
            case "updateConfig":
                self?.applyArgs(call.arguments)
                result(nil)
            default:
                result(FlutterMethodNotImplemented)
            }
        }

        // Re-assert overlay on top whenever the active Space changes
        // (covers full-screen transitions of other apps).
        spaceObserver = NSWorkspace.shared.notificationCenter.addObserver(
            forName: NSWorkspace.activeSpaceDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.overlayWindow?.orderFront(nil)
        }
    }

    private func applyArgs(_ args: Any?) {
        guard let dict = args as? [String: Any],
              let jsonString = dict["config"] as? String,
              let data = jsonString.data(using: .utf8) else { return }
        currentConfig = try? JSONDecoder().decode(ActionConfig.self, from: data)
    }

    func start() {
        guard overlayWindow == nil else { return }
        guard let screen = NSScreen.main else { return }
        let frame = screen.frame

        let window = NSPanel(
            contentRect: frame,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        window.level = .screenSaver
        window.isOpaque = false
        window.backgroundColor = .clear
        window.ignoresMouseEvents = true
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        window.hidesOnDeactivate = false

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

        channel?.invokeMethod("overlayStateChanged", arguments: ["enabled": true])
    }

    func stop() {
        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
            eventMonitor = nil
        }
        textFX.clear()
        rippleFX.clear()
        particleFX.clear()
        overlayWindow?.contentView?.layer?.sublayers?.forEach { $0.removeFromSuperlayer() }
        overlayWindow?.orderOut(nil)
        overlayWindow = nil

        channel?.invokeMethod("overlayStateChanged", arguments: ["enabled": false])
    }

    private func handleClick() {
        // Re-assert window front on each click to stay above full-screen apps
        overlayWindow?.orderFront(nil)

        let point = NSEvent.mouseLocation
        guard let contentView = overlayWindow?.contentView,
              let layer = contentView.layer,
              let config = currentConfig else { return }

        let c = config.config
        let localPoint = contentView.convert(point, from: nil)

        if c.textEnabled == true {
            textFX.spawn(at: localPoint, config: c, parent: layer)
        }
        if c.particle == true {
            particleFX.spawn(at: localPoint, config: c, parent: layer)
        }
        if c.ripple == true {
            rippleFX.spawn(at: localPoint, config: c, parent: layer)
        }
    }
}
