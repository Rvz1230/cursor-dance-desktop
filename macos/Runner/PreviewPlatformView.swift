import Cocoa
import FlutterMacOS

// MARK: - PreviewRenderer

/// NSView that hosts preview effects. Transparent background,
/// receives trigger commands via MethodChannel set up by the factory.
/// Reuses the same OverlayParticleFX / RippleFX / TextFX as the full-screen overlay.
class PreviewRenderer: NSView {
    private let particleFX = OverlayParticleFX()
    private let textFX = OverlayTextFX()
    private let rippleFX = OverlayRippleFX()

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

    /// Trigger effects at the given point (in view coordinates).
    /// point.y comes from Flutter (top-left origin), convert to NSView (bottom-left).
    func trigger(at point: NSPoint, config: ActionConfig.ConfigData) {
        guard let layer = self.layer else { return }
        let adjusted = NSPoint(x: point.x, y: bounds.height - point.y)

        // Same call pattern as OverlayManager.handleClick
        if config.textEnabled == true {
            textFX.spawn(at: adjusted, config: config, parent: layer)
        }
        if config.particle == true {
            particleFX.spawn(at: adjusted, config: config, parent: layer)
        }
        if config.ripple == true {
            rippleFX.spawn(at: adjusted, config: config, parent: layer)
        }
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
            case "trigger":
                guard let dict = call.arguments as? [String: Any],
                      let x = dict["x"] as? Double,
                      let y = dict["y"] as? Double,
                      let configDict = dict["config"] as? [String: Any],
                      let jsonData = try? JSONSerialization.data(withJSONObject: configDict),
                      let configData = try? JSONDecoder().decode(
                        ActionConfig.ConfigData.self, from: jsonData)
                else {
                    result(FlutterError(code: "INVALID_ARGS", message: nil, details: nil))
                    return
                }
                renderer.trigger(at: NSPoint(x: x, y: y), config: configData)
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
