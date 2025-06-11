//
//  DistanceViewModel.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 08/06/25.
//

import Foundation
import HealthKit

class DistanceViewModel: ObservableObject {
    
    @Published var distance: Double = 0
    @Published var hourlyDistance: [DistanceModel] = []
    @Published var weeklyDistance: [DistanceModel] = []
    @Published var monthlyDistance: [DistanceModel] = []
    @Published var yearlyDistance: [DistanceModel] = []

    private let manager = HealthKitManager.shared

    init() {
        fetchAllDistanceData()
    }

    
    private func fetchDistance() {
        manager.fetchSum(for: .distanceWalkingRunning) { self.distance = $0 }
    }

    
    func fetchHourlyDistance() {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        manager.fetchDistanceStats(startDate: startOfDay, interval: .hour) {
            self.hourlyDistance = $0
        }
    }

    
    func fetchWeeklyDistance() {
        let now = Date()
        let startOfWeek = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
        manager.fetchDistanceStats(startDate: startOfWeek, interval: .day) {
            self.weeklyDistance = $0
        }
    }

    
    func fetchMonthlyDistance() {
        let now = Date()
        let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: now))!
        manager.fetchDistanceStats(startDate: startOfMonth, interval: .day) {
            self.monthlyDistance = $0
        }
    }

    
    func fetchYearlyDistance() {
        let calendar = Calendar.current
        let now = Date()
        let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: now))!

        manager.fetchDistanceStats(startDate: startOfYear, interval: .day) { dailyDistances in
            let groupedByMonth = Dictionary(grouping: dailyDistances) {
                calendar.date(from: calendar.dateComponents([.year, .month], from: $0.date))!
            }

            let monthlyAverages: [DistanceModel] = groupedByMonth.map { monthStart, distancesList in
                let total = distancesList.reduce(0) { $0 + $1.distance }

                let daysCount: Int
                if calendar.isDate(monthStart, equalTo: now, toGranularity: .month) {
                    daysCount = calendar.component(.day, from: now)
                } else {
                    daysCount = calendar.range(of: .day, in: .month, for: monthStart)?.count ?? distancesList.count
                }

                let avg = daysCount > 0 ? total / Double(daysCount) : 0
                return DistanceModel(date: monthStart, distance: avg)
            }

            DispatchQueue.main.async {
                self.yearlyDistance = monthlyAverages
                    .sorted(by: { $0.date < $1.date })
            }
        }
    }

    func fetchAllDistanceData() {
        fetchDistance()
        fetchHourlyDistance()
        fetchWeeklyDistance()
        fetchMonthlyDistance()
        fetchYearlyDistance()
    }
    
}
