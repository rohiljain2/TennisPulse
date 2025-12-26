//
//  TennisAnalyzerService.swift
//  TennisPulse
//
//  Swift service wrapper for C++ Tennis Analyzer
//

import Foundation

/// Service for analyzing tennis training sessions using C++ analytics engine
class TennisAnalyzerService {
    static let shared = TennisAnalyzerService()
    
    private init() {}
    
    /// Analyze a training session
    /// - Parameters:
    ///   - durations: Array of set durations in seconds
    ///   - intensities: Array of intensity levels (1-5)
    ///   - restDurations: Optional array of rest durations between sets (nil for default 1:1 ratio)
    /// - Returns: Analysis result or nil if invalid
    func analyze(durations: [TimeInterval], intensities: [UInt8], restDurations: [TimeInterval]? = nil) -> TennisAnalysisResult? {
        let durationNumbers = durations.map { NSNumber(value: $0) }
        let intensityNumbers = intensities.map { NSNumber(value: $0) }
        let restNumbers = restDurations?.map { NSNumber(value: $0) }
        
        return TennisAnalyzerBridge.analyze(
            withDurations: durationNumbers,
            intensities: intensityNumbers,
            restDurations: restNumbers
        )
    }
    
    /// Calculate total active time
    func calculateTotalActiveTime(durations: [TimeInterval]) -> TimeInterval {
        let durationNumbers = durations.map { NSNumber(value: $0) }
        return TennisAnalyzerBridge.calculateTotalActiveTime(withDurations: durationNumbers)
    }
    
    /// Calculate work/rest ratio
    func calculateWorkRestRatio(
        durations: [TimeInterval],
        restDurations: [TimeInterval]? = nil
    ) -> Double {
        let durationNumbers = durations.map { NSNumber(value: $0) }
        let restNumbers = restDurations?.map { NSNumber(value: $0) }
        
        return TennisAnalyzerBridge.calculateWorkRestRatio(
            withDurations: durationNumbers,
            restDurations: restNumbers
        )
    }
    
    /// Calculate consistency score
    func calculateConsistencyScore(
        durations: [TimeInterval],
        intensities: [UInt8]
    ) -> Double {
        let durationNumbers = durations.map { NSNumber(value: $0) }
        let intensityNumbers = intensities.map { NSNumber(value: $0) }
        
        return TennisAnalyzerBridge.calculateConsistencyScore(
            withDurations: durationNumbers,
            intensities: intensityNumbers
        )
    }
    
    /// Calculate training density score
    func calculateTrainingDensityScore(
        durations: [TimeInterval],
        intensities: [UInt8]
    ) -> Double {
        let durationNumbers = durations.map { NSNumber(value: $0) }
        let intensityNumbers = intensities.map { NSNumber(value: $0) }
        
        return TennisAnalyzerBridge.calculateTrainingDensityScore(
            withDurations: durationNumbers,
            intensities: intensityNumbers
        )
    }
}

/// Swift-friendly wrapper for analysis results
extension TennisAnalysisResult {
    /// Formatted total active time string
    var formattedTotalActiveTime: String {
        let minutes = Int(totalActiveTime) / 60
        let seconds = Int(totalActiveTime) % 60
        if minutes > 0 {
            return String(format: "%dm %02ds", minutes, seconds)
        } else {
            return String(format: "%ds", seconds)
        }
    }
    
    /// Formatted consistency score (percentage)
    var formattedConsistencyScore: String {
        return String(format: "%.0f%%", consistencyScore * 100)
    }
    
    /// Formatted training density score (percentage)
    var formattedTrainingDensityScore: String {
        return String(format: "%.0f%%", trainingDensityScore * 100)
    }
    
    /// Consistency level description
    var consistencyLevel: String {
        switch consistencyScore {
        case 0.8...1.0:
            return "Very Consistent"
        case 0.6..<0.8:
            return "Consistent"
        case 0.4..<0.6:
            return "Moderate"
        case 0.2..<0.4:
            return "Inconsistent"
        default:
            return "Very Inconsistent"
        }
    }
    
    /// Training density level description
    var densityLevel: String {
        switch trainingDensityScore {
        case 0.8...1.0:
            return "Very High"
        case 0.6..<0.8:
            return "High"
        case 0.4..<0.6:
            return "Moderate"
        case 0.2..<0.4:
            return "Low"
        default:
            return "Very Low"
        }
    }
}

