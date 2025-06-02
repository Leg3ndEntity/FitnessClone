//
//  HealthViewModel.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 30/05/25.
//

import Foundation
import HealthKit

class HealthViewModel: ObservableObject {
    private let healthStore = HKHealthStore()
    
    static let shared = HealthViewModel()
    private init() {
        requestAuthorization()
    }
    
    @Published var flightsClimbed: Int = 0
    @Published var workouts: [HKWorkout] = []
    
    @Published var calories: Int = 0
    @Published var hourlyCalories: [CalorieModel] = []
    @Published var weeklyCalories: [CalorieModel] = []
    @Published var monthlyCalories: [CalorieModel] = []
    @Published var yearlyCalories: [CalorieModel] = []

    @Published var steps: Int = 0
    @Published var hourlySteps: [StepModel] = []
    @Published var weeklySteps: [StepModel] = []
    @Published var monthlySteps: [StepModel] = []
    @Published var yearlySteps: [StepModel] = []
    
    @Published var distance: Double = 0
    @Published var hourlyDistance: [DistanceModel] = []
    @Published var weeklyDistance: [DistanceModel] = []
    @Published var monthlyDistance: [DistanceModel] = []
    @Published var yearlyDistance: [DistanceModel] = []
    
    
    private var readTypes: Set<HKObjectType> {
        return [
            HKQuantityType.quantityType(forIdentifier: .stepCount)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKQuantityType.quantityType(forIdentifier: .flightsClimbed)!,
            HKObjectType.workoutType()
        ]
    }
    
    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else { return }

        healthStore.requestAuthorization(toShare: [], read: readTypes) { [weak self] success, error in
            if success {
                DispatchQueue.main.async {
                    print("Data collection authorization granted.")
                    self?.fetchAllData()
                }
            } else {
                print("Authorization failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    
    private func fetchAllData() {
        fetchSteps()
        fetchCalories()
        fetchDistance()
        fetchFlightsClimbed()
        
        fetchAllCaloriesData()
        fetchAllStepsData()
        fetchAllDistanceData()
    }
    
    private func fetchSteps() {
        fetchSum(for: .stepCount) { self.steps = Int($0) }
    }

    private func fetchCalories() {
        fetchSum(for: .activeEnergyBurned) { self.calories = Int($0) }
    }

    private func fetchDistance() {
        fetchSum(for: .distanceWalkingRunning) { self.distance = $0 }
    }

    private func fetchFlightsClimbed() {
        fetchSum(for: .flightsClimbed) { self.flightsClimbed = Int($0) }
    }

    private func fetchSum(for identifier: HKQuantityTypeIdentifier, completion: @escaping (Double) -> Void) {
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
    
    
    func fetchHourlyCalories() {
        fetchCaloriesStats(startOffset: -1, interval: .hour, component: .day) { self.hourlyCalories = $0 }
    }
    
    func fetchWeeklyCalories() {
        let calendar = Calendar.current
        let now = Date()
        let startOfWeek = calendar.date(from: calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: now))!
        let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek)!
        let correctedEndDate = calendar.date(byAdding: .second, value: -1, to: endOfWeek)!

        fetchCaloriesStats(startDate: startOfWeek, endDate: correctedEndDate, interval: .day) {
            self.weeklyCalories = $0
        }
    }

    func fetchMonthlyCalories() {
        let calendar = Calendar.current
        let now = Date()
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
        let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
        let correctedEndDate = calendar.date(byAdding: .second, value: -1, to: endOfMonth)!
        fetchCaloriesStats(startDate: startOfMonth, endDate: correctedEndDate, interval: .day) {
            self.monthlyCalories = $0
        }
    }

    func fetchYearlyCalories() {
        let calendar = Calendar.current
        let now = Date()
        let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: now))!
        fetchCaloriesStats(startDate: startOfYear, endDate: now, interval: .month) {
            self.yearlyCalories = $0
        }
    }
    
    func fetchAllCaloriesData() {
        fetchHourlyCalories()
        fetchWeeklyCalories()
        fetchMonthlyCalories()
        fetchYearlyCalories()
    }
    
    
    func fetchHourlySteps() {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        fetchStepStats(startDate: startOfDay, interval: .hour) {
            self.hourlySteps = $0
        }
    }

    func fetchWeeklySteps() {
        let calendar = Calendar.current
        let now = Date()
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
        fetchStepStats(startDate: startOfWeek, interval: .day) {
            self.weeklySteps = $0
        }
    }
    
    func fetchMonthlySteps() {
        let calendar = Calendar.current
        let now = Date()
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
        fetchStepStats(startDate: startOfMonth, interval: .day) {
            self.monthlySteps = $0
        }
    }
    
    func fetchYearlySteps() {
        let calendar = Calendar.current
        let now = Date()
        let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: now))!
        
        fetchStepStats(startDate: startOfYear, endDate: now, interval: .month) {
            self.yearlySteps = $0
        }
    }
    
    func fetchAllStepsData(){
        fetchHourlySteps()
        fetchWeeklySteps()
        fetchMonthlySteps()
        fetchYearlySteps()
    }
    
    func fetchHourlyDistance() {
        fetchDistanceStats(startOffset: -1, interval: .hour, component: .day) { self.hourlyDistance = $0 }
    }
    
    func fetchWeeklyDistance() {
        let calendar = Calendar.current
        let now = Date()
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
        fetchDistanceStats(startDate: startOfWeek, interval: .day) {
            self.weeklyDistance = $0
        }
    }
    
    func fetchMonthlyDistance() {
        let calendar = Calendar.current
        let now = Date()
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
        fetchDistanceStats(startDate: startOfMonth, interval: .day) { self.monthlyDistance = $0 }
    }

    func fetchYearlyDistance() {
        let calendar = Calendar.current
        let now = Date()
        let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: now))!
        fetchDistanceStats(startDate: startOfYear, interval: .month) { self.yearlyDistance = $0 }
    }
    
    func fetchAllDistanceData() {
        fetchHourlyDistance()
        fetchWeeklyDistance()
        fetchMonthlyDistance()
        fetchYearlyDistance()
    }
    

    
    
    private func fetchDistanceStats(
        startOffset: Int,
        interval: Calendar.Component,
        component: Calendar.Component,
        completion: @escaping ([DistanceModel]) -> Void
    ) {
        guard let type = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else { return }

        let calendar = Calendar.current
        let endDate = Date()
        let anchorDate = calendar.startOfDay(for: endDate)
        let startDate = calendar.date(byAdding: component, value: startOffset, to: anchorDate)!

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

    private func fetchDistanceStats(
        startDate: Date,
        interval: Calendar.Component,
        completion: @escaping ([DistanceModel]) -> Void
    ) {
        guard let type = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else { return }

        let calendar = Calendar.current
        let endDate = Date()
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


    
    
    
    private func fetchStepStats(
        startDate: Date,
        endDate: Date,
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
    
    private func fetchStepStats(
        startDate: Date,
        interval: Calendar.Component,
        completion: @escaping ([StepModel]) -> Void
    ) {
        guard let type = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }

        let calendar = Calendar.current
        let endDate = Date()
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
    
    
    
    
    
    private func fetchCaloriesStats(
        startOffset: Int,
        interval: Calendar.Component,
        component: Calendar.Component,
        completion: @escaping ([CalorieModel]) -> Void
    ) {
        guard let type = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else { return }

        let calendar = Calendar.current
        let endDate = Date()
        let anchorDate = calendar.startOfDay(for: endDate)
        let startDate = calendar.date(byAdding: component, value: startOffset, to: anchorDate)!

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        var intervalComponents = DateComponents()
        intervalComponents.setValue(1, for: interval)

        let query = HKStatisticsCollectionQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: intervalComponents)

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
    
    private func fetchCaloriesStats(
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
