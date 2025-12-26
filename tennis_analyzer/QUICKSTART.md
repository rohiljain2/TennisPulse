# Quick Start Guide - Running Tennis Analyzer

## Step 1: Check Requirements

You need:
- **CMake** (3.10 or later)
- **C++ compiler** (GCC or Clang)
- **Make** (usually pre-installed)

### Check if you have them:

```bash
cmake --version
g++ --version  # or clang++ --version
make --version
```

### Install if missing:

**On macOS:**
```bash
# Install Xcode Command Line Tools (includes compiler)
xcode-select --install

# Install CMake via Homebrew
brew install cmake
```

**On Linux (Ubuntu/Debian):**
```bash
sudo apt-get update
sudo apt-get install build-essential cmake
```

**On Linux (Fedora/RHEL):**
```bash
sudo dnf install gcc-c++ cmake make
```

## Step 2: Build the Library

### Option A: Using the build script (easiest)

```bash
cd tennis_analyzer
./build.sh
```

### Option B: Manual build

```bash
cd tennis_analyzer

# Create build directory
mkdir build
cd build

# Configure with CMake (enable example)
cmake -DBUILD_EXAMPLE=ON ..

# Build
make
```

## Step 3: Run the Example

After building, run the example program:

```bash
# From the build directory
./bin/tennis_analyzer_example
```

Or from the tennis_analyzer directory:

```bash
./build/bin/tennis_analyzer_example
```

## Step 4: Expected Output

You should see output like:

```
Tennis Training Session Analyzer - Example
==========================================

--- Example 1: Consistent Training Session ---

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

## Troubleshooting

### Error: "cmake: command not found"
- Install CMake (see Step 1)

### Error: "No C++ compiler found"
- Install Xcode Command Line Tools (macOS) or build-essential (Linux)

### Error: "CMakeLists.txt not found"
- Make sure you're in the `tennis_analyzer` directory

### Build fails with errors
- Make sure you have C++17 support
- Try: `cmake -DCMAKE_CXX_STANDARD=17 ..`

## Using the Library in Your Own Code

1. **Include the header:**
```cpp
#include "tennis_analyzer.hpp"
```

2. **Link against the library:**
```bash
g++ your_code.cpp -I./include -L./build/lib -ltennis_analyzer -o your_program
```

3. **Or use CMake in your project:**
```cmake
target_link_libraries(your_target tennis_analyzer)
```

## Quick Test

Try this quick test to verify everything works:

```bash
cd tennis_analyzer
./build.sh
./build/bin/tennis_analyzer_example
```

If you see the analysis output, you're all set! 🎾

