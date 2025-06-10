//
//  WorkoutViewModel.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 08/06/25.
//


import Foundation
import HealthKit

class WorkoutViewModel: ObservableObject {
    private let manager = HealthKitManager.shared

    @Published var workouts: [HKWorkout] = []

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

    func fetchRecentWorkouts() {
        let now = Date()
        let oneYearAgo = Calendar.current.date(byAdding: .year, value: -1, to: now)!

        manager.fetchDailyWorkouts(startDate: oneYearAgo, endDate: now) { workouts in
            self.workouts = workouts.sorted { $0.startDate > $1.startDate }
        }
    }

    func fetchDailyWorkouts() {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!

        manager.fetchDailyWorkouts(startDate: startOfDay, endDate: endOfDay) {
            self.workouts = $0
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
