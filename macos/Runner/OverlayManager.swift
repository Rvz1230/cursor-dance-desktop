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
        let textStyle: String?
        let textMode: String?
        let textTemplate: String?
        let textContent: String?
        let textTags: [String]?
        let textTagPlayMode: String?
        let comboEnabled: Bool?
        let comboWindowMs: Int?
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
        let textGradient: Bool?
        let textGradientStart: String?
        let textGradientEnd: String?
        let textDelay: Int?

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
        let animationEasing: String?
        let animationScale: Int?
        let animationOpacity: Int?
        let animationOffsetX: Int?
        let animationOffsetY: Int?
        let animationColor: String?
        let animationGlow: Bool?
        let animationDelay: Int?

        // Image
        let imageEnabled: Bool?
        let imageDataUrl: String?
        let imageDuration: Int?
        let imageSize: Int?
        let imageOpacity: Int?
        let imageOffsetX: Int?
        let imageOffsetY: Int?
        let imageDelay: Int?

        // Audio
        let sound: Bool?
        let soundFile: String?
        let volume: Int?
        let playbackRate: Int?
        let soundDelay: Int?
        let soundFadeOut: Int?
        let soundTriggerMode: String?
        let soundBlendMode: String?

        // Cursor
        let cursorOverride: String?
        let cursorSize: Int?
        let cursorTrailEnabled: Bool?
        let cursorTrailCount: Int?
        let cursorTrailOpacity: Int?
        let cursorGlowColor: String?
        let shake: Int?
    }
}

// MARK: - Easing mapping — AnimationDriver uses its own ease()

func hexColor(_ hex: String?) -> NSColor {
    guard let hex = hex, !hex.isEmpty else { return NSColor.orange }
    let sanitized = hex.replacingOccurrences(of: "#", with: "")
    switch sanitized.count {
    case 6:
        guard let intVal = Int(sanitized, radix: 16) else { return NSColor.orange }
        let r = CGFloat((intVal >> 16) & 0xFF) / 255.0
        let g = CGFloat((intVal >> 8) & 0xFF) / 255.0
        let b = CGFloat(intVal & 0xFF) / 255.0
        return NSColor(red: r, green: g, blue: b, alpha: 1)
    case 3:
        guard let intVal = Int(sanitized, radix: 16) else { return NSColor.orange }
        let r = CGFloat((intVal >> 8) & 0xF) / 15.0
        let g = CGFloat((intVal >> 4) & 0xF) / 15.0
        let b = CGFloat(intVal & 0xF) / 15.0
        return NSColor(red: r, green: g, blue: b, alpha: 1)
    case 8:
        guard let intVal = Int(sanitized, radix: 16) else { return NSColor.orange }
        let r = CGFloat((intVal >> 24) & 0xFF) / 255.0
        let g = CGFloat((intVal >> 16) & 0xFF) / 255.0
        let b = CGFloat((intVal >> 8) & 0xFF) / 255.0
        let a = CGFloat(intVal & 0xFF) / 255.0
        return NSColor(red: r, green: g, blue: b, alpha: a)
    default:
        return NSColor.orange
    }
}

// MARK: - OverlayManager

class OverlayManager {
    private var overlayWindow: NSWindow?
    private var eventMonitor: Any?
    private var channel: FlutterMethodChannel?
    private var spaceObserver: Any?
    private let driver = AnimationDriver()

    private let particleFX = OverlayParticleFX()
    private let textFX = OverlayTextFX()
    private let rippleFX = OverlayRippleFX()
    private let cursorFX = OverlayCursorFX()
    private let animationFX = OverlayAnimationFX()
    private let imageFX = OverlayImageFX()

    private var currentConfig: ActionConfig?
    /// Per-action combo counters for text feedback
    private var comboCounters: [String: Int] = [:]
    private let comboLock = NSLock()

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

        driver.start()

        eventMonitor = NSEvent.addGlobalMonitorForEvents(
            matching: .leftMouseDown
        ) { [weak self] _ in
            self?.handleClick()
        }

        channel?.invokeMethod("overlayStateChanged", arguments: ["enabled": true])
    }

    func stop() {
        comboLock.lock()
        comboCounters.removeAll()
        comboLock.unlock()

        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
            eventMonitor = nil
        }

        driver.clear()
        driver.stop()

        overlayWindow?.orderOut(nil)
        overlayWindow = nil

        channel?.invokeMethod("overlayStateChanged", arguments: ["enabled": false])
    }

    private func handleClick() {
        let point = NSEvent.mouseLocation
        guard let contentView = overlayWindow?.contentView,
              let layer = contentView.layer,
              let config = currentConfig else { return }

        let c = config.config
        let localPoint = contentView.convert(point, from: nil)

        // Increment combo counter for this action (used by text feedback)
        let actionKey = config.actionId
        comboLock.lock()
        let runIndex = (comboCounters[actionKey] ?? 0) + 1
        comboCounters[actionKey] = runIndex
        comboLock.unlock()

        if c.textEnabled == true {
            textFX.spawn(at: localPoint, config: c, parent: layer, driver: driver, runIndex: runIndex)
        }
        if c.particle == true {
            particleFX.spawn(at: localPoint, config: c, parent: layer, driver: driver)
        }
        if c.ripple == true {
            rippleFX.spawn(at: localPoint, config: c, parent: layer, driver: driver)
        }
        if c.animationEnabled == true {
            animationFX.spawn(at: localPoint, config: c, parent: layer, driver: driver)
        }
        if c.imageEnabled == true {
            imageFX.spawn(at: localPoint, config: c, parent: layer, driver: driver)
        }
        cursorFX.spawn(at: localPoint, config: c, parent: layer, driver: driver)
    }
}

