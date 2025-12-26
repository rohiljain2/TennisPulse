//
//  TrainingDensityChart.swift
//  TennisPulse
//
//  Chart showing training density over multiple sessions
//

import SwiftUI
import Charts

struct TrainingDensityChart: View {
    let sessions: [TrainingSession]
    let analyzerService = TennisAnalyzerService.shared
    
    private var chartData: [SessionDensityData] {
        sessions
            .filter { $0.isCompleted }
            .sorted { $0.date < $1.date }
            .compactMap { session -> SessionDensityData? in
                let durations = session.sets
                    .filter { $0.isCompleted && $0.isValid }
                    .compactMap { $0.duration }
                
                guard !durations.isEmpty else { return nil }
                
                let intensities = Array(repeating: UInt8(3), count: durations.count)
                let densityScore = analyzerService.calculateTrainingDensityScore(
                    durations: durations,
                    intensities: intensities
                )
                
                return SessionDensityData(
                    date: session.date,
                    densityScore: densityScore,
                    sessionId: session.id
                )
            }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Training Density Over Time")
                .font(.headline)
                .foregroundColor(.primary)
            
            if chartData.isEmpty {
                Text("No completed sessions to display")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 40)
            } else {
                Chart(chartData) { data in
                    LineMark(
                        x: .value("Date", data.date, unit: .day),
                        y: .value("Density", data.densityScore)
                    )
                    .foregroundStyle(.purple)
                    .interpolationMethod(.catmullRom)
                    
                    AreaMark(
                        x: .value("Date", data.date, unit: .day),
                        y: .value("Density", data.densityScore)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.purple.opacity(0.3), .purple.opacity(0.05)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .interpolationMethod(.catmullRom)
                    
                    PointMark(
                        x: .value("Date", data.date, unit: .day),
                        y: .value("Density", data.densityScore)
                    )
                    .foregroundStyle(.purple)
                    .symbolSize(60)
                }
                .chartXAxis {
                    AxisMarks(values: .automatic) { value in
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.month().day())
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisGridLine()
                        AxisValueLabel {
                            if let score = value.as(Double.self) {
                                Text(String(format: "%.0f%%", score * 100))
                            }
                        }
                    }
                }
                .chartYScale(domain: 0...1)
                .frame(height: 200)
                
                // Summary stats
                HStack(spacing: 20) {
                    if let average = averageDensity {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Average")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(String(format: "%.0f%%", average * 100))
                                .font(.headline)
                        }
                    }
                    
                    if let trend = densityTrend {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Trend")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            HStack(spacing: 4) {
                                Image(systemName: trend > 0 ? "arrow.up.right" : "arrow.down.right")
                                    .font(.caption)
                                Text(String(format: "%.1f%%", abs(trend) * 100))
                                    .font(.headline)
                            }
                            .foregroundColor(trend > 0 ? .green : .red)
                        }
                    }
                }
                .padding(.top, 8)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
    
    private var averageDensity: Double? {
        guard !chartData.isEmpty else { return nil }
        let sum = chartData.reduce(0.0) { $0 + $1.densityScore }
        return sum / Double(chartData.count)
    }
    
    private var densityTrend: Double? {
        guard chartData.count >= 2 else { return nil }
        let firstHalf = Array(chartData.prefix(chartData.count / 2))
        let secondHalf = Array(chartData.suffix(chartData.count / 2))
        
        let firstAvg = firstHalf.reduce(0.0) { $0 + $1.densityScore } / Double(firstHalf.count)
        let secondAvg = secondHalf.reduce(0.0) { $0 + $1.densityScore } / Double(secondHalf.count)
        
        return secondAvg - firstAvg
    }
}

struct SessionDensityData: Identifiable {
    let id: UUID
    let date: Date
    let densityScore: Double
    
    init(date: Date, densityScore: Double, sessionId: UUID) {
        self.id = sessionId
        self.date = date
        self.densityScore = densityScore
    }
}

