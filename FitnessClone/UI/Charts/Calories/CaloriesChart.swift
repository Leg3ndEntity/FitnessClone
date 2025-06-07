//
//  CaloriesChart.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 30/05/25.
//

import SwiftUI
import Charts

struct CaloriesChart: View {
    
    @StateObject var healthVM = HealthViewModel.shared
    @StateObject var calendarVM = CalendarViewModel.shared
    
    var maxCalories: Int {
        healthVM.hourlyCalories.map { $0.calories }.max() ?? 0
    }

    var body: some View {
        Chart {
            ForEach(healthVM.hourlyCalories) { entry in
                BarMark(
                    x: .value("Hour", entry.date),
                    y: .value("Calories", entry.calories)
                ).foregroundStyle(.magentaRing.gradient)
            }
            
            RuleMark(y: .value("Max", maxCalories))
                .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                .foregroundStyle(.gray)
                .annotation(position: .bottom, alignment: .leading) {
                    Text("\(maxCalories)KCAL")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            
        }.chartXScale(domain: calendarVM.startOfDay(for: Date())...calendarVM.endOfDay(for: Date()))
            .chartXAxis {
                AxisMarks(values: .stride(by: .hour, count: 6)) { value in
                    AxisValueLabel {
                        if let date = value.as(Date.self) {
                            Text(date.formatted(date: .omitted, time: .shortened))
                        }
                    }
                }
            }
            .chartYScale(domain: 0...(Double(maxCalories)))
            .chartYAxis {
                AxisMarks() {
                    AxisGridLine()
                }
            }

    }
}


#Preview {
    CaloriesChart()
}
