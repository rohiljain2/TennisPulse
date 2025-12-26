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
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if !viewModel.sessions.isEmpty {
                        NavigationLink {
                            SessionsAnalyticsView(sessions: viewModel.sessions)
                        } label: {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .font(.title3)
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingNewSession = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
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
                Section(header: sectionHeader(for: date)) {
                    ForEach(groupedSessions[date] ?? []) { session in
                        NavigationLink {
                            if session.isCompleted {
                                SessionSummaryView(session: session)
                            } else {
                                SessionDetailView(session: session)
                            }
                        } label: {
                            SessionRowView(session: session)
                        }
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }
    
    private func sectionHeader(for date: Date) -> some View {
        HStack {
            Text(date, style: .date)
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
        }
        .textCase(nil)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "figure.tennis")
                .font(.system(size: 80))
                .foregroundStyle(.tertiary)
            
            VStack(spacing: 8) {
                Text("No Training Sessions")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Start tracking your tennis training sessions")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button {
                showingNewSession = true
            } label: {
                Label("Start First Session", systemImage: "plus.circle.fill")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.accentColor)
                    .cornerRadius(12)
            }
            .padding(.top, 8)
        }
        .padding(.horizontal, 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
        HStack(spacing: 12) {
            // Time indicator
            VStack(alignment: .leading, spacing: 4) {
                Text(session.date, style: .time)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if session.hasActiveSet {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 6, height: 6)
                        Text("Active")
                            .font(.caption2)
                            .foregroundColor(.green)
                    }
                }
            }
            .frame(width: 70, alignment: .leading)
            
            // Set type badges
            HStack(spacing: 6) {
                ForEach(SetType.allCases, id: \.self) { type in
                    if let count = session.setsByType[type], count > 0 {
                        HStack(spacing: 3) {
                            Image(systemName: type.icon)
                                .font(.caption2)
                            Text("\(count)")
                                .font(.caption)
                                .fontWeight(.medium)
                                .fixedSize(horizontal: true, vertical: false)
                        }
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 4)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                }
            }
            .layoutPriority(1)
            
            Spacer(minLength: 8)
            
            // Duration
            VStack(alignment: .trailing, spacing: 2) {
                Text(session.formattedTotalDuration)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if session.completedSetsCount > 0 {
                    Text("\(session.completedSetsCount) sets")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

