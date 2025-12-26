//
//  tennis_analyzer.hpp
//  Tennis Training Session Analyzer
//
//  C++ library for analyzing tennis training sessions
//  Portable and Linux-compatible
//

#ifndef TENNIS_ANALYZER_HPP
#define TENNIS_ANALYZER_HPP

#include <vector>
#include <cstddef>
#include <cstdint>

namespace tennis {

/**
 * @brief Intensity level for training sets (1-5 scale)
 */
enum class Intensity : uint8_t {
    VeryLow = 1,
    Low = 2,
    Moderate = 3,
    High = 4,
    VeryHigh = 5
};

/**
 * @brief Analysis results for a training session
 */
struct AnalysisResult {
    double totalActiveTime;      // Total active time in seconds
    double workRestRatio;        // Work to rest ratio
    double consistencyScore;     // Consistency score (0.0 - 1.0)
    double trainingDensityScore; // Training density score (0.0 - 1.0)
    
    // Additional metrics
    double averageIntensity;     // Average intensity (1.0 - 5.0)
    double totalWorkVolume;       // Total work volume (intensity-weighted time)
    size_t totalSets;             // Total number of sets
};

/**
 * @brief Tennis Training Session Analyzer
 * 
 * Analyzes tennis training sessions based on set durations and intensities.
 * Provides metrics including total active time, work/rest ratio, consistency,
 * and training density.
 */
class TennisAnalyzer {
public:
    /**
     * @brief Default constructor
     */
    TennisAnalyzer() = default;
    
    /**
     * @brief Destructor
     */
    ~TennisAnalyzer() = default;
    
    // Delete copy constructor and assignment operator for safety
    TennisAnalyzer(const TennisAnalyzer&) = delete;
    TennisAnalyzer& operator=(const TennisAnalyzer&) = delete;
    
    /**
     * @brief Analyze a training session
     * 
     * @param durations Vector of set durations in seconds
     * @param intensities Vector of intensity levels (1-5)
     * @return AnalysisResult containing all calculated metrics
     * @throws std::invalid_argument if inputs are invalid
     */
    AnalysisResult analyze(
        const std::vector<double>& durations,
        const std::vector<uint8_t>& intensities
    );
    
    /**
     * @brief Calculate total active time
     * 
     * @param durations Vector of set durations in seconds
     * @return Total active time in seconds
     */
    static double calculateTotalActiveTime(const std::vector<double>& durations);
    
    /**
     * @brief Calculate work/rest ratio
     * 
     * Assumes rest periods are equal to work periods (1:1 ratio)
     * Can be customized by providing rest durations
     * 
     * @param durations Vector of set durations in seconds
     * @param restDurations Optional vector of rest durations (default: same as work)
     * @return Work to rest ratio
     */
    static double calculateWorkRestRatio(
        const std::vector<double>& durations,
        const std::vector<double>& restDurations = {}
    );
    
    /**
     * @brief Calculate consistency score
     * 
     * Measures how consistent the training session is based on:
     * - Duration consistency (coefficient of variation)
     * - Intensity consistency
     * 
     * @param durations Vector of set durations in seconds
     * @param intensities Vector of intensity levels (1-5)
     * @return Consistency score (0.0 = inconsistent, 1.0 = perfectly consistent)
     */
    static double calculateConsistencyScore(
        const std::vector<double>& durations,
        const std::vector<uint8_t>& intensities
    );
    
    /**
     * @brief Calculate training density score
     * 
     * Measures training density based on:
     * - Average intensity
     * - Total work volume
     * - Time distribution
     * 
     * @param durations Vector of set durations in seconds
     * @param intensities Vector of intensity levels (1-5)
     * @return Training density score (0.0 = low density, 1.0 = high density)
     */
    static double calculateTrainingDensityScore(
        const std::vector<double>& durations,
        const std::vector<uint8_t>& intensities
    );

private:
    /**
     * @brief Validate input vectors
     * 
     * @param durations Vector of set durations
     * @param intensities Vector of intensities
     * @throws std::invalid_argument if validation fails
     */
    static void validateInputs(
        const std::vector<double>& durations,
        const std::vector<uint8_t>& intensities
    );
    
    /**
     * @brief Calculate mean of a vector
     */
    static double mean(const std::vector<double>& values);
    
    /**
     * @brief Calculate standard deviation of a vector
     */
    static double standardDeviation(const std::vector<double>& values);
    
    /**
     * @brief Calculate coefficient of variation
     */
    static double coefficientOfVariation(const std::vector<double>& values);
    
    /**
     * @brief Normalize intensity to 0.0-1.0 range
     */
    static double normalizeIntensity(uint8_t intensity);
};

} // namespace tennis

#endif // TENNIS_ANALYZER_HPP

