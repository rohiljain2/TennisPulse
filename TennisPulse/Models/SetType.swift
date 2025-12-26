//
//  SetType.swift
//  TennisPulse
//
//  Created on [Date]
//

import Foundation

/// Represents the type of training set
enum SetType: String, CaseIterable, Codable {
    case rally = "Rally"
    case serve = "Serve"
    case drill = "Drill"
    
    var displayName: String {
        return rawValue
    }
    
    var icon: String {
        switch self {
        case .rally:
            return "figure.run"
        case .serve:
            return "arrow.up.circle.fill"
        case .drill:
            return "target"
        }
    }
}

