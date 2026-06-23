# SilverPokeDex

A modern, standalone Pokédex built with **SwiftUI**, **Swift Concurrency**, and the **PokéAPI**.

SilverPokeDex is designed as a portfolio-ready iOS/macOS project that demonstrates modern SwiftUI architecture, adaptive layouts, concurrent networking, and polished card-based UI.

## Highlights

- Browse Pokémon with rich card-style rows
- Search by name, Pokédex ID, type, and ability
- Detail screen with immersive gradient hero design
- Type chips, abilities, weaknesses, and base experience
- Progressive loading state: `Loaded X/Y Pokémon`
- Pull-to-refresh on iOS
- Toolbar reload support on macOS
- Smooth overlay-based detail presentation
- Designed to scale across iPhone, iPad, macOS, and future large-screen iPhones

## Architecture

SilverPokeDex follows a lightweight **MVVM** architecture.

```text
SilverPokeDex
├── Models
│   ├── Pokemon.swift
│   └── PokemonElementType.swift
│
├── Services
│   └── PokemonAPI.swift
│
├── ViewModels
│   └── PokemonListViewModel.swift
│
├── Views
│   ├── PokemonListView.swift
│   └── PokemonDetailView.swift
│
└── App
    └── SilverPokeDexApp.swift
```

### Model Layer

The model layer contains plain Codable/Hashable domain models for PokéAPI responses. Pokémon weaknesses are derived locally from type-effectiveness data instead of requiring additional API calls.

### Service Layer

`PokemonAPI` owns networking and API decoding. It includes both modern async APIs and legacy callback-style examples for debugging/concurrency practice.

Responsibilities:

- Fetch Pokémon list
- Fetch Pokémon detail
- Decode API responses
- Provide legacy callback APIs for comparison/testing

### ViewModel Layer

`PokemonListViewModel` owns UI state and loading behavior.

Responsibilities:

- Loading Pokémon
- Tracking progress
- Preventing overlapping loads
- Handling refresh state
- Publishing error/loading/status state
- Keeping existing data visible during refresh

### View Layer

SwiftUI views stay presentation-focused.

Responsibilities:

- Adaptive layout
- Search UI
- Card presentation
- Detail overlay presentation
- Platform-specific behavior

## Swift Concurrency

The project uses modern Swift concurrency patterns:

- `async/await`
- `TaskGroup`
- `@MainActor`
- `defer` for cleanup
- Guarding against duplicate concurrent loads

Pokémon details are fetched concurrently, but the architecture can support batching to avoid overwhelming the API when loading large datasets.

## UI & Size Support

SilverPokeDex is designed to be a standalone app, not a fixed-size demo.

### iPhone

- Supports compact width layouts
- Detail screen uses immersive gradients that extend behind the Dynamic Island and safe areas
- Content is scrollable only when needed
- Bottom close control is reachable and separated from the card content
- Card UI avoids hardcoded device-specific layout assumptions where possible

### iPhone Pro Max / Future iPhone Ultra-Class Displays

SilverPokeDex is designed to scale beyond current iPhone Pro Max dimensions.

Large-display considerations:

- Detail cards use flexible vertical spacing instead of fixed screen assumptions
- Hero artwork scales proportionally without clipping
- Content remains scrollable only when needed
- Bottom close controls remain reachable and visually separated
- Layout avoids hardcoded device-specific offsets where possible
- Dynamic Island and safe-area regions are respected while still allowing immersive gradient backgrounds
- Large iPhone layouts are treated as a first-class target, not just stretched compact layouts

Recommended testing:

- iPhone SE
- iPhone 15/16/17 regular-size simulators
- iPhone Pro Max simulator
- Future iPhone Ultra-style large display sizes
- Landscape orientation
- Dynamic Type: Large and Extra Large

### iPad

- Supports larger available canvas
- Card rows and detail views remain centered and readable
- Works in portrait and landscape
- Suitable for split-screen testing

### macOS

- Uses macOS-compatible navigation and toolbar behavior
- Supports window resizing
- Reload action is exposed through toolbar
- Uses `ScrollView + LazyVStack` instead of `List` for better custom card styling control

For macOS sandboxed builds, enable:

```text
Signing & Capabilities → App Sandbox → Network → Outgoing Connections (Client)
```

Without this, PokéAPI requests may fail on macOS.

## Design Direction

The UI follows a modern card/profile style inspired by native Apple surfaces:

- Soft gradients
- Rounded cards
- Glass-style controls
- Type-aware coloring
- Minimal chrome
- Adaptive spacing

The goal is to feel like a polished standalone Pokédex, not a basic API sample.

## Running the Project

Requirements:

- Xcode 16+
- Swift 6+
- iOS 18+ or macOS 15+
- Internet connection

Steps:

1. Open `SilverPokeDex.xcodeproj`.
2. Select an iOS or macOS target.
3. Build and run.
4. On macOS, verify outgoing network capability is enabled if sandboxing is active.

## Testing Notes

Recommended manual checks:

- Initial load progress
- Pull-to-refresh on iOS
- Reload button on macOS
- Search by name
- Search by ID
- Search by ability
- Search by type
- Detail open/close animation
- Dynamic Island spacing
- Small-device layout
- Large iPhone / Ultra-class layout
- macOS window resizing

## Future Improvements

- Image cache actor
- Offline persistence with SwiftData
- Pagination instead of eager loading
- Evolution chain support
- Favorites
- Team builder
- Snapshot tests for adaptive UI
- Dependency injection via protocols
- Unit tests for type-effectiveness logic

## Portfolio Value

This project demonstrates:

- SwiftUI architecture
- Swift Concurrency
- Cross-platform UI support
- API integration
- Adaptive layout thinking
- Debugging and production-readiness improvements
- Modern iOS/macOS polish

## License

MIT
