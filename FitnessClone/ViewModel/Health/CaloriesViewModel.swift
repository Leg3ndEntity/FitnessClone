//
//  CaloriesViewModel.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 08/06/25.
//

import Foundation
import HealthKit

class CaloriesViewModel: ObservableObject {
    private let manager = HealthKitManager.shared

    @Published var calories: Int = 0
    @Published var hourlyCalories: [CalorieModel] = []
    @Published var weeklyCalories: [CalorieModel] = []
    @Published var monthlyCalories: [CalorieModel] = []
    @Published var yearlyCalories: [CalorieModel] = []

    init() {
        fetchCalories()
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

    private func fetchYearlyCalories() {
        let calendar = Calendar.current
        let now = Date()
        let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: now))!
        manager.fetchCaloriesStats(startDate: startOfYear, endDate: now, interval: .month) {
            self.yearlyCalories = $0
        }
    }

    private func fetchAllCaloriesData() {
        fetchHourlyCalories()
        fetchWeeklyCalories()
        fetchMonthlyCalories()
        fetchYearlyCalories()
    }
}
