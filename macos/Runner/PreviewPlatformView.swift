import Cocoa
import FlutterMacOS

// MARK: - PreviewRenderer

/// NSView that hosts preview effects. Transparent background,
/// receives trigger commands via MethodChannel set up by the factory.
/// Uses AnimationDriver for manual frame-driven animation on every NSView layout.
class PreviewRenderer: NSView {
    private let particleFX = OverlayParticleFX()
    private let textFX = OverlayTextFX()
    private let rippleFX = OverlayRippleFX()
    private let cursorFX = OverlayCursorFX()
    private let driver = AnimationDriver()

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.clear.cgColor
        driver.start()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.clear.cgColor
        driver.start()
    }

    deinit {
        driver.stop()
    }

    /// Trigger effects at the given point (in view coordinates).
    /// point.y comes from Flutter (top-left origin), convert to NSView (bottom-left).
    func trigger(at point: NSPoint, config: ActionConfig.ConfigData, runIndex: Int = 1) {
        guard let layer = self.layer else { return }
        let adjusted = NSPoint(x: point.x, y: bounds.height - point.y)

        if config.textEnabled == true {
            textFX.spawn(at: adjusted, config: config, parent: layer, driver: driver, runIndex: runIndex)
        }
        if config.particle == true {
            particleFX.spawn(at: adjusted, config: config, parent: layer, driver: driver)
        }
        if config.ripple == true {
            rippleFX.spawn(at: adjusted, config: config, parent: layer, driver: driver)
        }
        cursorFX.spawn(at: adjusted, config: config, parent: layer, driver: driver)
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
                let runIndex = dict["runIndex"] as? Int ?? 1
                renderer.trigger(at: NSPoint(x: x, y: y), config: configData, runIndex: runIndex)
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
