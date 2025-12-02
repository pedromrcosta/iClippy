import AppKit
import SwiftUI

/// Manages the menu bar status item and its menu
class StatusBarManager {
    private var statusItem: NSStatusItem?
    private let dbManager: DBManager
    private var settingsWindow: NSWindow?
    private var onShowHistory: (() -> Void)?
    private var onShortcutChanged: (() -> Void)?
    
    init(dbManager: DBManager, onShowHistory: (() -> Void)? = nil, onShortcutChanged: (() -> Void)? = nil) {
        self.dbManager = dbManager
        self.onShowHistory = onShowHistory
        self.onShortcutChanged = onShortcutChanged
    }
    
    /// Create and configure the status bar item
    func setupStatusBar() {
        print("[DEBUG] Setting up status bar icon")
        
        // Create status item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        guard let statusItem = statusItem else {
            print("[DEBUG] Failed to create status item")
            return
        }
        
        // Configure the button
        if let button = statusItem.button {
            // Use SF Symbol for clipboard icon
            button.image = NSImage(systemSymbolName: "doc.on.clipboard", accessibilityDescription: "iClippy")
            button.toolTip = "iClippy - Clipboard History"
        }
        
        // Create menu
        let menu = NSMenu()
        
        // Show History item
        let showHistoryItem = NSMenuItem(
            title: "Show Clipboard History",
            action: #selector(showHistoryClicked),
            keyEquivalent: ""
        )
        showHistoryItem.target = self
        menu.addItem(showHistoryItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Settings item
        let settingsItem = NSMenuItem(
            title: "Settings...",
            action: #selector(showSettings),
            keyEquivalent: ","
        )
        settingsItem.target = self
        menu.addItem(settingsItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Quit item
        let quitItem = NSMenuItem(
            title: "Quit iClippy",
            action: #selector(NSApplication.terminate(_:)),
            keyEquivalent: "q"
        )
        menu.addItem(quitItem)
        
        // Attach menu to status item
        statusItem.menu = menu
        
        print("[DEBUG] Status bar icon created successfully")
    }
    
    @objc private func showHistoryClicked() {
        print("[DEBUG] Status bar: Show History clicked")
        onShowHistory?()
    }
    
    @objc private func showSettings() {
        print("[DEBUG] Status bar: Settings clicked")
        
        // Close existing settings window if open
        if let window = settingsWindow, window.isVisible {
            window.close()
            settingsWindow = nil
            return
        }
        
        // Create settings view model
        let viewModel = SettingsViewModel(dbManager: dbManager) { [weak self] in
            print("[DEBUG] Settings: Shortcut changed, notifying delegate")
            self?.onShortcutChanged?()
        }
        
        // Set up close callback
        viewModel.onClose = { [weak self] in
            self?.settingsWindow?.close()
            self?.settingsWindow = nil
        }
        
        let settingsView = SettingsView(viewModel: viewModel)
        
        // Create hosting view
        let hostingView = NSHostingView(rootView: settingsView)
        
        // Create window
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 350),
            styleMask: [.titled, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        
        window.title = "iClippy Settings"
        window.contentView = hostingView
        window.isReleasedWhenClosed = false
        window.center()
        window.makeKeyAndOrderFront(nil)
        
        // Activate the app to bring window to front
        NSApp.activate(ignoringOtherApps: true)
        
        // Store window reference
        self.settingsWindow = window
    }
    
    /// Remove the status bar item
    func removeStatusBar() {
        if let statusItem = statusItem {
            NSStatusBar.system.removeStatusItem(statusItem)
            self.statusItem = nil
        }
    }
    
    deinit {
        removeStatusBar()
    }
}
