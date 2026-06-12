import Cocoa
import FlutterMacOS

// MARK: - PreviewRenderer

/// NSView that hosts preview effects. Transparent background,
/// receives trigger commands via MethodChannel set up by the factory.
/// Uses EffectsRenderer (shared with OverlayManager) for identical rendering.
class PreviewRenderer: NSView {
    private let renderer = EffectsRenderer()
    private var currentConfig: ActionConfig.ConfigData?
    private var comboCounter: Int = 0

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.clear.cgColor
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.clear.cgColor
    }

    /// Store config for subsequent triggers.
    func updateConfig(_ config: ActionConfig.ConfigData) {
        currentConfig = config
        comboCounter = 0
        clearEffects()
    }

    /// Trigger effects at the given point (in Flutter top-left origin).
    func trigger(at point: NSPoint) {
        guard let config = currentConfig,
              let layer = self.layer else { return }
        comboCounter += 1
        let adjusted = NSPoint(x: point.x, y: bounds.height - point.y)
        renderer.playClickEffects(at: adjusted, config: config, parent: layer, runIndex: comboCounter)
    }

    /// Clear all active effects.
    func clearEffects() {
        layer?.sublayers?.removeAll()
        comboCounter = 0
    }
}

// MARK: - PreviewPlatformViewFactory

class PreviewPlatformViewFactory: NSObject, FlutterPlatformViewFactory {
    private let messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(withViewIdentifier viewId: Int64, arguments args: Any?) -> NSView {
        let renderer = PreviewRenderer()
        let channel = FlutterMethodChannel(
            name: "cursor_dance/preview_\(viewId)",
            binaryMessenger: messenger
        )

        channel.setMethodCallHandler { call, result in
            switch call.method {
            case "updateConfig":
                if let dict = call.arguments as? [String: Any] {
                    // Try JSON string format first (matches overlay channel)
                    if let jsonString = dict["config"] as? String,
                       let data = jsonString.data(using: .utf8),
                       let actionConfig = try? JSONDecoder().decode(ActionConfig.self, from: data) {
                        renderer.updateConfig(actionConfig.config)
                        result(nil)
                        return
                    }
                    // Fallback: raw map format (legacy)
                    if let configDict = dict["config"] as? [String: Any],
                       let jsonData = try? JSONSerialization.data(withJSONObject: configDict),
                       let configData = try? JSONDecoder().decode(
                        ActionConfig.ConfigData.self, from: jsonData) {
                        renderer.updateConfig(configData)
                        result(nil)
                        return
                    }
                }
                result(FlutterError(code: "INVALID_ARGS", message: nil, details: nil))

            case "trigger":
                guard let dict = call.arguments as? [String: Any],
                      let x = dict["x"] as? Double,
                      let y = dict["y"] as? Double
                else {
                    result(FlutterError(code: "INVALID_ARGS", message: nil, details: nil))
                    return
                }
                renderer.trigger(at: NSPoint(x: x, y: y))
                result(nil)

            case "clear":
                renderer.clearEffects()
                result(nil)

            default:
                result(FlutterMethodNotImplemented)
            }
        }

        return renderer
    }

    func createArgsCodec() -> (any FlutterMessageCodec & NSObjectProtocol)? {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}
