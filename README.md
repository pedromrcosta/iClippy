# iClippy - macOS Clipboard History

A lightweight macOS clipboard history manager that records text clipboard items into a local SQLite database and provides quick access via a global hotkey.

## Features

- 📋 **Text-Only Recording**: Automatically captures text clipboard items (ignores images, files, etc.)
- 🔍 **Searchable History**: Search through your clipboard history with a simple search interface
- ⚡ **Global Hotkey**: Press `Option+V` (⌥V) anywhere to open the clipboard history window (customizable)
- 🎯 **Menu Bar Access**: Convenient menu bar icon for quick access to history and settings
- ⚙️ **Customizable Shortcut**: Configure your preferred keyboard shortcut in settings
- 🗑️ **Clear History**: Remove all clipboard entries with one click
- 🚫 **No Duplicates**: Each unique text is stored only once
- 💾 **Portable Database**: SQLite database stored in a standard location for easy backup and migration
- 🔒 **Privacy-First**: All data stays local, no analytics or telemetry

## Installation & Building

### Requirements
- macOS 13.0 or later
- Xcode 14.0+ with Swift 5.9+

### Build from Source

#### Option 1: Using Xcode (Recommended)

```bash
# Clone the repository
git clone https://github.com/pedromrcosta/iClippy.git
cd iClippy

# Open the Xcode project
open iClippy.xcodeproj
```

In Xcode:
1. Select the "iClippy" scheme
2. Press `⌘B` to build or `⌘R` to run
3. The app will appear in the menu bar when running

#### Option 2: Using Swift Package Manager (Command Line)

```bash
# Clone the repository
git clone https://github.com/pedromrcosta/iClippy.git
cd iClippy

# Build the app
swift build -c release

# Run the app
.build/release/iClippy
```

## Usage

1. **Start the app**: Launch iClippy - it runs in the background monitoring your clipboard
2. **Menu bar icon**: Look for the clipboard icon (📋) in your menu bar
3. **Copy text**: Copy any text as usual (⌘C) - iClippy automatically records it
4. **View history**: Press `Option+V` (⌥V) or click the menu bar icon and select "Show Clipboard History"
5. **Search**: Type in the search field to filter entries
6. **Restore**: Click any entry to copy it back to your clipboard
7. **Settings**: Click the menu bar icon and select "Settings..." to:
   - View and customize your keyboard shortcut
   - Clear your clipboard history

## Database Location

iClippy stores clipboard history in:
```
~/Library/Application Support/iClippy/iclippy.sqlite3
```

You can backup or copy this file between machines to migrate your clipboard history.

## Testing

Run the test suite:

```bash
swift test
```

The tests cover:
- Adding entries to the database
- Duplicate prevention
- Whitespace trimming
- Search functionality
- Limit and ordering
- Clearing history
- Settings persistence

## Architecture

- **DBManager**: SQLite database operations (add, fetch, search, clearAll)
- **ClipboardMonitor**: Polls NSPasteboard for text changes
- **HotKeyManager**: Registers configurable global hotkey using Carbon API
- **StatusBarManager**: Manages menu bar icon and menu items
- **SettingsManager**: Persists user preferences in UserDefaults
- **AppDelegate**: Wires components and manages the history window
- **HistoryView**: SwiftUI interface for displaying and searching history
- **SettingsView**: SwiftUI interface for configuring preferences

## Database Schema

```sql
CREATE TABLE entries (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    text TEXT UNIQUE NOT NULL,
    created_at INTEGER NOT NULL
);
```

## Privacy

- All clipboard data is stored locally on your machine
- No network access or external communication
- No analytics or telemetry
- Database is only readable by your user account

## License

See LICENSE file for details.
