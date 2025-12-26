//
//  TennisAnalyzerBridge.mm
//  TennisPulse
//
//  Objective-C++ implementation bridging C++ Tennis Analyzer to Swift
//

#import "TennisAnalyzerBridge.h"
#import <vector>
#import <string>

// Include the C++ header
// Note: tennis_analyzer.cpp must be added to Xcode project and compiled
#include "tennis_analyzer.hpp"

using namespace tennis;

// MARK: - TennisAnalysisResult Implementation

@implementation TennisAnalysisResult

- (instancetype)initWithResult:(const AnalysisResult&)result {
    self = [super init];
    if (self) {
        _totalActiveTime = result.totalActiveTime;
        _workRestRatio = result.workRestRatio;
        _consistencyScore = result.consistencyScore;
        _trainingDensityScore = result.trainingDensityScore;
        _averageIntensity = result.averageIntensity;
        _totalWorkVolume = result.totalWorkVolume;
        _totalSets = result.totalSets;
    }
    return self;
}

@end

// MARK: - TennisAnalyzerBridge Implementation

@implementation TennisAnalyzerBridge

+ (nullable TennisAnalysisResult *)analyzeWithDurations:(NSArray<NSNumber *> *)durations
                                            intensities:(NSArray<NSNumber *> *)intensities
                                         restDurations:(nullable NSArray<NSNumber *> *)restDurations {
    // Validate inputs
    if (durations.count != intensities.count || durations.count == 0) {
        return nil;
    }
    
    // Convert NSArray to std::vector
    std::vector<double> durationsVec;
    durationsVec.reserve(durations.count);
    for (NSNumber *duration in durations) {
        double value = [duration doubleValue];
        if (value < 0.0 || value > 86400.0) {
            return nil; // Invalid duration
        }
        durationsVec.push_back(value);
    }
    
    std::vector<uint8_t> intensitiesVec;
    intensitiesVec.reserve(intensities.count);
    for (NSNumber *intensity in intensities) {
        uint8_t value = [intensity unsignedCharValue];
        if (value < 1 || value > 5) {
            return nil; // Invalid intensity
        }
        intensitiesVec.push_back(value);
    }
    
    // Convert rest durations if provided
    std::vector<double> restDurationsVec;
    if (restDurations) {
        restDurationsVec.reserve(restDurations.count);
        for (NSNumber *restDuration in restDurations) {
            double value = [restDuration doubleValue];
            if (value < 0.0) {
                return nil; // Invalid rest duration
            }
            restDurationsVec.push_back(value);
        }
    }
    
    // Perform analysis
    try {
        TennisAnalyzer analyzer;
        AnalysisResult result = analyzer.analyze(durationsVec, intensitiesVec, restDurationsVec);
        
        // Convert to Objective-C object
        return [[TennisAnalysisResult alloc] initWithResult:result];
    } catch (...) {
        // Handle C++ exceptions
        return nil;
    }
}

+ (double)calculateTotalActiveTimeWithDurations:(NSArray<NSNumber *> *)durations {
    if (durations.count == 0) {
        return 0.0;
    }
    
    std::vector<double> durationsVec;
    durationsVec.reserve(durations.count);
    for (NSNumber *duration in durations) {
        durationsVec.push_back([duration doubleValue]);
    }
    
    return TennisAnalyzer::calculateTotalActiveTime(durationsVec);
}

+ (double)calculateWorkRestRatioWithDurations:(NSArray<NSNumber *> *)durations
                                 restDurations:(nullable NSArray<NSNumber *> *)restDurations {
    if (durations.count == 0) {
        return 0.0;
    }
    
    std::vector<double> durationsVec;
    durationsVec.reserve(durations.count);
    for (NSNumber *duration in durations) {
        durationsVec.push_back([duration doubleValue]);
    }
    
    std::vector<double> restDurationsVec;
    if (restDurations) {
        restDurationsVec.reserve(restDurations.count);
        for (NSNumber *restDuration in restDurations) {
            restDurationsVec.push_back([restDuration doubleValue]);
        }
    }
    
    try {
        return TennisAnalyzer::calculateWorkRestRatio(durationsVec, restDurationsVec);
    } catch (...) {
        return 0.0;
    }
}

+ (double)calculateConsistencyScoreWithDurations:(NSArray<NSNumber *> *)durations
                                      intensities:(NSArray<NSNumber *> *)intensities {
    if (durations.count != intensities.count || durations.count == 0) {
        return 0.0;
    }
    
    std::vector<double> durationsVec;
    durationsVec.reserve(durations.count);
    for (NSNumber *duration in durations) {
        durationsVec.push_back([duration doubleValue]);
    }
    
    std::vector<uint8_t> intensitiesVec;
    intensitiesVec.reserve(intensities.count);
    for (NSNumber *intensity in intensities) {
        intensitiesVec.push_back([intensity unsignedCharValue]);
    }
    
    return TennisAnalyzer::calculateConsistencyScore(durationsVec, intensitiesVec);
}

+ (double)calculateTrainingDensityScoreWithDurations:(NSArray<NSNumber *> *)durations
                                         intensities:(NSArray<NSNumber *> *)intensities {
    if (durations.count != intensities.count || durations.count == 0) {
        return 0.0;
    }
    
    std::vector<double> durationsVec;
    durationsVec.reserve(durations.count);
    for (NSNumber *duration in durations) {
        durationsVec.push_back([duration doubleValue]);
    }
    
    std::vector<uint8_t> intensitiesVec;
    intensitiesVec.reserve(intensities.count);
    for (NSNumber *intensity in intensities) {
        intensitiesVec.push_back([intensity unsignedCharValue]);
    }
    
    return TennisAnalyzer::calculateTrainingDensityScore(durationsVec, intensitiesVec);
}

@end

