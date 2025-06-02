//
//  HealthMetric.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 02/06/25.
//

import HealthKit

enum HealthMetric {
    case steps, calories, distance, flights

    var identifier: HKQuantityTypeIdentifier {
        switch self {
        case .steps: return .stepCount
        case .calories: return .activeEnergyBurned
        case .distance: return .distanceWalkingRunning
        case .flights: return .flightsClimbed
        }
    }

    var unit: HKUnit {
        switch self {
        case .steps, .flights: return .count()
        case .calories: return .kilocalorie()
        case .distance: return .meter()
        }
    }
}
