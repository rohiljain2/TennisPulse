//
//  AnalyticsExampleView.swift
//  TennisPulse
//
//  Example Swift view showing how to use C++ analytics
//

import SwiftUI

struct AnalyticsExampleView: View {
    @StateObject private var viewModel = SessionAnalyticsViewModel()
    @State private var exampleDurations: [TimeInterval] = [300, 300, 300, 300, 300]
    @State private var exampleIntensities: [UInt8] = [3, 3, 3, 3, 3]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    exampleSection
                    
                    if let result = viewModel.analysisResult {
                        resultsSection(result: result)
                    }
                    
                    codeExampleSection
                }
                .padding()
            }
            .navigationTitle("C++ Analytics Example")
            .onAppear {
                analyzeExample()
            }
        }
    }
    
    // MARK: - View Components
    
    private var exampleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Example Analysis")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Durations: \(exampleDurations.map { "\(Int($0))s" }.joined(separator: ", "))")
                .font(.subheadline)
            
            Text("Intensities: \(exampleIntensities.map { "\($0)" }.joined(separator: ", "))")
                .font(.subheadline)
            
            Button("Re-analyze") {
                analyzeExample()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func resultsSection(result: TennisAnalysisResult) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Analysis Results")
                .font(.title2)
                .fontWeight(.bold)
            
            // Total Active Time
            MetricRow(
                title: "Total Active Time",
                value: result.formattedTotalActiveTime,
                icon: "clock.fill"
            )
            
            // Work/Rest Ratio
            MetricRow(
                title: "Work/Rest Ratio",
                value: String(format: "%.2f", result.workRestRatio),
                icon: "arrow.left.arrow.right"
            )
            
            // Consistency Score
            MetricRow(
                title: "Consistency Score",
                value: "\(result.formattedConsistencyScore) - \(result.consistencyLevel)",
                icon: "chart.line.uptrend.xyaxis"
            )
            
            // Training Density
            MetricRow(
                title: "Training Density",
                value: "\(result.formattedTrainingDensityScore) - \(result.densityLevel)",
                icon: "gauge.high"
            )
            
            // Average Intensity
            MetricRow(
                title: "Average Intensity",
                value: String(format: "%.1f / 5.0", result.averageIntensity),
                icon: "flame.fill"
            )
            
            // Total Work Volume
            MetricRow(
                title: "Total Work Volume",
                value: String(format: "%.0f", result.totalWorkVolume),
                icon: "chart.bar.fill"
            )
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var codeExampleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Swift Usage Example")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("""
            // 1. Get the analyzer service
            let analyzer = TennisAnalyzerService.shared
            
            // 2. Prepare your data
            let durations: [TimeInterval] = [300, 300, 300, 300, 300]
            let intensities: [UInt8] = [3, 3, 3, 3, 3]
            
            // 3. Analyze
            if let result = analyzer.analyze(
                durations: durations,
                intensities: intensities
            ) {
                print("Total Time: \\(result.formattedTotalActiveTime)")
                print("Consistency: \\(result.formattedConsistencyScore)")
                print("Density: \\(result.formattedTrainingDensityScore)")
            }
            
            // 4. Or use individual calculations
            let totalTime = analyzer.calculateTotalActiveTime(
                durations: durations
            )
            let consistency = analyzer.calculateConsistencyScore(
                durations: durations,
                intensities: intensities
            )
            """)
            .font(.system(.caption, design: .monospaced))
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(8)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    // MARK: - Methods
    
    private func analyzeExample() {
        let analyzer = TennisAnalyzerService.shared
        
        if let result = analyzer.analyze(
            durations: exampleDurations,
            intensities: exampleIntensities
        ) {
            viewModel.analysisResult = result
        }
    }
}

// MARK: - Metric Row

struct MetricRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.headline)
        }
    }
}

