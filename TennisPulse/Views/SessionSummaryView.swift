//
//  SessionSummaryView.swift
//  TennisPulse
//
//  Created on [Date]
//

import SwiftUI

struct SessionSummaryView: View {
    @StateObject private var viewModel: SessionDetailViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(session: TrainingSession) {
        _viewModel = StateObject(wrappedValue: SessionDetailViewModel(session: session))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    sessionHeader
                    metricsSection
                    setsBreakdown
                    if let notes = viewModel.session.notes, !notes.isEmpty {
                        notesSection
                    }
                }
                .padding()
            }
            .navigationTitle("Session Summary")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(role: .destructive) {
                            viewModel.deleteSession()
                            dismiss()
                        } label: {
                            Label("Delete Session", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
    }
    
    // MARK: - View Components
    
    private var sessionHeader: some View {
        VStack(spacing: 16) {
            // Date
            Text(viewModel.session.date, style: .date)
                .font(.title)
                .fontWeight(.bold)
            
            // Time
            Text(viewModel.session.date, style: .time)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Divider()
            
            // Total duration
            VStack(spacing: 8) {
                Text(viewModel.session.formattedTotalDuration)
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundColor(.primary)
                
                Text("Total Duration")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemGray6))
        )
    }
    
    private var metricsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Metrics")
                .font(.title2)
                .fontWeight(.bold)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                // Total Sets
                MetricCard(
                    title: "Total Sets",
                    value: "\(viewModel.totalSetsCount)",
                    icon: "list.bullet",
                    color: .blue
                )
                
                // Completed Sets
                MetricCard(
                    title: "Completed",
                    value: "\(viewModel.completedSetsCount)",
                    icon: "checkmark.circle.fill",
                    color: .green
                )
                
                // Average Duration
                MetricCard(
                    title: "Avg Duration",
                    value: viewModel.formattedAverageDuration,
                    icon: "clock.fill",
                    color: .orange
                )
                
                // Sets by Type
                if let longest = viewModel.session.longestSetDuration {
                    MetricCard(
                        title: "Longest Set",
                        value: formatDuration(longest),
                        icon: "arrow.up.circle.fill",
                        color: .purple
                    )
                }
            }
        }
    }
    
    private var setsBreakdown: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Sets Breakdown")
                .font(.title2)
                .fontWeight(.bold)
            
            ForEach(SetType.allCases, id: \.self) { type in
                if let count = viewModel.setsByType[type], count > 0 {
                    SetTypeCard(
                        type: type,
                        count: count,
                        totalDuration: viewModel.session.setsByTypeWithDuration[type] ?? 0
                    )
                }
            }
        }
    }
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Notes")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(viewModel.session.notes ?? "")
                .font(.body)
                .foregroundColor(.primary)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                )
        }
    }
    
    // MARK: - Helper Methods
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - Metric Card

struct MetricCard: View {
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

// MARK: - Set Type Card

struct SetTypeCard: View {
    let type: SetType
    let count: Int
    let totalDuration: TimeInterval
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            Image(systemName: type.icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 50, height: 50)
                .background(Color.blue.opacity(0.1))
                .clipShape(Circle())
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(type.displayName)
                    .font(.headline)
                
                Text("\(count) set\(count == 1 ? "" : "s")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Duration
            VStack(alignment: .trailing, spacing: 4) {
                Text(formatDuration(totalDuration))
                    .font(.headline)
                    .monospacedDigit()
                
                Text("Total")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        if minutes > 0 {
            return String(format: "%dm %02ds", minutes, seconds)
        } else {
            return String(format: "%ds", seconds)
        }
    }
}

