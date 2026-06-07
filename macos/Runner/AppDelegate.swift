import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  var overlayManager: OverlayManager?
  private var statusItem: NSStatusItem?

  override func applicationDidFinishLaunching(_ notification: Notification) {
    super.applicationDidFinishLaunching(notification)
    setupStatusItem()
  }

  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return false
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }

  override func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
    mainFlutterWindow?.makeKeyAndOrderFront(nil)
    return true
  }

  private func setupStatusItem() {
    statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    guard let button = statusItem?.button else { return }

    if let symbolImage = NSImage(systemSymbolName: "cursorarrow.click.2", accessibilityDescription: "CursorDance") {
      symbolImage.isTemplate = true
      button.image = symbolImage
    } else {
      let dot = NSImage(size: NSSize(width: 16, height: 16))
      dot.lockFocus()
      NSColor.controlTextColor.set()
      let dotRect = NSRect(x: 5, y: 5, width: 6, height: 6)
      NSBezierPath(ovalIn: dotRect).fill()
      dot.unlockFocus()
      dot.isTemplate = true
      button.image = dot
    }

    let menu = NSMenu()
    menu.delegate = self
    statusItem?.menu = menu
  }

  @objc private func showWindowAction(_ sender: NSMenuItem) {
    NSApp.activate(ignoringOtherApps: true)
    mainFlutterWindow?.makeKeyAndOrderFront(nil)
  }

  @objc private func toggleOverlayAction(_ sender: NSMenuItem) {
    if overlayManager?.isRunning == true {
      overlayManager?.stop()
    } else {
      overlayManager?.start()
    }
  }

  @objc private func quitAction(_ sender: NSMenuItem) {
    NSApplication.shared.terminate(nil)
  }
}

extension AppDelegate: NSMenuDelegate {
  func menuWillOpen(_ menu: NSMenu) {
    menu.removeAllItems()

    menu.addItem(withTitle: "显示窗口", action: #selector(showWindowAction), keyEquivalent: "")
    menu.addItem(NSMenuItem.separator())

    let toggleTitle = overlayManager?.isRunning == true ? "停用动效" : "启用动效"
    menu.addItem(withTitle: toggleTitle, action: #selector(toggleOverlayAction), keyEquivalent: "")
    menu.addItem(NSMenuItem.separator())

    menu.addItem(withTitle: "退出", action: #selector(quitAction), keyEquivalent: "q")
  }
}
