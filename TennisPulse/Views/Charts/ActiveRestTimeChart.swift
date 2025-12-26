//
//  ActiveRestTimeChart.swift
//  TennisPulse
//
//  Chart showing active time vs rest time
//

import SwiftUI
import Charts

struct ActiveRestTimeChart: View {
    let session: TrainingSession
    
    private var chartData: [TimeCategoryData] {
        let totalActive = session.totalDuration
        let totalRest = session.restDurations.reduce(0, +)
        
        var data: [TimeCategoryData] = []
        
        if totalActive > 0 {
            data.append(TimeCategoryData(
                category: "Active Time",
                duration: totalActive,
                color: .blue
            ))
        }
        
        if totalRest > 0 {
            data.append(TimeCategoryData(
                category: "Rest Time",
                duration: totalRest,
                color: .orange
            ))
        }
        
        return data
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Active vs Rest Time")
                .font(.headline)
                .foregroundColor(.primary)
            
            if chartData.isEmpty {
                Text("No time data to display")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 40)
            } else {
                Chart(chartData) { data in
                    BarMark(
                        x: .value("Category", data.category),
                        y: .value("Duration", data.duration)
                    )
                    .foregroundStyle(data.color)
                    .cornerRadius(8)
                }
                .chartXAxis {
                    AxisMarks(values: .automatic) { _ in
                        AxisGridLine()
                        AxisValueLabel()
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisGridLine()
                        AxisValueLabel {
                            if let duration = value.as(Double.self) {
                                Text(formatDuration(duration))
                            }
                        }
                    }
                }
                .frame(height: 200)
                
                // Legend
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(chartData) { data in
                        HStack {
                            Circle()
                                .fill(data.color)
                                .frame(width: 12, height: 12)
                            Text(data.category)
                                .font(.subheadline)
                            Spacer()
                            Text(formatDuration(data.duration))
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
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
    
    private func formatDuration(_ duration: TimeInterval) -> String {
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
}

struct TimeCategoryData: Identifiable {
    let id = UUID()
    let category: String
    let duration: TimeInterval
    let color: Color
}

