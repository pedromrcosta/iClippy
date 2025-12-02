import SwiftUI

/// Main entry point for the Clippy clipboard history app
@main
struct ClippyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        // Empty scene since we use NSPanel for the history window
        Settings {
            EmptyView()
        }
    }
}
