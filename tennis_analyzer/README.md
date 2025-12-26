# Tennis Training Session Analyzer

A portable C++ library for analyzing tennis training sessions. Provides metrics including total active time, work/rest ratio, consistency score, and training density score.

## Features

- **Total Active Time**: Sum of all set durations
- **Work/Rest Ratio**: Ratio of work time to rest time
- **Consistency Score**: Measures session consistency (0.0 - 1.0)
- **Training Density Score**: Measures training intensity and density (0.0 - 1.0)
- **Additional Metrics**: Average intensity, total work volume, set counts

## Requirements

- C++17 or later
- CMake 3.10 or later
- Linux-compatible compiler (GCC, Clang)

## Building

### Basic Build

```bash
mkdir build
cd build
cmake ..
make
```

### Build with Example

```bash
mkdir build
cd build
cmake -DBUILD_EXAMPLE=ON ..
make
```

### Install

```bash
make install
```

## Usage

### Basic Example

```cpp
#include "tennis_analyzer.hpp"
#include <vector>

using namespace tennis;

int main() {
    TennisAnalyzer analyzer;
    
    // Set durations in seconds
    std::vector<double> durations = {300.0, 300.0, 300.0, 300.0, 300.0};
    
    // Intensities (1-5 scale)
    std::vector<uint8_t> intensities = {3, 3, 3, 3, 3};
    
    // Analyze session
    AnalysisResult result = analyzer.analyze(durations, intensities);
    
    // Access results
    std::cout << "Total Active Time: " << result.totalActiveTime << " seconds\n";
    std::cout << "Work/Rest Ratio: " << result.workRestRatio << "\n";
    std::cout << "Consistency Score: " << result.consistencyScore << "\n";
    std::cout << "Training Density Score: " << result.trainingDensityScore << "\n";
    
    return 0;
}
```

### Individual Calculations

You can also use static methods for individual calculations:

```cpp
double totalTime = TennisAnalyzer::calculateTotalActiveTime(durations);
double ratio = TennisAnalyzer::calculateWorkRestRatio(durations);
double consistency = TennisAnalyzer::calculateConsistencyScore(durations, intensities);
double density = TennisAnalyzer::calculateTrainingDensityScore(durations, intensities);
```

## API Reference

### `TennisAnalyzer` Class

#### `analyze(durations, intensities)`

Analyzes a complete training session.

**Parameters:**
- `durations`: Vector of set durations in seconds
- `intensities`: Vector of intensity levels (1-5)

**Returns:** `AnalysisResult` struct with all metrics

**Throws:** `std::invalid_argument` if inputs are invalid

#### Static Methods

- `calculateTotalActiveTime(durations)`: Calculate total active time
- `calculateWorkRestRatio(durations, restDurations)`: Calculate work/rest ratio
- `calculateConsistencyScore(durations, intensities)`: Calculate consistency (0.0-1.0)
- `calculateTrainingDensityScore(durations, intensities)`: Calculate density (0.0-1.0)

### `AnalysisResult` Struct

```cpp
struct AnalysisResult {
    double totalActiveTime;      // Total active time in seconds
    double workRestRatio;        // Work to rest ratio
    double consistencyScore;     // Consistency score (0.0 - 1.0)
    double trainingDensityScore; // Training density score (0.0 - 1.0)
    double averageIntensity;     // Average intensity (1.0 - 5.0)
    double totalWorkVolume;      // Total work volume (intensity-weighted)
    size_t totalSets;            // Total number of sets
};
```

## Input Validation

- Durations must be in range [0, 86400] seconds (0 to 24 hours)
- Intensities must be in range [1, 5]
- Durations and intensities vectors must have the same size
- Empty vectors are handled gracefully

## Algorithm Details

### Consistency Score

Measures how consistent a training session is:
- **Duration Consistency**: Coefficient of variation of durations (60% weight)
- **Intensity Consistency**: Coefficient of variation of intensities (40% weight)
- Returns value between 0.0 (inconsistent) and 1.0 (perfectly consistent)

### Training Density Score

Measures training density based on:
- **Average Intensity**: Normalized intensity (40% weight)
- **Work Volume**: Intensity-weighted total time (40% weight)
- **Duration Distribution**: Penalizes very short or very long sets (20% weight)
- Returns value between 0.0 (low density) and 1.0 (high density)

### Work/Rest Ratio

- Default: Assumes rest equals work time (1:1 ratio)
- Custom: Can provide rest durations vector for custom ratios

## Portability

- Uses only standard C++17 features
- No platform-specific code
- Compatible with GCC, Clang, and MSVC
- Tested on Linux, should work on macOS and Windows

## License

This library is provided as-is for educational and development purposes.

## Example Output

```
=== Training Session Analysis ===

Basic Metrics:
  Total Active Time: 1500.00 seconds (25.00 minutes)
  Work/Rest Ratio: 1.00
  Consistency Score: 1.00 (0.0 = inconsistent, 1.0 = perfectly consistent)
  Training Density Score: 0.60 (0.0 = low density, 1.0 = high density)

Additional Metrics:
  Total Sets: 5
  Average Intensity: 3.00 / 5.0
  Total Work Volume: 4500.00 (intensity-weighted seconds)
```

