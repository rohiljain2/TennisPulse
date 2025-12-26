//
//  TrainingSession.swift
//  TennisPulse
//
//  Created on [Date]
//

import Foundation

/// Represents a complete training session containing multiple sets
struct TrainingSession: Identifiable, Codable, Equatable {
    let id: UUID
    var date: Date
    var sets: [TrainingSet]
    var notes: String?
    
    // MARK: - Duration Calculations
    
    /// Total duration of all completed sets in seconds (validated)
    var totalDuration: TimeInterval {
        sets
            .filter { $0.isCompleted && $0.isValid }
            .compactMap { $0.duration }
            .reduce(0, +)
    }
    
    /// Average duration per set in seconds
    var averageSetDuration: TimeInterval? {
        let completedSets = sets.filter { $0.isCompleted && $0.isValid }
        guard !completedSets.isEmpty else { return nil }
        
        let total = completedSets.compactMap { $0.duration }.reduce(0, +)
        return total / Double(completedSets.count)
    }
    
    /// Longest set duration in seconds
    var longestSetDuration: TimeInterval? {
        sets
            .filter { $0.isCompleted && $0.isValid }
            .compactMap { $0.duration }
            .max()
    }
    
    /// Shortest set duration in seconds
    var shortestSetDuration: TimeInterval? {
        sets
            .filter { $0.isCompleted && $0.isValid }
            .compactMap { $0.duration }
            .min()
    }
    
    /// Formatted total duration string (HH:MM:SS or MM:SS)
    var formattedTotalDuration: String {
        let totalSeconds = Int(totalDuration)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    /// Short formatted duration (e.g., "2h 30m" or "45m")
    var shortFormattedDuration: String {
        let totalSeconds = Int(totalDuration)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        
        if hours > 0 {
            return String(format: "%dh %dm", hours, minutes)
        } else if minutes > 0 {
            return String(format: "%dm", minutes)
        } else {
            return String(format: "%ds", totalSeconds)
        }
    }
    
    /// Total duration in hours (rounded to 2 decimal places)
    var totalDurationInHours: Double {
        (totalDuration / 3600.0).rounded(toPlaces: 2)
    }
    
    /// Total duration in minutes (rounded)
    var totalDurationInMinutes: Double {
        (totalDuration / 60.0).rounded()
    }
    
    // MARK: - Set Statistics
    
    /// Number of sets by type
    var setsByType: [SetType: Int] {
        Dictionary(grouping: sets, by: { $0.type })
            .mapValues { $0.count }
    }
    
    /// Number of completed sets
    var completedSetsCount: Int {
        sets.filter { $0.isCompleted && $0.isValid }.count
    }
    
    /// Number of active sets
    var activeSetsCount: Int {
        sets.filter { $0.isActive }.count
    }
    
    /// Total number of sets
    var totalSetsCount: Int {
        sets.count
    }
    
    /// Sets grouped by type with durations
    var setsByTypeWithDuration: [SetType: TimeInterval] {
        Dictionary(grouping: sets.filter { $0.isCompleted && $0.isValid }, by: { $0.type })
            .mapValues { sets in
                sets.compactMap { $0.duration }.reduce(0, +)
            }
    }
    
    /// Calculate rest durations between sets based on time gaps
    /// Returns an array of rest durations in seconds, one for each gap between consecutive sets
    var restDurations: [TimeInterval] {
        let completedSets = sets
            .filter { $0.isCompleted && $0.isValid }
            .sorted { $0.startTime < $1.startTime }
        
        guard completedSets.count > 1 else {
            return []
        }
        
        var restDurations: [TimeInterval] = []
        
        for i in 0..<(completedSets.count - 1) {
            let currentSet = completedSets[i]
            let nextSet = completedSets[i + 1]
            
            // Rest duration is the gap between end of current set and start of next set
            guard let currentEndTime = currentSet.endTime else { continue }
            
            let restDuration = nextSet.startTime.timeIntervalSince(currentEndTime)
            
            // Only count positive rest durations (ignore overlapping sets)
            if restDuration > 0 {
                restDurations.append(restDuration)
            } else {
                // If sets overlap or start immediately, assume minimal rest (1 second)
                restDurations.append(1.0)
            }
        }
        
        return restDurations
    }
    
    // MARK: - State Properties
    
    /// Whether the session has any active sets
    var hasActiveSet: Bool {
        sets.contains { $0.isActive }
    }
    
    /// The currently active set, if any
    var activeSet: TrainingSet? {
        sets.first { $0.isActive }
    }
    
    /// Whether the session is completed (no active sets)
    var isCompleted: Bool {
        !hasActiveSet && !sets.isEmpty
    }
    
    // MARK: - Validation
    
    /// Validates that all sets in the session are valid
    var isValid: Bool {
        // All sets must be valid
        guard sets.allSatisfy({ $0.isValid }) else { return false }
        
        // Notes should not exceed reasonable length (optional validation)
        if let notes = notes, notes.count > 5000 {
            return false
        }
        
        return true
    }
    
    /// Validation errors for the session
    var validationErrors: [String] {
        var errors: [String] = []
        
        // Check each set
        for (index, set) in sets.enumerated() {
            let setErrors = set.validationErrors
            if !setErrors.isEmpty {
                errors.append("Set \(index + 1): \(setErrors.joined(separator: ", "))")
            }
        }
        
        // Check notes length
        if let notes = notes, notes.count > 5000 {
            errors.append("Notes exceed maximum length (5000 characters)")
        }
        
        // Check for duplicate active sets (should only be one)
        let activeSets = sets.filter { $0.isActive }
        if activeSets.count > 1 {
            errors.append("Multiple active sets found (only one allowed)")
        }
        
        return errors
    }
    
    // MARK: - Initializers
    
    init(id: UUID = UUID(), date: Date = Date(), sets: [TrainingSet] = [], notes: String? = nil) {
        self.id = id
        self.date = date
        self.sets = sets
        self.notes = notes
    }
    
    /// Creates a session with today's date
    static func today(sets: [TrainingSet] = [], notes: String? = nil) -> TrainingSession {
        TrainingSession(date: Date(), sets: sets, notes: notes)
    }
}

