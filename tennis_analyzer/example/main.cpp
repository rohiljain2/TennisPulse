//
//  main.cpp
//  Example usage of Tennis Analyzer library
//

#include "tennis_analyzer.hpp"
#include <iostream>
#include <iomanip>
#include <vector>

using namespace tennis;

void printAnalysisResult(const AnalysisResult& result) {
    std::cout << "\n=== Training Session Analysis ===\n";
    std::cout << std::fixed << std::setprecision(2);
    
    std::cout << "\nBasic Metrics:\n";
    std::cout << "  Total Active Time: " << result.totalActiveTime << " seconds ("
              << result.totalActiveTime / 60.0 << " minutes)\n";
    std::cout << "  Work/Rest Ratio: " << result.workRestRatio << "\n";
    std::cout << "  Consistency Score: " << result.consistencyScore 
              << " (0.0 = inconsistent, 1.0 = perfectly consistent)\n";
    std::cout << "  Training Density Score: " << result.trainingDensityScore
              << " (0.0 = low density, 1.0 = high density)\n";
    
    std::cout << "\nAdditional Metrics:\n";
    std::cout << "  Total Sets: " << result.totalSets << "\n";
    std::cout << "  Average Intensity: " << result.averageIntensity << " / 5.0\n";
    std::cout << "  Total Work Volume: " << result.totalWorkVolume << " (intensity-weighted seconds)\n";
    
    std::cout << "\n";
}

int main() {
    std::cout << "Tennis Training Session Analyzer - Example\n";
    std::cout << "==========================================\n";
    
    TennisAnalyzer analyzer;
    
    // Example 1: Consistent training session
    std::cout << "\n--- Example 1: Consistent Training Session ---\n";
    std::vector<double> durations1 = {300.0, 300.0, 300.0, 300.0, 300.0}; // 5 sets of 5 minutes
    std::vector<uint8_t> intensities1 = {3, 3, 3, 3, 3}; // All moderate intensity
    
    try {
        AnalysisResult result1 = analyzer.analyze(durations1, intensities1);
        printAnalysisResult(result1);
    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << "\n";
    }
    
    // Example 2: Variable intensity session
    std::cout << "\n--- Example 2: Variable Intensity Session ---\n";
    std::vector<double> durations2 = {180.0, 240.0, 300.0, 240.0, 180.0}; // Varying durations
    std::vector<uint8_t> intensities2 = {2, 3, 5, 4, 2}; // Varying intensities
    
    try {
        AnalysisResult result2 = analyzer.analyze(durations2, intensities2);
        printAnalysisResult(result2);
    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << "\n";
    }
    
    // Example 3: High-intensity session
    std::cout << "\n--- Example 3: High-Intensity Session ---\n";
    std::vector<double> durations3 = {120.0, 120.0, 120.0, 120.0}; // 4 sets of 2 minutes
    std::vector<uint8_t> intensities3 = {5, 5, 5, 5}; // All very high intensity
    
    try {
        AnalysisResult result3 = analyzer.analyze(durations3, intensities3);
        printAnalysisResult(result3);
    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << "\n";
    }
    
    // Example 4: Using individual calculation methods
    std::cout << "\n--- Example 4: Individual Calculations ---\n";
    std::vector<double> durations4 = {240.0, 300.0, 180.0};
    std::vector<uint8_t> intensities4 = {3, 4, 3};
    
    double totalTime = TennisAnalyzer::calculateTotalActiveTime(durations4);
    double ratio = TennisAnalyzer::calculateWorkRestRatio(durations4);
    double consistency = TennisAnalyzer::calculateConsistencyScore(durations4, intensities4);
    double density = TennisAnalyzer::calculateTrainingDensityScore(durations4, intensities4);
    
    std::cout << "Total Active Time: " << totalTime << " seconds\n";
    std::cout << "Work/Rest Ratio: " << ratio << "\n";
    std::cout << "Consistency Score: " << consistency << "\n";
    std::cout << "Training Density Score: " << density << "\n";
    
    return 0;
}

