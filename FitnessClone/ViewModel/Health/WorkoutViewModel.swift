//
//  WorkoutViewModel.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 08/06/25.
//


import Foundation
import HealthKit

class WorkoutViewModel: ObservableObject {

    @Published var workouts: [HKWorkout] = []

    private let manager = HealthKitManager.shared
    
    init() {
        fetchAllWorkouts()
    }

    
    func fetchAllWorkouts() {
        let startDate = Date.distantPast
        let endDate = Date()

        manager.fetchDailyWorkouts(startDate: startDate, endDate: endDate) { workouts in
            self.workouts = workouts.sorted { $0.startDate > $1.startDate }
        }
    }
    
    
    func workoutMetrics(for workout: HKWorkout) -> WorkoutMetrics {
        let duration = workout.duration
        let distance = workout.totalDistance?.doubleValue(for: .meter()) ?? 0

        let activeKilocalories: Double = {
            if #available(iOS 18.0, *) {
                return workout.statistics(for: HKQuantityType(.activeEnergyBurned))?
                    .sumQuantity()?
                    .doubleValue(for: .kilocalorie()) ?? 0
            } else {
                return workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0
            }
        }()

        let totalKilocalories: Double = {
            let basal: Double
            if #available(iOS 18.0, *) {
                basal = workout.statistics(for: HKQuantityType(.basalEnergyBurned))?
                    .sumQuantity()?
                    .doubleValue(for: .kilocalorie()) ?? 0
            } else {
                basal = 0
            }
            return activeKilocalories + basal
        }()

        let averageHeartRate: Double = {
            if #available(iOS 18.0, *) {
                return workout.statistics(for: HKQuantityType(.heartRate))?
                    .averageQuantity()?
                    .doubleValue(for: HKUnit.count().unitDivided(by: .minute())) ?? 0
            } else {
                return 0
            }
        }()

        let averagePace: Double = {
            let distanceKm = distance / 1000
            let durationMinutes = duration / 60
            return distanceKm > 0 ? durationMinutes / distanceKm : 0
        }()

        return WorkoutMetrics(
            duration: duration,
            distance: distance,
            activeKilocalories: activeKilocalories,
            totalKilocalories: totalKilocalories,
            averagePace: averagePace,
            averageHeartRate: averageHeartRate
        )
    }
    
}
