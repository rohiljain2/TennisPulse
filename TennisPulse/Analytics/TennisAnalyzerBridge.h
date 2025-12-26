//
//  TennisAnalyzerBridge.h
//  TennisPulse
//
//  Objective-C header for bridging C++ Tennis Analyzer to Swift
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * @brief Analysis results for a training session
 */
@interface TennisAnalysisResult : NSObject

@property (nonatomic, readonly) double totalActiveTime;
@property (nonatomic, readonly) double workRestRatio;
@property (nonatomic, readonly) double consistencyScore;
@property (nonatomic, readonly) double trainingDensityScore;
@property (nonatomic, readonly) double averageIntensity;
@property (nonatomic, readonly) double totalWorkVolume;
@property (nonatomic, readonly) NSUInteger totalSets;

- (instancetype)init NS_UNAVAILABLE;

@end

/**
 * @brief Bridge class for C++ Tennis Analyzer
 * 
 * Provides Swift-compatible interface to the C++ tennis analyzer library
 */
@interface TennisAnalyzerBridge : NSObject

/**
 * @brief Analyze a training session
 * 
 * @param durations Array of set durations in seconds
 * @param intensities Array of intensity levels (1-5)
 * @param restDurations Optional array of rest durations between sets (nil for default 1:1 ratio)
 * @return AnalysisResult or nil if inputs are invalid
 */
+ (nullable TennisAnalysisResult *)analyzeWithDurations:(NSArray<NSNumber *> *)durations
                                            intensities:(NSArray<NSNumber *> *)intensities
                                         restDurations:(nullable NSArray<NSNumber *> *)restDurations;

/**
 * @brief Calculate total active time
 * 
 * @param durations Array of set durations in seconds
 * @return Total active time in seconds
 */
+ (double)calculateTotalActiveTimeWithDurations:(NSArray<NSNumber *> *)durations;

/**
 * @brief Calculate work/rest ratio
 * 
 * @param durations Array of set durations in seconds
 * @param restDurations Optional array of rest durations (nil for default 1:1 ratio)
 * @return Work to rest ratio
 */
+ (double)calculateWorkRestRatioWithDurations:(NSArray<NSNumber *> *)durations
                                 restDurations:(nullable NSArray<NSNumber *> *)restDurations;

/**
 * @brief Calculate consistency score
 * 
 * @param durations Array of set durations in seconds
 * @param intensities Array of intensity levels (1-5)
 * @return Consistency score (0.0 - 1.0)
 */
+ (double)calculateConsistencyScoreWithDurations:(NSArray<NSNumber *> *)durations
                                      intensities:(NSArray<NSNumber *> *)intensities;

/**
 * @brief Calculate training density score
 * 
 * @param durations Array of set durations in seconds
 * @param intensities Array of intensity levels (1-5)
 * @return Training density score (0.0 - 1.0)
 */
+ (double)calculateTrainingDensityScoreWithDurations:(NSArray<NSNumber *> *)durations
                                         intensities:(NSArray<NSNumber *> *)intensities;

@end

NS_ASSUME_NONNULL_END

