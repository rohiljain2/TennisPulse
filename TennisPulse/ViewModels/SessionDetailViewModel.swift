//
//  SessionDetailViewModel.swift
//  TennisPulse
//
//  Created on [Date]
//

import Foundation
import Combine
import SwiftUI

/// ViewModel for managing a single training session's details
@MainActor
class SessionDetailViewModel: ObservableObject {
    @Published var session: TrainingSession
    @Published var isEditing = false
    @Published var errorMessage: String?
    @Published var validationErrors: [String] = []
    
    private let service: TrainingSessionServiceProtocol
    
    init(session: TrainingSession, service: TrainingSessionServiceProtocol = TrainingSessionService.shared) {
        self.session = session
        self.service = service
        validateSession()
    }
    
    // MARK: - Set Management
    
    /// Starts a new set of the specified type
    /// - Parameter type: The type of set to start
    /// - Returns: True if successful, false if validation fails
    @discardableResult
    func startSet(type: SetType) -> Bool {
        // End any active set first
        endActiveSet()
        
        let newSet = TrainingSet(type: type)
        session.sets.append(newSet)
        
        if validateAndSave() {
            return true
        } else {
            // Remove the set if validation failed
            session.sets.removeLast()
            return false
        }
    }
    
    /// Ends the currently active set
    /// - Returns: True if successful, false if no active set or validation fails
    @discardableResult
    func endActiveSet() -> Bool {
        guard let activeSetIndex = session.sets.firstIndex(where: { $0.isActive }) else {
            errorMessage = "No active set to end"
            return false
        }
        
        let endTime = Date()
        session.sets[activeSetIndex].endTime = endTime
        
        // Validate the set after ending
        let updatedSet = session.sets[activeSetIndex]
        if !updatedSet.isValid {
            errorMessage = "Invalid set duration: \(updatedSet.validationErrors.joined(separator: ", "))"
            // Revert the change
            session.sets[activeSetIndex].endTime = nil
            return false
        }
        
        return validateAndSave()
    }
    
    /// Deletes a set from the session
    /// - Parameter set: The set to delete
    func deleteSet(_ set: TrainingSet) {
        guard let index = session.sets.firstIndex(where: { $0.id == set.id }) else {
            errorMessage = "Set not found"
            return
        }
        
        session.sets.remove(at: index)
        validateAndSave()
    }
    
    // MARK: - Session Management
    
    /// Updates the session notes
    /// - Parameter notes: The new notes text
    func updateNotes(_ notes: String) {
        // Validate notes length
        if notes.count > 5000 {
            errorMessage = "Notes cannot exceed 5000 characters"
            return
        }
        
        session.notes = notes.isEmpty ? nil : notes
        validateAndSave()
    }
    
    /// Validates and saves the session
    /// - Returns: True if validation passed and save was successful
    @discardableResult
    private func validateAndSave() -> Bool {
        validateSession()
        
        if !session.isValid {
            errorMessage = "Session validation failed: \(validationErrors.joined(separator: ", "))"
            return false
        }
        
        saveSession()
        errorMessage = nil
        return true
    }
    
    /// Validates the current session state
    private func validateSession() {
        validationErrors = session.validationErrors
    }
    
    /// Saves the session to the service
    func saveSession() {
        service.saveSession(session)
    }
    
    /// Deletes the session
    func deleteSession() {
        service.deleteSession(session)
    }
    
    // MARK: - Computed Properties
    
    var hasActiveSet: Bool {
        session.hasActiveSet
    }
    
    var activeSet: TrainingSet? {
        session.activeSet
    }
    
    var setsByType: [SetType: Int] {
        session.setsByType
    }
    
    var completedSetsCount: Int {
        session.completedSetsCount
    }
    
    var totalSetsCount: Int {
        session.totalSetsCount
    }
    
    var averageSetDuration: TimeInterval? {
        session.averageSetDuration
    }
    
    var formattedAverageDuration: String {
        guard let average = averageSetDuration else { return "N/A" }
        let minutes = Int(average) / 60
        let seconds = Int(average) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var isSessionValid: Bool {
        session.isValid
    }
    
    var isSessionCompleted: Bool {
        session.isCompleted
    }
}

