# TennisPulse

A SwiftUI tennis training app built with MVVM architecture that helps track training sessions and sets.

## Architecture

The app follows the **MVVM (Model-View-ViewModel)** pattern:

- **Models**: Core data structures (`TrainingSession`, `TrainingSet`, `SetType`)
- **Views**: SwiftUI views that display the UI (`SessionListView`, `SessionDetailView`)
- **ViewModels**: Business logic and state management (`TrainingSessionViewModel`, `SessionDetailViewModel`)
- **Services**: Data persistence layer (`TrainingSessionService`)

## Project Structure

```
TennisPulse/
├── TennisPulse/
│   ├── Models/
│   │   ├── SetType.swift              # Enum for set types (rally, serve, drill)
│   │   ├── TrainingSet.swift          # Individual set model
│   │   └── TrainingSession.swift      # Session model containing multiple sets
│   ├── ViewModels/
│   │   ├── TrainingSessionViewModel.swift    # Manages list of sessions
│   │   └── SessionDetailViewModel.swift      # Manages individual session details
│   ├── Views/
│   │   ├── SessionListView.swift      # Main list view
│   │   └── SessionDetailView.swift    # Session detail and set management
│   ├── Services/
│   │   └── TrainingSessionService.swift  # Data persistence service
│   ├── TennisPulseApp.swift           # App entry point
│   └── Info.plist
└── README.md
```

## Core Data Models

### SetType
Enum representing the type of training set:
- `rally`: Rally practice
- `serve`: Serve practice
- `drill`: Drill practice

### TrainingSet
Represents a single training set with:
- `id`: Unique identifier
- `startTime`: When the set started
- `endTime`: When the set ended (optional, nil if active)
- `type`: The type of set (SetType enum)
- Computed properties: `duration`, `formattedDuration`, `isActive`

### TrainingSession
Represents a complete training session with:
- `id`: Unique identifier
- `date`: Session date
- `sets`: Array of TrainingSet objects
- `notes`: Optional notes about the session
- Computed properties: `totalDuration`, `formattedTotalDuration`, `setsByType`, `hasActiveSet`, `activeSet`

## Features

- ✅ Create and manage training sessions
- ✅ Track multiple sets per session
- ✅ Three set types: Rally, Serve, Drill
- ✅ Real-time duration tracking for active sets
- ✅ Session notes
- ✅ Data persistence using UserDefaults
- ✅ Clean MVVM architecture
- ✅ SwiftUI native UI

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Getting Started

1. Open `TennisPulse.xcodeproj` in Xcode
2. Build and run the project
3. Start creating your training sessions!

## Future Enhancements

Potential features to add:
- Core Data or CloudKit for better persistence
- Statistics and analytics
- Export/import functionality
- Apple Watch companion app
- Workout integration with HealthKit