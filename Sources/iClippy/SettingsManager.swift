import Foundation

/// Manages application settings stored in UserDefaults
class SettingsManager {
    static let shared = SettingsManager()
    
    private let defaults = UserDefaults.standard
    
    // Keys for UserDefaults
    private enum Keys {
        static let hotKeyCode = "hotKeyCode"
        static let hotKeyModifiers = "hotKeyModifiers"
    }
    
    // Default values
    private enum Defaults {
        static let vKeyCode: UInt32 = 9 // 'V' key
        static let optionKeyModifier: UInt32 = 0x0800 // optionKey modifier
    }
    
    // Modifier key masks (Carbon API values)
    private enum ModifierMasks {
        static let cmdKey: UInt32 = 0x0100
        static let shiftKey: UInt32 = 0x0200
        static let optionKey: UInt32 = 0x0800
        static let controlKey: UInt32 = 0x1000
    }
    
    private init() {}
    
    /// Get the current hotkey code (default: 'V' key)
    var hotKeyCode: UInt32 {
        get {
            let value = defaults.object(forKey: Keys.hotKeyCode) as? UInt32
            return value ?? Defaults.vKeyCode
        }
        set {
            print("[DEBUG] Settings: Changing hotkey code to \(newValue)")
            defaults.set(newValue, forKey: Keys.hotKeyCode)
        }
    }
    
    /// Get the current hotkey modifiers (default: Option key)
    var hotKeyModifiers: UInt32 {
        get {
            let value = defaults.object(forKey: Keys.hotKeyModifiers) as? UInt32
            return value ?? Defaults.optionKeyModifier
        }
        set {
            print("[DEBUG] Settings: Changing hotkey modifiers to \(newValue)")
            defaults.set(newValue, forKey: Keys.hotKeyModifiers)
        }
    }
    
    /// Reset settings to default values
    func resetToDefaults() {
        print("[DEBUG] Settings: Resetting to defaults")
        defaults.removeObject(forKey: Keys.hotKeyCode)
        defaults.removeObject(forKey: Keys.hotKeyModifiers)
    }
    
    /// Get a human-readable description of the current hotkey
    func getHotKeyDescription() -> String {
        var modifierStrings: [String] = []
        
        let mods = hotKeyModifiers
        if mods & ModifierMasks.cmdKey != 0 { modifierStrings.append("⌘") }
        if mods & ModifierMasks.shiftKey != 0 { modifierStrings.append("⇧") }
        if mods & ModifierMasks.optionKey != 0 { modifierStrings.append("⌥") }
        if mods & ModifierMasks.controlKey != 0 { modifierStrings.append("⌃") }
        
        let keyChar = getKeyCharacter(for: hotKeyCode)
        return modifierStrings.joined() + keyChar
    }
    
    private func getKeyCharacter(for keyCode: UInt32) -> String {
        // Map common key codes to their characters
        switch keyCode {
        case 0: return "A"
        case 1: return "S"
        case 2: return "D"
        case 3: return "F"
        case 4: return "H"
        case 5: return "G"
        case 6: return "Z"
        case 7: return "X"
        case 8: return "C"
        case 9: return "V"
        case 11: return "B"
        case 12: return "Q"
        case 13: return "W"
        case 14: return "E"
        case 15: return "R"
        case 16: return "Y"
        case 17: return "T"
        case 31: return "O"
        case 32: return "U"
        case 34: return "I"
        case 35: return "P"
        case 37: return "L"
        case 38: return "J"
        case 40: return "K"
        case 45: return "N"
        case 46: return "M"
        case 36: return "↩︎" // Return
        case 49: return "Space"
        case 51: return "⌫" // Delete
        case 53: return "⎋" // Escape
        default: return "[\(keyCode)]"
        }
    }
}
