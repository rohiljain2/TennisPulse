//
//  TrainingSet.swift
//  TennisPulse
//
//  Created on [Date]
//

import Foundation

/// Represents a single training set within a session
struct TrainingSet: Identifiable, Codable, Equatable {
    let id: UUID
    var startTime: Date
    var endTime: Date?
    var type: SetType
    
    // MARK: - Duration Calculations
    
    /// Duration of the set in seconds (validated)
    var duration: TimeInterval? {
        guard let endTime = endTime else { return nil }
        let calculatedDuration = endTime.timeIntervalSince(startTime)
        
        // Validation: Duration must be positive
        guard calculatedDuration >= 0 else { return nil }
        
        return calculatedDuration
    }
    
    /// Duration in minutes (rounded)
    var durationInMinutes: Double? {
        guard let duration = duration else { return nil }
        return duration / 60.0
    }
    
    /// Duration in hours (rounded to 2 decimal places)
    var durationInHours: Double? {
        guard let duration = duration else { return nil }
        return (duration / 3600.0).rounded(toPlaces: 2)
    }
    
    /// Formatted duration string (MM:SS format)
    var formattedDuration: String {
        guard let duration = duration else { return "In Progress" }
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    /// Detailed formatted duration string (HH:MM:SS if needed)
    var detailedFormattedDuration: String {
        guard let duration = duration else { return "In Progress" }
        let totalSeconds = Int(duration)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    /// Short duration format (e.g., "5m 30s" or "1h 15m")
    var shortFormattedDuration: String {
        guard let duration = duration else { return "Active" }
        let totalSeconds = Int(duration)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        
        if hours > 0 {
            return String(format: "%dh %dm", hours, minutes)
        } else if minutes > 0 {
            return String(format: "%dm %ds", minutes, seconds)
        } else {
            return String(format: "%ds", seconds)
        }
    }
    
    // MARK: - State Properties
    
    /// Whether the set is currently active
    var isActive: Bool {
        return endTime == nil
    }
    
    /// Whether the set is completed
    var isCompleted: Bool {
        return endTime != nil && isValid
    }
    
    // MARK: - Validation
    
    /// Validates that the set has valid timing
    var isValid: Bool {
        // Active sets are always valid
        guard let endTime = endTime else { return true }
        
        // End time must be after start time
        guard endTime >= startTime else { return false }
        
        // Duration must be positive
        guard let duration = duration, duration >= 0 else { return false }
        
        // Minimum duration check (at least 1 second)
        guard duration >= 1.0 else { return false }
        
        // Maximum duration check (reasonable limit: 24 hours)
        guard duration <= 86400.0 else { return false }
        
        return true
    }
    
    /// Validation errors, if any
    var validationErrors: [String] {
        var errors: [String] = []
        
        if let endTime = endTime {
            if endTime < startTime {
                errors.append("End time cannot be before start time")
            }
            
            if let duration = duration {
                if duration < 1.0 {
                    errors.append("Duration must be at least 1 second")
                }
                if duration > 86400.0 {
                    errors.append("Duration exceeds maximum limit (24 hours)")
                }
            } else {
                errors.append("Invalid duration calculation")
            }
        }
        
        return errors
    }
    
    // MARK: - Initializers
    
    init(id: UUID = UUID(), startTime: Date = Date(), endTime: Date? = nil, type: SetType) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.type = type
    }
    
    /// Creates a completed set with specified duration
    static func completed(type: SetType, durationInSeconds: TimeInterval, startTime: Date = Date()) -> TrainingSet {
        let endTime = startTime.addingTimeInterval(durationInSeconds)
        return TrainingSet(startTime: startTime, endTime: endTime, type: type)
    }
}

// MARK: - Helper Extension

extension Double {
    /// Rounds the double to specified number of decimal places
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

