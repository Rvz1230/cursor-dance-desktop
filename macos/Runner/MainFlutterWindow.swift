import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
    let overlayManager = OverlayManager()

    override func awakeFromNib() {
        let flutterViewController = FlutterViewController()
        let windowFrame = self.frame
        self.contentViewController = flutterViewController
        self.setFrame(windowFrame, display: true)

        RegisterGeneratedPlugins(registry: flutterViewController)

        overlayManager.setup(messenger: flutterViewController.engine.binaryMessenger)

        if let appDelegate = NSApp.delegate as? AppDelegate {
            appDelegate.overlayManager = overlayManager
        }

        super.awakeFromNib()
    }
}
