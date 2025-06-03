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
    
}
