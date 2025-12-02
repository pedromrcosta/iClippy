import XCTest
@testable import iClippy

final class SettingsManagerTests: XCTestCase {
    var settingsManager: SettingsManager!
    
    override func setUp() {
        super.setUp()
        settingsManager = SettingsManager.shared
        // Reset to defaults before each test
        settingsManager.resetToDefaults()
    }
    
    override func tearDown() {
        // Clean up after each test
        settingsManager.resetToDefaults()
        super.tearDown()
    }
    
    func testDefaultHotKeyCode() {
        // Default should be 9 (V key)
        XCTAssertEqual(settingsManager.hotKeyCode, 9)
    }
    
    func testDefaultHotKeyModifiers() {
        // Default should be optionKey (0x0800)
        XCTAssertEqual(settingsManager.hotKeyModifiers, 0x0800)
    }
    
    func testSetHotKeyCode() {
        // Change hotkey code
        settingsManager.hotKeyCode = 8 // C key
        XCTAssertEqual(settingsManager.hotKeyCode, 8)
        
        // Verify it persists
        let newManager = SettingsManager.shared
        XCTAssertEqual(newManager.hotKeyCode, 8)
    }
    
    func testSetHotKeyModifiers() {
        // Change modifiers to command key
        settingsManager.hotKeyModifiers = 0x0100 // cmdKey
        XCTAssertEqual(settingsManager.hotKeyModifiers, 0x0100)
        
        // Verify it persists
        let newManager = SettingsManager.shared
        XCTAssertEqual(newManager.hotKeyModifiers, 0x0100)
    }
    
    func testResetToDefaults() {
        // Change settings
        settingsManager.hotKeyCode = 8
        settingsManager.hotKeyModifiers = 0x0100
        
        // Reset to defaults
        settingsManager.resetToDefaults()
        
        // Verify defaults are restored
        XCTAssertEqual(settingsManager.hotKeyCode, 9)
        XCTAssertEqual(settingsManager.hotKeyModifiers, 0x0800)
    }
    
    func testGetHotKeyDescription() {
        // Default should be Option+V
        let description = settingsManager.getHotKeyDescription()
        XCTAssertTrue(description.contains("⌥"), "Should contain Option symbol")
        XCTAssertTrue(description.contains("V"), "Should contain V key")
    }
    
    func testGetHotKeyDescriptionWithCommand() {
        // Set to Command+C
        settingsManager.hotKeyCode = 8 // C key
        settingsManager.hotKeyModifiers = 0x0100 // cmdKey
        
        let description = settingsManager.getHotKeyDescription()
        XCTAssertTrue(description.contains("⌘"), "Should contain Command symbol")
        XCTAssertTrue(description.contains("C"), "Should contain C key")
    }
    
    func testGetHotKeyDescriptionWithMultipleModifiers() {
        // Set to Command+Shift+V
        settingsManager.hotKeyCode = 9 // V key
        settingsManager.hotKeyModifiers = 0x0100 | 0x0200 // cmdKey + shiftKey
        
        let description = settingsManager.getHotKeyDescription()
        XCTAssertTrue(description.contains("⌘"), "Should contain Command symbol")
        XCTAssertTrue(description.contains("⇧"), "Should contain Shift symbol")
        XCTAssertTrue(description.contains("V"), "Should contain V key")
    }
    
    func testGetHotKeyDescriptionWithAllModifiers() {
        // Set to Command+Control+Option+Shift+V
        settingsManager.hotKeyCode = 9 // V key
        settingsManager.hotKeyModifiers = 0x0100 | 0x0200 | 0x0800 | 0x1000 // all modifiers
        
        let description = settingsManager.getHotKeyDescription()
        XCTAssertTrue(description.contains("⌘"), "Should contain Command symbol")
        XCTAssertTrue(description.contains("⇧"), "Should contain Shift symbol")
        XCTAssertTrue(description.contains("⌥"), "Should contain Option symbol")
        XCTAssertTrue(description.contains("⌃"), "Should contain Control symbol")
        XCTAssertTrue(description.contains("V"), "Should contain V key")
    }
}
