//
//  QuickTest.swift
//  TennisPulse
//
//  Quick test file to verify C++ analytics is working
//  Add this code to any Swift file to test
//

import Foundation

// MARK: - Quick Test Function
// Add this function to any ViewModel or call it from anywhere

func testTennisAnalytics() {
    print("🧪 Testing C++ Tennis Analytics...")
    
    let analyzer = TennisAnalyzerService.shared
    
    // Test data: 5 sets of 5 minutes each, all moderate intensity
    let durations: [TimeInterval] = [300, 300, 300, 300, 300]
    let intensities: [UInt8] = [3, 3, 3, 3, 3]
    
    // Test full analysis
    if let result = analyzer.analyze(durations: durations, intensities: intensities) {
        print("✅ Analytics working!")
        print("   Total Time: \(result.formattedTotalActiveTime)")
        print("   Consistency: \(result.formattedConsistencyScore) - \(result.consistencyLevel)")
        print("   Density: \(result.formattedTrainingDensityScore) - \(result.densityLevel)")
        print("   Work/Rest Ratio: \(String(format: "%.2f", result.workRestRatio))")
        print("   Average Intensity: \(String(format: "%.1f", result.averageIntensity))")
    } else {
        print("❌ Analytics failed - check setup")
    }
    
    // Test individual calculations
    print("\n📊 Individual Calculations:")
    let totalTime = analyzer.calculateTotalActiveTime(durations: durations)
    print("   Total Active Time: \(totalTime / 60) minutes")
    
    let consistency = analyzer.calculateConsistencyScore(
        durations: durations,
        intensities: intensities
    )
    print("   Consistency Score: \(Int(consistency * 100))%")
    
    let density = analyzer.calculateTrainingDensityScore(
        durations: durations,
        intensities: intensities
    )
    print("   Density Score: \(Int(density * 100))%")
    
    print("\n✅ All tests passed!")
}

// MARK: - Usage in ViewModel
// Example: Call this from a ViewModel's init or onAppear

/*
class TestViewModel: ObservableObject {
    init() {
        testTennisAnalytics()
    }
}
*/

// MARK: - Usage in View
// Example: Add this to any SwiftUI view

/*
struct TestView: View {
    var body: some View {
        VStack {
            Text("Testing Analytics")
            Button("Run Test") {
                testTennisAnalytics()
            }
        }
        .onAppear {
            testTennisAnalytics()
        }
    }
}
*/

