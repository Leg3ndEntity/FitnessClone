//
//  HKWorkoutActivityType.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 03/06/25.
//

import Foundation
import HealthKit

extension HKWorkoutActivityType {
    var name: String {
        switch self {
        case .americanFootball: return "American Football"
        case .archery: return "Archery"
        case .australianFootball: return "Australian Football"
        case .badminton: return "Badminton"
        case .baseball: return "Baseball"
        case .basketball: return "Basketball"
        case .boxing: return "Boxing"
        case .climbing: return "Climbing"
        case .crossTraining: return "Cross Training"
        case .cycling: return "Cycling"
        case .dance: return "Dance"
        case .elliptical: return "Elliptical"
        case .fencing: return "Fencing"
        case .fishing: return "Fishing"
        case .functionalStrengthTraining: return "Functional Strength"
        case .golf: return "Golf"
        case .gymnastics: return "Gymnastics"
        case .handball: return "Handball"
        case .hiking: return "Hiking"
        case .hockey: return "Hockey"
        case .jumpRope: return "Jump Rope"
        case .martialArts: return "Martial Arts"
        case .mindAndBody: return "Mind & Body"
        case .paddleSports: return "Paddle Sports"
        case .pilates: return "Pilates"
        case .rowing: return "Rowing"
        case .rugby: return "Rugby"
        case .running: return "Running"
        case .sailing: return "Sailing"
        case .skatingSports: return "Skating"
        case .snowSports: return "Snow Sports"
        case .soccer: return "Soccer"
        case .softball: return "Softball"
        case .squash: return "Squash"
        case .stairClimbing: return "Stair Climbing"
        case .surfingSports: return "Surfing"
        case .swimming: return "Swimming"
        case .tableTennis: return "Table Tennis"
        case .tennis: return "Tennis"
        case .trackAndField: return "Track & Field"
        case .volleyball: return "Volleyball"
        case .walking: return "Walking"
        case .waterFitness: return "Water Fitness"
        case .waterPolo: return "Water Polo"
        case .wheelchairWalkPace: return "Wheelchair Walk"
        case .wheelchairRunPace: return "Wheelchair Run"
        case .yoga: return "Yoga"
        case .other: return "Other"
        default: return "Unknown"
        }
    }
}

