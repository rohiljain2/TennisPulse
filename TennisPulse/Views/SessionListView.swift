//
//  SessionListView.swift
//  TennisPulse
//
//  Created on [Date]
//

import SwiftUI

struct SessionListView: View {
    @StateObject private var viewModel = TrainingSessionViewModel()
    @State private var showingNewSession = false
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.sessions.isEmpty {
                    emptyStateView
                } else {
                    sessionList
                }
            }
            .navigationTitle("Training Sessions")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingNewSession = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewSession) {
                SessionDetailView(session: viewModel.createNewSession())
            }
        }
    }
    
    // MARK: - Views
    
    private var sessionList: some View {
        List {
            ForEach(groupedSessions.keys.sorted(by: >), id: \.self) { date in
                Section(header: Text(date, style: .date)) {
                    ForEach(groupedSessions[date] ?? []) { session in
                        NavigationLink {
                            SessionDetailView(session: session)
                        } label: {
                            SessionRowView(session: session)
                        }
                    }
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "figure.tennis")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Training Sessions")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Tap the + button to start your first training session")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
    
    // MARK: - Computed Properties
    
    private var groupedSessions: [Date: [TrainingSession]] {
        viewModel.sessionsGroupedByDate()
    }
}

// MARK: - Session Row View

struct SessionRowView: View {
    let session: TrainingSession
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(session.date, style: .time)
                    .font(.headline)
                
                Spacer()
                
                Text(session.formattedTotalDuration)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            HStack(spacing: 16) {
                ForEach(SetType.allCases, id: \.self) { type in
                    if let count = session.setsByType[type], count > 0 {
                        Label("\(count)", systemImage: type.icon)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            if session.hasActiveSet {
                HStack {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 8))
                        .foregroundColor(.green)
                    Text("Active")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

