//
//  TrainingSessionViewModel.swift
//  TennisPulse
//
//  Created on [Date]
//

import Foundation
import Combine
import SwiftUI

/// ViewModel for managing training sessions
@MainActor
class TrainingSessionViewModel: ObservableObject {
    @Published var sessions: [TrainingSession] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service: TrainingSessionServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(service: TrainingSessionServiceProtocol = TrainingSessionService.shared) {
        self.service = service
        
        if let observableService = service as? TrainingSessionService {
            observableService.$sessions
                .receive(on: DispatchQueue.main)
                .sink { [weak self] sessions in
                    self?.sessions = sessions
                }
                .store(in: &cancellables)
        }
        
        loadSessions()
    }
    
    // MARK: - Public Methods
    
    func loadSessions() {
        isLoading = true
        sessions = service.fetchAllSessions()
        isLoading = false
    }
    
    func createNewSession() -> TrainingSession {
        return TrainingSession()
    }
    
    func saveSession(_ session: TrainingSession) {
        service.saveSession(session)
        loadSessions()
    }
    
    func deleteSession(_ session: TrainingSession) {
        service.deleteSession(session)
        loadSessions()
    }
    
    func updateSession(_ session: TrainingSession) {
        service.updateSession(session)
        loadSessions()
    }
    
    /// Get sessions grouped by date
    func sessionsGroupedByDate() -> [Date: [TrainingSession]] {
        Dictionary(grouping: sessions) { session in
            Calendar.current.startOfDay(for: session.date)
        }
    }
}

