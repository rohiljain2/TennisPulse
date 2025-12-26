//
//  TrainingSessionService.swift
//  TennisPulse
//
//  Created on [Date]
//

import Foundation
import Combine

/// Service responsible for managing training session data persistence
protocol TrainingSessionServiceProtocol {
    func fetchAllSessions() -> [TrainingSession]
    func saveSession(_ session: TrainingSession)
    func deleteSession(_ session: TrainingSession)
    func updateSession(_ session: TrainingSession)
}

class TrainingSessionService: TrainingSessionServiceProtocol, ObservableObject {
    static let shared = TrainingSessionService()
    
    @Published var sessions: [TrainingSession] = []
    
    private let userDefaultsKey = "trainingSessions"
    
    private init() {
        loadSessions()
    }
    
    // MARK: - Public Methods
    
    func fetchAllSessions() -> [TrainingSession] {
        return sessions.sorted { $0.date > $1.date }
    }
    
    func saveSession(_ session: TrainingSession) {
        if let index = sessions.firstIndex(where: { $0.id == session.id }) {
            sessions[index] = session
        } else {
            sessions.append(session)
        }
        persistSessions()
    }
    
    func deleteSession(_ session: TrainingSession) {
        sessions.removeAll { $0.id == session.id }
        persistSessions()
    }
    
    func updateSession(_ session: TrainingSession) {
        saveSession(session)
    }
    
    // MARK: - Private Methods
    
    private func loadSessions() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let decoded = try? JSONDecoder().decode([TrainingSession].self, from: data) else {
            sessions = []
            return
        }
        sessions = decoded
    }
    
    private func persistSessions() {
        if let encoded = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
}

