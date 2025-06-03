//
//  HealthKitManager.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 02/06/25.
//

import Foundation
import HealthKit

class HealthKitManager {
    static let shared = HealthKitManager()
    private let healthStore = HKHealthStore()

    private init() {}

    var readTypes: Set<HKObjectType> {
        return [
            HKQuantityType.quantityType(forIdentifier: .stepCount)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKQuantityType.quantityType(forIdentifier: .flightsClimbed)!,
            HKObjectType.workoutType()
        ]
    }

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false)
            return
        }

        healthStore.requestAuthorization(toShare: [], read: readTypes) { success, _ in
            DispatchQueue.main.async {
                if success {
                    completion(success)
                }else{
                    completion(false)
                }
            }
        }
    }

    func fetchSum(for identifier: HKQuantityTypeIdentifier, completion: @escaping (Double) -> Void) {
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else {
            completion(0)
            return
        }

        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            let value = result?.sumQuantity()?.doubleValue(for: self.unit(for: identifier)) ?? 0
            DispatchQueue.main.async {
                completion(value)
            }
        }

        healthStore.execute(query)
    }
    
    private func unit(for identifier: HKQuantityTypeIdentifier) -> HKUnit {
        switch identifier {
        case .stepCount: return HKUnit.count()
        case .activeEnergyBurned: return HKUnit.kilocalorie()
        case .distanceWalkingRunning: return HKUnit.meter()
        case .flightsClimbed: return HKUnit.count()
        default: return HKUnit.count()
        }
    }
    
    func fetchDistanceStats(
        startDate: Date,
        endDate: Date = Date(),
        interval: Calendar.Component,
        completion: @escaping ([DistanceModel]) -> Void
    ) {
        guard let type = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else { return }

        let calendar = Calendar.current
        let anchorDate = calendar.startOfDay(for: endDate)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)

        var intervalComponents = DateComponents()
        intervalComponents.setValue(1, for: interval)

        let query = HKStatisticsCollectionQuery(
            quantityType: type,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum,
            anchorDate: anchorDate,
            intervalComponents: intervalComponents
        )

        query.initialResultsHandler = { _, results, _ in
            var entries: [DistanceModel] = []
            results?.enumerateStatistics(from: startDate, to: endDate) { stats, _ in
                let value = stats.sumQuantity()?.doubleValue(for: .meter()) ?? 0
                entries.append(DistanceModel(date: stats.startDate, distance: value))
            }

            DispatchQueue.main.async {
                completion(entries)
            }
        }

        healthStore.execute(query)
    }
    
    func fetchStepStats(
        startDate: Date,
        endDate: Date = Date(),
        interval: Calendar.Component,
        completion: @escaping ([StepModel]) -> Void
    ) {
        guard let type = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }

        let calendar = Calendar.current
        let anchorDate = calendar.startOfDay(for: endDate)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)

        var intervalComponents = DateComponents()
        intervalComponents.setValue(1, for: interval)

        let query = HKStatisticsCollectionQuery(
            quantityType: type,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum,
            anchorDate: anchorDate,
            intervalComponents: intervalComponents
        )

        query.initialResultsHandler = { _, results, _ in
            var entries: [StepModel] = []
            results?.enumerateStatistics(from: startDate, to: endDate) { stats, _ in
                let value = stats.sumQuantity()?.doubleValue(for: .count()) ?? 0
                entries.append(StepModel(date: stats.startDate, steps: Int(value)))
            }

            DispatchQueue.main.async {
                completion(entries)
            }
        }

        healthStore.execute(query)
    }
    
    func fetchCaloriesStats(
        startDate: Date,
        endDate: Date = Date(),
        interval: Calendar.Component,
        completion: @escaping ([CalorieModel]) -> Void
    ) {
        guard let type = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else { return }

        let calendar = Calendar.current
        let anchorDate = calendar.startOfDay(for: endDate)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)

        var intervalComponents = DateComponents()
        intervalComponents.setValue(1, for: interval)

        let query = HKStatisticsCollectionQuery(
            quantityType: type,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum,
            anchorDate: anchorDate,
            intervalComponents: intervalComponents
        )

        query.initialResultsHandler = { _, results, _ in
            var entries: [CalorieModel] = []
            results?.enumerateStatistics(from: startDate, to: endDate) { stats, _ in
                let value = stats.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0
                entries.append(CalorieModel(date: stats.startDate, calories: Int(value)))
            }

            DispatchQueue.main.async {
                completion(entries)
            }
        }

        healthStore.execute(query)
    }
}
