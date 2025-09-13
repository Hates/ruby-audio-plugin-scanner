# Audio Plugin Scanner for macOS

A Ruby command-line tool that scans and lists all installed audio plugins on macOS systems. Supports AU Components, VST, VST3, and AAX plugin formats with consolidated views and detailed path information.

> 🤖 This project was generated with the help of [Claude Code](https://claude.ai/code)

## Features

- **Comprehensive Plugin Detection**: Scans all major audio plugin formats
  - AU Components (Audio Units)
  - VST (Virtual Studio Technology)
  - VST3 (Virtual Studio Technology 3)
  - AAX (Avid Audio eXtension)

- **Consolidated View**: Groups plugins by name and shows all available formats
- **Detailed Paths**: Shows exact file system locations for each plugin format
- **Location Indicators**: Distinguishes between system-wide and user-specific installations
- **Format Filtering**: View plugins of a specific format only
- **Statistics**: Shows total plugin instances vs unique plugins

## Installation

Clone this repository:

```bash
git clone <repository-url>
cd audio-plugin-scanner
```

## Usage

### Basic Scan (Consolidated View)

```bash
./bin/audio_plugin_scanner
```

Output example:
```
🎵 Audio Plugin Scanner for macOS
==================================================
Total plugin instances: 719
Unique plugins: 385

Consolidated Plugin List:
----------------------------------------
  🏢 Abbey Road Two [AAX, AU, VST, VST3]
  🏢 Battery 4 [AAX, AU, VST, VST3]
  🏠 HoRNetVUMeterMK4 [AU, VST, VST3]
  ...
```

### Detailed View with Paths

```bash
./bin/audio_plugin_scanner --detailed
```

Output example:
```
🎵 Audio Plugin Scanner for macOS (Detailed)
======================================================================
Total plugin instances: 719
Unique plugins: 385

Consolidated Plugin List with Paths:
----------------------------------------------------------------------
  🏢 Abbey Road Two [AAX, AU, VST, VST3]
     AAX: /Library/Application Support/Avid/Audio/Plug-Ins/Abbey Road Two.aaxplugin
     AU: /Library/Audio/Plug-Ins/Components/Abbey Road Two.component
     VST: /Library/Audio/Plug-Ins/VST/Abbey Road Two.vst
     VST3: /Library/Audio/Plug-Ins/VST3/Abbey Road Two.vst3
  ...
```

### Filter by Plugin Type

```bash
./bin/audio_plugin_scanner --type au     # AU Components only
./bin/audio_plugin_scanner --type vst    # VST plugins only
./bin/audio_plugin_scanner --type vst3   # VST3 plugins only
./bin/audio_plugin_scanner --type aax    # AAX plugins only
```

### Help

```bash
./bin/audio_plugin_scanner --help
```

## Command Line Options

| Option | Description |
|--------|-------------|
| `-d, --detailed` | Show detailed information including file paths |
| `-t, --type TYPE` | Show only plugins of specified type (au, vst, vst3, aax) |
| `-h, --help` | Show help message |

## Icons

- 🏢 System-wide plugins (installed in `/Library/`)
- 🏠 User-specific plugins (installed in `~/Library/`)

## Plugin Locations Scanned

The scanner checks these standard macOS plugin directories:

### AU Components
- `/Library/Audio/Plug-Ins/Components/` (system)
- `~/Library/Audio/Plug-Ins/Components/` (user)

### VST Plugins  
- `/Library/Audio/Plug-Ins/VST/` (system)
- `~/Library/Audio/Plug-Ins/VST/` (user)

### VST3 Plugins
- `/Library/Audio/Plug-Ins/VST3/` (system)
- `~/Library/Audio/Plug-Ins/VST3/` (user)

### AAX Plugins
- `/Library/Application Support/Avid/Audio/Plug-Ins/` (system)

## Requirements

- Ruby 2.7 or later
- macOS (tested on macOS 13+)

## Project Structure

```
audio-plugin-scanner/
├── bin/
│   └── audio_plugin_scanner     # Executable script
├── lib/
│   └── audio_plugin_scanner.rb  # Main scanner class
├── README.md                    # This file
└── Gemfile                      # Ruby dependencies
```

## Development

The main scanner logic is in `lib/audio_plugin_scanner.rb`. The executable in `bin/audio_plugin_scanner` handles command-line parsing and calls the appropriate scanner methods.

## License

This project is open source. Feel free to use, modify, and distribute.

## About This Project

This audio plugin scanner was built collaboratively with [Claude Code](https://claude.ai/code), Anthropic's AI coding assistant. The development process showcased how AI can help create well-structured, functional command-line tools by:

- **Iterative Development**: Starting with a simple concept and evolving through user feedback
- **Ruby Best Practices**: Implementing proper project structure with `lib/` and `bin/` directories
- **Comprehensive Features**: Building from basic scanning to consolidated views and detailed path reporting
- **Documentation**: Creating thorough README documentation and inline code comments

The scanner demonstrates practical Ruby programming techniques including file system traversal, data consolidation, command-line argument parsing, and clean object-oriented design.

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.
