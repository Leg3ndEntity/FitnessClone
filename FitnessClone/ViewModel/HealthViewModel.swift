//
//  HealthViewModel.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 30/05/25.
//

import Foundation
import HealthKit

class HealthViewModel: ObservableObject {
    private let manager = HealthKitManager.shared
    
    static let shared = HealthViewModel()
    
    private init() {
        manager.requestAuthorization {_ in
            self.fetchAllData()
        }
    }
    
    @Published var flightsClimbed: Int = 0
    @Published var workouts: [HKWorkout] = []
    var workoutType: String {
        workouts.first?.workoutActivityType.name ?? "N/A"
    }
    var workoutDistance: Double {
        workouts
            .compactMap { $0.totalDistance?.doubleValue(for: .meter()) }
            .reduce(0, +)
    }
    var workoutDuration: Double {
        workouts
            .compactMap(\.duration)
            .reduce(0, +)
    }
    var workoutActiveCalories: Double {
        workouts.compactMap { workout in
            if #available(iOS 18.0, *) {
                let stats = workout.statistics(for: HKQuantityType(.activeEnergyBurned))
                return stats?.sumQuantity()?.doubleValue(for: .kilocalorie())
            } else {
                return workout.totalEnergyBurned?.doubleValue(for: .kilocalorie())
            }
        }.reduce(0, +)
    }
    var workoutAverageHeartRate: Double {
        let heartRates: [Double] = workouts.compactMap { workout in
            if #available(iOS 18.0, *) {
                let stats = workout.statistics(for: HKQuantityType(.heartRate))
                return stats?.averageQuantity()?.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
            } else {
                return nil
            }
        }
        
        guard !heartRates.isEmpty else { return 0 }
        return heartRates.reduce(0, +) / Double(heartRates.count)
    }
    var workoutAveragePace: Double {
        let totalDurationInMinutes = workouts
            .map(\.duration)
            .reduce(0, +) / 60

        let totalDistanceInKilometers = workouts
            .compactMap { $0.totalDistance?.doubleValue(for: .meter()) }
            .reduce(0, +) / 1000

        guard totalDistanceInKilometers > 0 else { return 0 }
        
        return totalDurationInMinutes / totalDistanceInKilometers
    }


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
    
    private func fetchAllData() {
        fetchSteps()
        fetchCalories()
        fetchDistance()
        fetchFlightsClimbed()
        
        fetchAllCaloriesData()
        fetchAllStepsData()
        fetchAllDistanceData()
        fetchDailyWorkouts()
    }
    
    private func fetchSteps() {
        manager.fetchSum(for: .stepCount) { self.steps = Int($0) }
    }
    
    private func fetchCalories() {
        manager.fetchSum(for: .activeEnergyBurned) { self.calories = Int($0) }
    }
    
    private func fetchDistance() {
        manager.fetchSum(for: .distanceWalkingRunning) { self.distance = $0 }
    }
    
    private func fetchFlightsClimbed() {
        manager.fetchSum(for: .flightsClimbed) { self.flightsClimbed = Int($0) }
    }
    
    func fetchHourlyCalories() {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        manager.fetchCaloriesStats(startDate: startOfDay, interval: .hour) {
            self.hourlyCalories = $0
        }
    }
    
    func fetchWeeklyCalories() {
        let calendar = Calendar.current
        let now = Date()
        let startOfWeek = calendar.date(from: calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: now))!
        let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek)!
        let correctedEndDate = calendar.date(byAdding: .second, value: -1, to: endOfWeek)!
        manager.fetchCaloriesStats(startDate: startOfWeek, endDate: correctedEndDate, interval: .day) {
            self.weeklyCalories = $0
        }
    }
    
    func fetchMonthlyCalories() {
        let calendar = Calendar.current
        let now = Date()
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
        let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
        let correctedEndDate = calendar.date(byAdding: .second, value: -1, to: endOfMonth)!
        manager.fetchCaloriesStats(startDate: startOfMonth, endDate: correctedEndDate, interval: .day) {
            self.monthlyCalories = $0
        }
    }
    
    func fetchYearlyCalories() {
        let calendar = Calendar.current
        let now = Date()
        let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: now))!
        manager.fetchCaloriesStats(startDate: startOfYear, endDate: now, interval: .month) {
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
        manager.fetchStepStats(startDate: startOfDay, interval: .hour) {
            self.hourlySteps = $0
        }
    }
    
    func fetchWeeklySteps() {
        let calendar = Calendar.current
        let now = Date()
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
        manager.fetchStepStats(startDate: startOfWeek, interval: .day) {
            self.weeklySteps = $0
        }
    }
    
    func fetchMonthlySteps() {
        let calendar = Calendar.current
        let now = Date()
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
        manager.fetchStepStats(startDate: startOfMonth, interval: .day) {
            self.monthlySteps = $0
        }
    }
    
    func fetchYearlySteps() {
        let calendar = Calendar.current
        let now = Date()
        let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: now))!
        manager.fetchStepStats(startDate: startOfYear, interval: .month) {
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
        let startOfDay = Calendar.current.startOfDay(for: Date())
        manager.fetchDistanceStats(startDate: startOfDay, interval: .hour) {
            self.hourlyDistance = $0
        }
    }
    
    func fetchWeeklyDistance() {
        let calendar = Calendar.current
        let now = Date()
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
        manager.fetchDistanceStats(startDate: startOfWeek, interval: .day) {
            self.weeklyDistance = $0
        }
    }
    
    func fetchMonthlyDistance() {
        let calendar = Calendar.current
        let now = Date()
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
        manager.fetchDistanceStats(startDate: startOfMonth, interval: .day) { self.monthlyDistance = $0 }
    }
    
    func fetchYearlyDistance() {
        let calendar = Calendar.current
        let now = Date()
        let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: now))!
        manager.fetchDistanceStats(startDate: startOfYear, interval: .month) { self.yearlyDistance = $0 }
    }
    
    func fetchAllDistanceData() {
        fetchHourlyDistance()
        fetchWeeklyDistance()
        fetchMonthlyDistance()
        fetchYearlyDistance()
    }
    
    func fetchDailyWorkouts() {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        manager.fetchDailyWorkouts(startDate: startOfDay, endDate: endOfDay) { workouts in
            self.workouts = workouts
        }
    }

    
}
