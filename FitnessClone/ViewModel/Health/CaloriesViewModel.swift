//
//  CaloriesViewModel.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 08/06/25.
//

import Foundation
import HealthKit

class CaloriesViewModel: ObservableObject {
    
    @Published var calories: Int = 0
    @Published var hourlyCalories: [CalorieModel] = []
    @Published var weeklyCalories: [CalorieModel] = []
    @Published var monthlyCalories: [CalorieModel] = []
    
    private let manager = HealthKitManager.shared

    init() {
        fetchAllCaloriesData()
    }


    private func fetchCalories() {
        manager.fetchSum(for: .activeEnergyBurned) { self.calories = Int($0) }
    }

    
    private func fetchHourlyCalories() {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        manager.fetchCaloriesStats(startDate: startOfDay, interval: .hour) {
            self.hourlyCalories = $0
        }
    }

    
    private func fetchWeeklyCalories() {
        let calendar = Calendar.current
        let now = Date()
        let startOfWeek = calendar.date(from: calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: now))!
        let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek)!
        let correctedEndDate = calendar.date(byAdding: .second, value: -1, to: endOfWeek)!
        manager.fetchCaloriesStats(startDate: startOfWeek, endDate: correctedEndDate, interval: .day) {
            self.weeklyCalories = $0
        }
    }

    
    private func fetchMonthlyCalories() {
        let calendar = Calendar.current
        let now = Date()
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
        let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
        let correctedEndDate = calendar.date(byAdding: .second, value: -1, to: endOfMonth)!
        manager.fetchCaloriesStats(startDate: startOfMonth, endDate: correctedEndDate, interval: .day) {
            self.monthlyCalories = $0
        }
    }

    
    private func fetchAllCaloriesData() {
        fetchCalories()
        fetchHourlyCalories()
        fetchWeeklyCalories()
        fetchMonthlyCalories()
    }
    
}
