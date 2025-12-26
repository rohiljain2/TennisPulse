#!/bin/bash
# Build script for Tennis Analyzer library

set -e

echo "Building Tennis Analyzer Library..."

# Create build directory
mkdir -p build
cd build

# Configure CMake
cmake ..

# Build
make -j$(nproc)

echo ""
echo "Build complete!"
echo ""
echo "To run the example:"
echo "  ./bin/tennis_analyzer_example"
echo ""
echo "Library location:"
echo "  ./lib/libtennis_analyzer.a"

