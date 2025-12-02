import AppKit
import Carbon
import Foundation

/// Manages global hotkey registration (configurable via settings)
class HotKeyManager {
    private var hotKeyRef: EventHotKeyRef?
    private var eventHandler: EventHandlerRef?
    private let settingsManager = SettingsManager.shared
    
    static let showHistoryNotification = Notification.Name("ShowHistoryWindow")
    
    func registerHotKey() {
        // Unregister existing hotkey if any
        unregisterHotKey()
        
        var gMyHotKeyID = EventHotKeyID()
        // Using FourCC for "clip"
        gMyHotKeyID.signature = 0x636C6970 // "clip" in ASCII hex
        gMyHotKeyID.id = 1
        
        // Set up event handler
        var eventType = EventTypeSpec()
        eventType.eventClass = OSType(kEventClassKeyboard)
        eventType.eventKind = OSType(kEventHotKeyPressed)
        
        let callback: EventHandlerUPP = { (nextHandler, theEvent, userData) -> OSStatus in
            NotificationCenter.default.post(name: HotKeyManager.showHistoryNotification, object: nil)
            return noErr
        }
        
        InstallEventHandler(GetApplicationEventTarget(), callback, 1, &eventType, nil, &eventHandler)
        
        // Get hotkey configuration from settings
        let keyCode = settingsManager.hotKeyCode
        let modifiers = settingsManager.hotKeyModifiers
        
        print("[DEBUG] Registering hotkey with code: \(keyCode), modifiers: \(modifiers)")
        RegisterEventHotKey(keyCode, modifiers, gMyHotKeyID, GetApplicationEventTarget(), 0, &hotKeyRef)
    }
    
    func unregisterHotKey() {
        if let hotKeyRef = hotKeyRef {
            UnregisterEventHotKey(hotKeyRef)
        }
        if let eventHandler = eventHandler {
            RemoveEventHandler(eventHandler)
        }
    }
    
    deinit {
        unregisterHotKey()
    }
}
