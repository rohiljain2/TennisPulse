//
//  SetDurationConsistencyChart.swift
//  TennisPulse
//
//  Chart showing set duration consistency
//

import SwiftUI
import Charts

struct SetDurationConsistencyChart: View {
    let sets: [TrainingSet]
    
    private var chartData: [SetDurationData] {
        sets
            .filter { $0.isCompleted && $0.isValid }
            .enumerated()
            .compactMap { index, set in
                guard let duration = set.duration else { return nil }
                return SetDurationData(
                    setNumber: index + 1,
                    duration: duration,
                    type: set.type
                )
            }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Set Duration Consistency")
                .font(.headline)
                .foregroundColor(.primary)
            
            if chartData.isEmpty {
                Text("No completed sets to display")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 40)
            } else {
                Chart(chartData) { data in
                    BarMark(
                        x: .value("Set", "Set \(data.setNumber)"),
                        y: .value("Duration", data.duration),
                        width: .fixed(30)
                    )
                    .foregroundStyle(by: .value("Type", data.type.displayName))
                    .cornerRadius(4)
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
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        if minutes > 0 {
            return "\(minutes)m"
        } else {
            return "\(seconds)s"
        }
    }
}

struct SetDurationData: Identifiable {
    let id = UUID()
    let setNumber: Int
    let duration: TimeInterval
    let type: SetType
}

