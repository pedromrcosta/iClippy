import SwiftUI
import AppKit

/// View model for settings
class SettingsViewModel: ObservableObject {
    @Published var currentShortcut: String
    private let settingsManager = SettingsManager.shared
    private let dbManager: DBManager
    private var onShortcutChanged: (() -> Void)?
    
    init(dbManager: DBManager, onShortcutChanged: (() -> Void)? = nil) {
        self.dbManager = dbManager
        self.onShortcutChanged = onShortcutChanged
        self.currentShortcut = settingsManager.getHotKeyDescription()
    }
    
    func clearHistory() {
        print("[DEBUG] Settings: User requested to clear history")
        dbManager.clearAll()
    }
    
    func resetShortcutToDefault() {
        print("[DEBUG] Settings: Resetting shortcut to default")
        settingsManager.resetToDefaults()
        currentShortcut = settingsManager.getHotKeyDescription()
        onShortcutChanged?()
    }
}

/// SwiftUI view for application settings
struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingClearConfirmation = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            Text("Settings")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)
            
            Divider()
            
            // Shortcut section
            VStack(alignment: .leading, spacing: 10) {
                Text("Keyboard Shortcut")
                    .font(.headline)
                
                HStack {
                    Text("Current shortcut:")
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(viewModel.currentShortcut)
                        .font(.system(.body, design: .monospaced))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(NSColor.controlBackgroundColor))
                        .cornerRadius(4)
                }
                
                Text("Opens clipboard history window")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Button("Reset to Default (⌥V)") {
                    viewModel.resetShortcutToDefault()
                }
                .buttonStyle(.bordered)
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
            .cornerRadius(8)
            
            // History section
            VStack(alignment: .leading, spacing: 10) {
                Text("Clipboard History")
                    .font(.headline)
                
                Text("Clear all stored clipboard entries from the database")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Button("Clear History") {
                    showingClearConfirmation = true
                }
                .buttonStyle(.bordered)
                .foregroundColor(.red)
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
            .cornerRadius(8)
            
            Spacer()
            
            // Close button
            Button("Close") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .padding(.bottom)
        }
        .padding()
        .frame(width: 400, height: 350)
        .alert("Clear History", isPresented: $showingClearConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Clear All", role: .destructive) {
                viewModel.clearHistory()
            }
        } message: {
            Text("Are you sure you want to clear all clipboard history? This action cannot be undone.")
        }
    }
}
