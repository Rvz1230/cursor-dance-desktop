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

    }
}

/// Wrapper for decoding the full actions payload from Flutter.
struct ActionsPayload: Decodable {
    let actions: [String: ActionConfig.ConfigData]
}

// MARK: - KeyFeedbackConfigData (decoded from Flutter JSON)

struct KeyFeedbackConfigData: Decodable {
    let enabled: Bool?
    let animationStyle: String?
    let originEdge: String?
    let originMapping: String?
    let globalOffsetX: Double?
    let globalOffsetY: Double?
    let fontSize: Int?
    let fontWeight: String?
    let fontFamily: String?
    let color: String?
    let opacity: Int?
    let uppercase: Bool?
    let duration: Int?
    let easing: String?
    let scale: Double?
    let bounceHeight: Int?
    let gravity: Double?
    let wind: Double?
    let glow: Bool?
    let glowColor: String?
    let glowRadius: Double?
    let trail: Bool?
    let trailLength: Int?
    let splash: Bool?
    let cooldownMs: Int?
    let maxSimultaneous: Int?
    let delay: Int?
}

// MARK: - Color helpers

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
    private var leftDownMonitor: Any?
    private var leftUpMonitor: Any?
    private var rightDownMonitor: Any?
    private var keyEventMonitor: Any?
    private var channel: FlutterMethodChannel?
    private var spaceObserver: Any?

    private let renderer = EffectsRenderer()
    private let keyFeedbackFX = OverlayKeyFeedbackFX()

    /// Per-action configs keyed by actionId (e.g. "leftClick", "rightClick", "doubleClick").
    private var actionConfigs: [String: ActionConfig.ConfigData] = [:]
    private var keyFeedbackConfig: KeyFeedbackConfigData?
    /// Per-action combo counters for text feedback
    private var comboCounters: [String: Int] = [:]
    private let comboLock = NSLock()
    /// Cooldown tracker for keyboard feedback
    private var lastKeyPressTime: CFTimeInterval = 0
    /// Timestamp of last left-mouse-down for long-press detection
    private var lastLeftDownTime: CFTimeInterval = 0

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
                self?.applyAllArgs(call.arguments)
                self?.start()
                result(nil)
            case "stopOverlay":
                self?.stop()
                result(nil)
            case "updateConfig":
                // Legacy single-action update — merge into actionConfigs
                self?.applySingleArgs(call.arguments)
                result(nil)
            case "updateAllConfigs":
                self?.applyAllArgs(call.arguments)
                result(nil)
            case "updateKeyFeedbackConfig":
                self?.applyKeyFeedbackArgs(call.arguments)
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

    // MARK: - Config deserialization

    private func applyAllArgs(_ args: Any?) {
        guard let dict = args as? [String: Any],
              let jsonString = dict["config"] as? String,
              let data = jsonString.data(using: .utf8) else { return }
        guard let payload = try? JSONDecoder().decode(ActionsPayload.self, from: data) else { return }
        actionConfigs = payload.actions
    }

    private func applySingleArgs(_ args: Any?) {
        guard let dict = args as? [String: Any],
              let jsonString = dict["config"] as? String,
              let data = jsonString.data(using: .utf8) else { return }
        guard let config = try? JSONDecoder().decode(ActionConfig.self, from: data) else { return }
        actionConfigs[config.actionId] = config.config
    }

    private func applyKeyFeedbackArgs(_ args: Any?) {
        guard let dict = args as? [String: Any],
              let jsonString = dict["config"] as? String,
              let data = jsonString.data(using: .utf8) else { return }
        keyFeedbackConfig = try? JSONDecoder().decode(KeyFeedbackConfigData.self, from: data)
    }

    // MARK: - Overlay lifecycle

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

        // Left click (with double-click detection)
        leftDownMonitor = NSEvent.addGlobalMonitorForEvents(
            matching: .leftMouseDown
        ) { [weak self] event in
            self?.handleLeftDown(event)
        }

        // Left mouse up (for long-press detection future use)
        leftUpMonitor = NSEvent.addGlobalMonitorForEvents(
            matching: .leftMouseUp
        ) { [weak self] _ in
            self?.lastLeftDownTime = 0
        }

        // Right click
        rightDownMonitor = NSEvent.addGlobalMonitorForEvents(
            matching: .rightMouseDown
        ) { [weak self] _ in
            self?.handleAction("rightClick")
        }

        keyEventMonitor = NSEvent.addGlobalMonitorForEvents(
            matching: .keyDown
        ) { [weak self] event in
            self?.handleKeyPress(event)
        }

        channel?.invokeMethod("overlayStateChanged", arguments: ["enabled": true])
    }

    func stop() {
        comboLock.lock()
        comboCounters.removeAll()
        comboLock.unlock()

        if let monitor = leftDownMonitor {
            NSEvent.removeMonitor(monitor)
            leftDownMonitor = nil
        }
        if let monitor = leftUpMonitor {
            NSEvent.removeMonitor(monitor)
            leftUpMonitor = nil
        }
        if let monitor = rightDownMonitor {
            NSEvent.removeMonitor(monitor)
            rightDownMonitor = nil
        }
        if let monitor = keyEventMonitor {
            NSEvent.removeMonitor(monitor)
            keyEventMonitor = nil
        }

        // Remove all animation layers from overlay
        if let contentView = overlayWindow?.contentView, let layer = contentView.layer {
            layer.sublayers?.removeAll()
        }

        overlayWindow?.orderOut(nil)
        overlayWindow = nil

        channel?.invokeMethod("overlayStateChanged", arguments: ["enabled": false])
    }

    // MARK: - Click handlers

    private func handleLeftDown(_ event: NSEvent) {
        lastLeftDownTime = CACurrentMediaTime()
        if event.clickCount >= 2 {
            handleAction("doubleClick")
        } else {
            handleAction("leftClick")
        }
    }

    private func handleAction(_ actionId: String) {
        let point = NSEvent.mouseLocation
        guard let contentView = overlayWindow?.contentView,
              let layer = contentView.layer,
              let config = actionConfigs[actionId] else { return }

        let localPoint = contentView.convert(point, from: nil)

        // Increment combo counter for this action
        comboLock.lock()
        let runIndex = (comboCounters[actionId] ?? 0) + 1
        comboCounters[actionId] = runIndex
        comboLock.unlock()

        renderer.playClickEffects(at: localPoint, config: config, parent: layer, runIndex: runIndex)
    }

    // MARK: - Key press handler

    private func handleKeyPress(_ event: NSEvent) {
        guard let config = keyFeedbackConfig, config.enabled == true else { return }
        guard let contentView = overlayWindow?.contentView,
              let layer = contentView.layer else { return }

        let keyCode = Int(event.keyCode)

        // Skip modifier-only keys — no visible character to display
        if isModifierKey(keyCode) { return }

        // Use the actual character from the event (respects Shift modifiers).
        // If characters is empty we're in IME composition mode → skip.
        let rawChars = event.characters ?? ""
        let character: String
        if rawChars.isEmpty {
            // Fallback for keys that produce no NSEvent characters (e.g. F1-F12, arrows)
            let fallback = keyDisplayCharacter(keyCode)
            if fallback == "?" { return }  // unmapped key, skip
            character = fallback
        } else {
            // Take only the first grapheme to avoid multi-char sequences from IME
            character = String(rawChars.first!)
        }

        // Cooldown
        let now = CACurrentMediaTime()
        let cooldownSec = Double(config.cooldownMs ?? 50) / 1000.0
        if now - lastKeyPressTime < cooldownSec { return }
        lastKeyPressTime = now

        keyFeedbackFX.spawn(keyCode: keyCode, character: character, config: config, parent: layer)
    }

    private func isModifierKey(_ keyCode: Int) -> Bool {
        switch keyCode {
        case 0x38, 0x3C,       // Left/Right Shift
             0x3B, 0x3E,       // Left/Right Control
             0x3A, 0x3D,       // Left/Right Option
             0x37, 0x36,       // Left/Right Command
             0x3F,             // Function (fn)
             0x39:             // Caps Lock
            return true
        default:
            return false
        }
    }
}
