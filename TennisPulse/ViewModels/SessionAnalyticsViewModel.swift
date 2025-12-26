//
//  SessionAnalyticsViewModel.swift
//  TennisPulse
//
//  ViewModel for session analytics using C++ engine
//

import Foundation
import Combine
import SwiftUI

/// ViewModel for analyzing training sessions with C++ analytics
@MainActor
class SessionAnalyticsViewModel: ObservableObject {
    @Published var analysisResult: TennisAnalysisResult?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let analyzerService = TennisAnalyzerService.shared
    
    /// Analyze a training session
    func analyzeSession(_ session: TrainingSession) {
        isLoading = true
        errorMessage = nil
        
        // Extract durations and intensities from sets
        let durations = session.sets
            .filter { $0.isCompleted && $0.isValid }
            .compactMap { $0.duration }
        
        // For now, use default intensity of 3 (moderate) for all sets
        // In a real app, you'd store intensity with each set
        let intensities = Array(repeating: UInt8(3), count: durations.count)
        
        guard !durations.isEmpty, durations.count == intensities.count else {
            errorMessage = "No valid sets to analyze"
            isLoading = false
            return
        }
        
        // Calculate rest durations from gaps between sets
        let restDurations = session.restDurations
        
        // Perform analysis
        analysisResult = analyzerService.analyze(
            durations: durations,
            intensities: intensities,
            restDurations: restDurations.isEmpty ? nil : restDurations
        )
        
        if analysisResult == nil {
            errorMessage = "Failed to analyze session"
        }
        
        isLoading = false
    }
    
    /// Calculate individual metrics
    func calculateMetrics(for session: TrainingSession) -> SessionMetrics {
        let durations = session.sets
            .filter { $0.isCompleted && $0.isValid }
            .compactMap { $0.duration }
        
        let intensities = Array(repeating: UInt8(3), count: durations.count)
        
        guard !durations.isEmpty else {
            return SessionMetrics()
        }
        
        // Calculate rest durations from gaps between sets
        let restDurations = session.restDurations
        
        return SessionMetrics(
            totalActiveTime: analyzerService.calculateTotalActiveTime(durations: durations),
            workRestRatio: analyzerService.calculateWorkRestRatio(
                durations: durations,
                restDurations: restDurations.isEmpty ? nil : restDurations
            ),
            consistencyScore: analyzerService.calculateConsistencyScore(
                durations: durations,
                intensities: intensities
            ),
            trainingDensityScore: analyzerService.calculateTrainingDensityScore(
                durations: durations,
                intensities: intensities
            )
        )
    }
}

/// Metrics structure for session analysis
struct SessionMetrics {
    var totalActiveTime: TimeInterval = 0
    var workRestRatio: Double = 0
    var consistencyScore: Double = 0
    var trainingDensityScore: Double = 0
}

