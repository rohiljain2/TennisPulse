# TennisPulse

iOS tennis training analytics app with a SwiftUI frontend and a C++ performance analytics engine. TennisPulse helps players track training sessions, analyze consistency, and understand work/rest patterns through clean visualizations and advanced on-device analytics.

## Features

- Create and manage tennis training sessions (rallies, serves, drills)
- Real-time set duration tracking
- Session summaries with advanced performance metrics
- Interactive charts for consistency, density, and work/rest ratios
- Fully local data storage (no cloud dependency)

## Analytics Engine

TennisPulse uses a portable C++ analytics engine to compute performance metrics efficiently and consistently across platforms. Metrics include:

- Total active time
- Work/rest ratio
- Consistency score (variance-based)
- Training density score

The engine is integrated into the iOS app via an Objective-C++ bridge, ensuring high performance and clean separation of concerns.

## Architecture

- **Frontend**: SwiftUI
- **Pattern**: MVVM
- **Reactive layer**: Combine
- **Charts**: Apple Charts
- **Analytics**: C++ (bridged via Objective-C++)
- **Persistence**: Local JSON storage (Codable + UserDefaults)

Data flow: Views → ViewModels → Services → C++ Analytics Engine

## Visualizations

- Set duration consistency chart
- Active vs rest time comparison
- Training density trends across sessions

All charts are rendered using Apple Charts and update reactively.

## Tech Stack

- Swift / SwiftUI
- C++ (cross-platform analytics)
- Objective-C++ bridging
- Combine
- Apple Charts
- MVVM architecture

## Getting Started

1. Open `TennisPulse.xcodeproj` in Xcode
2. Build and run the project

## Requirements

- iOS 16+
- Xcode 15.0+