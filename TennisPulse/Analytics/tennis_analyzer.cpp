//
//  tennis_analyzer.cpp
//  Tennis Training Session Analyzer
//
//  Implementation of tennis training session analysis
//

#include "tennis_analyzer.hpp"
#include <stdexcept>
#include <algorithm>
#include <numeric>
#include <cmath>
#include <limits>
#include <string>

namespace tennis {

// Constants
constexpr double MIN_DURATION = 0.0;
constexpr double MAX_DURATION = 86400.0; // 24 hours
constexpr uint8_t MIN_INTENSITY = 1;
constexpr uint8_t MAX_INTENSITY = 5;
constexpr double EPSILON = 1e-9;

AnalysisResult TennisAnalyzer::analyze(
    const std::vector<double>& durations,
    const std::vector<uint8_t>& intensities,
    const std::vector<double>& restDurations
) {
    // Validate inputs
    validateInputs(durations, intensities);
    
    AnalysisResult result;
    
    // Calculate basic metrics
    result.totalActiveTime = calculateTotalActiveTime(durations);
    result.workRestRatio = calculateWorkRestRatio(durations, restDurations);
    result.consistencyScore = calculateConsistencyScore(durations, intensities);
    result.trainingDensityScore = calculateTrainingDensityScore(durations, intensities);
    
    // Calculate additional metrics
    result.totalSets = durations.size();
    
    // Calculate average intensity
    double intensitySum = std::accumulate(intensities.begin(), intensities.end(), 0.0);
    result.averageIntensity = intensitySum / static_cast<double>(intensities.size());
    
    // Calculate total work volume (intensity-weighted time)
    result.totalWorkVolume = 0.0;
    for (size_t i = 0; i < durations.size(); ++i) {
        result.totalWorkVolume += durations[i] * static_cast<double>(intensities[i]);
    }
    
    return result;
}

double TennisAnalyzer::calculateTotalActiveTime(const std::vector<double>& durations) {
    if (durations.empty()) {
        return 0.0;
    }
    
    return std::accumulate(durations.begin(), durations.end(), 0.0);
}

double TennisAnalyzer::calculateWorkRestRatio(
    const std::vector<double>& durations,
    const std::vector<double>& restDurations
) {
    if (durations.empty()) {
        return 0.0;
    }
    
    double totalWork = calculateTotalActiveTime(durations);
    double totalRest = 0.0;
    
    if (restDurations.empty()) {
        // Default: assume rest equals work (1:1 ratio)
        totalRest = totalWork;
    } else {
        // Use provided rest durations
        // Rest durations represent gaps BETWEEN sets, so for N sets we have N-1 gaps
        // But we also accept N rest durations (one per set) for flexibility
        size_t expectedSize = durations.size();
        size_t gapSize = durations.size() > 1 ? durations.size() - 1 : 0;
        
        if (restDurations.size() != expectedSize && restDurations.size() != gapSize) {
            throw std::invalid_argument(
                "Rest durations vector size must match durations vector size or be one less (for gaps between sets)"
            );
        }
        totalRest = std::accumulate(restDurations.begin(), restDurations.end(), 0.0);
    }
    
    if (totalRest < EPSILON) {
        return std::numeric_limits<double>::infinity();
    }
    
    return totalWork / totalRest;
}

double TennisAnalyzer::calculateConsistencyScore(
    const std::vector<double>& durations,
    const std::vector<uint8_t>& intensities
) {
    if (durations.size() < 2) {
        // Single set is considered perfectly consistent
        return 1.0;
    }
    
    // Calculate duration consistency (coefficient of variation)
    double durationCV = coefficientOfVariation(durations);
    double durationConsistency = 1.0 / (1.0 + durationCV);
    
    // Calculate intensity consistency
    std::vector<double> intensityDoubles(intensities.begin(), intensities.end());
    double intensityCV = coefficientOfVariation(intensityDoubles);
    double intensityConsistency = 1.0 / (1.0 + intensityCV);
    
    // Combined consistency score (weighted average)
    // Duration consistency: 60%, Intensity consistency: 40%
    double consistency = 0.6 * durationConsistency + 0.4 * intensityConsistency;
    
    // Clamp to [0.0, 1.0]
    return std::max(0.0, std::min(1.0, consistency));
}

double TennisAnalyzer::calculateTrainingDensityScore(
    const std::vector<double>& durations,
    const std::vector<uint8_t>& intensities
) {
    if (durations.empty()) {
        return 0.0;
    }
    
    // Calculate average intensity (normalized to 0.0-1.0)
    double avgIntensity = 0.0;
    for (uint8_t intensity : intensities) {
        avgIntensity += normalizeIntensity(intensity);
    }
    avgIntensity /= static_cast<double>(intensities.size());
    
    // Calculate total work volume (intensity-weighted time)
    double totalWorkVolume = 0.0;
    for (size_t i = 0; i < durations.size(); ++i) {
        totalWorkVolume += durations[i] * normalizeIntensity(intensities[i]);
    }
    
    // Calculate average duration
    double avgDuration = mean(durations);
    
    // Normalize metrics
    // Intensity component: 0.0-1.0 (already normalized)
    // Volume component: normalize by max possible (assuming max intensity and reasonable duration)
    const double maxDuration = 3600.0; // 1 hour per set (reasonable max)
    double volumeComponent = std::min(1.0, totalWorkVolume / (maxDuration * durations.size()));
    
    // Duration distribution component (penalize very short or very long sets)
    double durationComponent = 1.0;
    if (avgDuration < 30.0) {
        // Very short sets reduce density
        durationComponent = avgDuration / 30.0;
    } else if (avgDuration > 1800.0) {
        // Very long sets also reduce density (fatigue factor)
        durationComponent = 1800.0 / avgDuration;
    }
    
    // Combined density score
    // Intensity: 40%, Volume: 40%, Duration: 20%
    double density = 0.4 * avgIntensity + 0.4 * volumeComponent + 0.2 * durationComponent;
    
    // Clamp to [0.0, 1.0]
    return std::max(0.0, std::min(1.0, density));
}

void TennisAnalyzer::validateInputs(
    const std::vector<double>& durations,
    const std::vector<uint8_t>& intensities
) {
    // Check vector sizes match
    if (durations.size() != intensities.size()) {
        throw std::invalid_argument(
            "Durations and intensities vectors must have the same size"
        );
    }
    
    // Check durations are valid
    for (size_t i = 0; i < durations.size(); ++i) {
        if (durations[i] < MIN_DURATION || durations[i] > MAX_DURATION) {
            throw std::invalid_argument(
                "Duration at index " + std::to_string(i) + 
                " is out of valid range [0, 86400] seconds"
            );
        }
    }
    
    // Check intensities are valid
    for (size_t i = 0; i < intensities.size(); ++i) {
        if (intensities[i] < MIN_INTENSITY || intensities[i] > MAX_INTENSITY) {
            throw std::invalid_argument(
                "Intensity at index " + std::to_string(i) + 
                " is out of valid range [1, 5]"
            );
        }
    }
}

double TennisAnalyzer::mean(const std::vector<double>& values) {
    if (values.empty()) {
        return 0.0;
    }
    
    double sum = std::accumulate(values.begin(), values.end(), 0.0);
    return sum / static_cast<double>(values.size());
}

double TennisAnalyzer::standardDeviation(const std::vector<double>& values) {
    if (values.size() < 2) {
        return 0.0;
    }
    
    double meanValue = mean(values);
    double sumSquaredDiff = 0.0;
    
    for (double value : values) {
        double diff = value - meanValue;
        sumSquaredDiff += diff * diff;
    }
    
    double variance = sumSquaredDiff / static_cast<double>(values.size() - 1);
    return std::sqrt(variance);
}

double TennisAnalyzer::coefficientOfVariation(const std::vector<double>& values) {
    if (values.empty()) {
        return 0.0;
    }
    
    double meanValue = mean(values);
    if (std::abs(meanValue) < EPSILON) {
        return 0.0;
    }
    
    double stdDev = standardDeviation(values);
    return stdDev / meanValue;
}

double TennisAnalyzer::normalizeIntensity(uint8_t intensity) {
    // Normalize from [1, 5] to [0.0, 1.0]
    return static_cast<double>(intensity - MIN_INTENSITY) / 
           static_cast<double>(MAX_INTENSITY - MIN_INTENSITY);
}

} // namespace tennis

