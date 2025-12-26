//
//  SessionsAnalyticsView.swift
//  TennisPulse
//
//  View showing analytics across all sessions
//

import SwiftUI
import Charts

struct SessionsAnalyticsView: View {
    let sessions: [TrainingSession]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Training Density Chart
                    TrainingDensityChart(sessions: sessions)
                    
                    // Summary Stats
                    summaryStatsSection
                }
                .padding()
            }
            .navigationTitle("Analytics")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var summaryStatsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Summary")
                .font(.title2)
                .fontWeight(.bold)
            
            // Use sessions with at least one completed set (not just fully completed sessions)
            let sessionsWithData = sessions.filter { $0.completedSetsCount > 0 }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                // Total Sessions
                StatCard(
                    title: "Total Sessions",
                    value: "\(sessionsWithData.count)",
                    icon: "calendar",
                    color: .blue
                )
                
                // Total Training Time
                StatCard(
                    title: "Total Time",
                    value: formatTotalTime(sessionsWithData),
                    icon: "clock.fill",
                    color: .green
                )
                
                // Average Session Duration
                StatCard(
                    title: "Avg Duration",
                    value: formatAverageDuration(sessionsWithData),
                    icon: "timer",
                    color: .orange
                )
                
                // Total Sets
                StatCard(
                    title: "Total Sets",
                    value: "\(totalSets(sessionsWithData))",
                    icon: "list.bullet",
                    color: .purple
                )
            }
        }
    }
    
    private func formatTotalTime(_ sessions: [TrainingSession]) -> String {
        let total = sessions.reduce(0.0) { $0 + $1.totalDuration }
        
        guard total > 0 else { return "0m" }
        
        let hours = Int(total) / 3600
        let minutes = (Int(total) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else if minutes > 0 {
            return "\(minutes)m"
        } else {
            let seconds = Int(total) % 60
            return "\(seconds)s"
        }
    }
    
    private func formatAverageDuration(_ sessions: [TrainingSession]) -> String {
        guard !sessions.isEmpty else { return "0m" }
        
        let total = sessions.reduce(0.0) { $0 + $1.totalDuration }
        guard total > 0 else { return "0m" }
        
        let average = total / Double(sessions.count)
        let minutes = Int(average) / 60
        let seconds = Int(average) % 60
        
        if minutes > 0 {
            return "\(minutes)m"
        } else if seconds > 0 {
            return "\(seconds)s"
        } else {
            return "0m"
        }
    }
    
    private func totalSets(_ sessions: [TrainingSession]) -> Int {
        sessions.reduce(0) { $0 + $1.completedSetsCount }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 44, height: 44)
                .background(color.opacity(0.1))
                .clipShape(Circle())
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
}

