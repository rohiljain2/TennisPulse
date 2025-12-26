#!/bin/bash
# Simple compilation script (no CMake required)

echo "Compiling Tennis Analyzer (simple method)..."

# Create output directory
mkdir -p simple_build

# Compile library
g++ -std=c++17 -c src/tennis_analyzer.cpp -Iinclude -o simple_build/tennis_analyzer.o

# Create static library
ar rcs simple_build/libtennis_analyzer.a simple_build/tennis_analyzer.o

# Compile example
g++ -std=c++17 example/main.cpp -Iinclude -Lsimple_build -ltennis_analyzer -o simple_build/tennis_analyzer_example

echo ""
echo "Build complete!"
echo ""
echo "Run the example:"
echo "  ./simple_build/tennis_analyzer_example"
echo ""

