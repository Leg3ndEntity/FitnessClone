//
//  StepsViewModel.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 08/06/25.
//

import Foundation
import HealthKit

class StepsViewModel: ObservableObject {
    private let manager = HealthKitManager.shared

    @Published var steps: Int = 0
    @Published var hourlySteps: [StepModel] = []
    @Published var weeklySteps: [StepModel] = []
    @Published var monthlySteps: [StepModel] = []
    @Published var yearlySteps: [StepModel] = []

    init() {
        fetchSteps()
        fetchAllStepsData()
    }

    private func fetchSteps() {
        manager.fetchSum(for: .stepCount) { self.steps = Int($0) }
    }

    func fetchHourlySteps() {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        manager.fetchStepStats(startDate: startOfDay, interval: .hour) {
            self.hourlySteps = $0
        }
    }

    func fetchWeeklySteps() {
        let now = Date()
        let startOfWeek = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
        manager.fetchStepStats(startDate: startOfWeek, interval: .day) {
            self.weeklySteps = $0
        }
    }

    func fetchMonthlySteps() {
        let now = Date()
        let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: now))!
        manager.fetchStepStats(startDate: startOfMonth, interval: .day) {
            self.monthlySteps = $0
        }
    }
    
    func fetchYearlySteps() {
        let calendar = Calendar.current
        let now = Date()
        let startOfYear = calendar.date(from:
            calendar.dateComponents([.year], from: now))!

        manager.fetchStepStats(startDate: startOfYear, interval: .day) { dailySteps in
            let groupedByMonth = Dictionary(grouping: dailySteps) {
                calendar.date(from:
                    calendar.dateComponents([.year, .month], from: $0.date))!
            }

            let monthlyAverages: [StepModel] = groupedByMonth.map { monthStart, stepsList in
                let total = stepsList.reduce(0) { $0 + $1.steps }

                let daysCount: Int
                if calendar.isDate(monthStart, equalTo: now, toGranularity: .month) {
                    daysCount = calendar.component(.day, from: now)
                } else {
                    daysCount = calendar.range(of: .day, in: .month, for: monthStart)?.count ?? stepsList.count
                }

                let avg = daysCount > 0 ? total / daysCount : 0
                return StepModel(date: monthStart, steps: avg)
            }

            DispatchQueue.main.async {
                self.yearlySteps = monthlyAverages
                    .sorted(by: { $0.date < $1.date })
            }
        }
    }

    func fetchAllStepsData() {
        fetchHourlySteps()
        fetchWeeklySteps()
        fetchMonthlySteps()
        fetchYearlySteps()
    }
}
