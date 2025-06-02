//
//  YearlyStepsChart.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 01/06/25.
//

import SwiftUI
import Charts

struct YearlyStepsChart: View {
    
    @StateObject var healthVM = HealthViewModel.shared
    @StateObject var calendarVM = CalendarViewModel.shared
    
    @State var selectedMonth: Date? = nil
    
    @ViewBuilder
    var selectionPopOver: some View {
        if let selectedMonth {
            let calendar = Calendar.current
            let selectedYear = calendar.component(.year, from: selectedMonth)
            let selectedMonthNumber = calendar.component(.month, from: selectedMonth)
            
            let stepsInMonth = healthVM.yearlySteps.filter {
                let comp = calendar.dateComponents([.year, .month], from: $0.date)
                return comp.year == selectedYear && comp.month == selectedMonthNumber
            }
            
            let totalSteps = stepsInMonth.map(\.steps).reduce(0, +)
            let daysInMonth = calendar.range(of: .day, in: .month, for: selectedMonth)?.count ?? 1
            let averageSteps = totalSteps / daysInMonth
            
            let formatter: DateFormatter = {
                let f = DateFormatter()
                f.dateFormat = "MMM yyyy"
                return f
            }()
            
            VStack(alignment: .leading) {
                Text("DAILY AVERAGE")
                    .font(.caption)
                    .foregroundStyle(.black.opacity(0.8))
                Text("\(averageSteps)")
                    .font(.title)
                    .foregroundStyle(.black)
                Text(formatter.string(from: selectedMonth))
                    .font(.caption)
                    .foregroundStyle(.black.opacity(0.8))
            }
            .padding(5)
            .background(.lilacChart)
            .cornerRadius(5)
        }
    }
    
    var body: some View {
        Chart {
            
            ForEach(healthVM.yearlySteps) { entry in
                
                let calendar = Calendar.current
                let daysInMonth = calendar.range(of: .day, in: .month, for: entry.date)?.count ?? 30
                let average = Double(entry.steps) / Double(daysInMonth)
                
                BarMark(
                    x: .value("Month", entry.date, unit: .month),
                    y: .value("Steps", average)
                ).foregroundStyle(.lilacChart.gradient)
                    .opacity(
                        selectedMonth == nil ||
                        Calendar.current.isDate(entry.date, inSameDayAs: selectedMonth!) ? 1 : 0.5
                    )
            }
            
            if let selectedMonth {
                RuleMark(x: .value("Month", selectedMonth, unit: .month))
                    .foregroundStyle(.lilacChart.opacity(0.3))
                    .zIndex(-1)
                    .annotation(position: .top, spacing: 5, overflowResolution: .init(x: .fit(to: .chart), y: .disabled)) {
                        selectionPopOver
                    }
            }
            
        }.chartXScale(domain: calendarVM.startOfYear(for: Date())...calendarVM.endOfYear(for: Date()))
            .chartXSelection(value: $selectedMonth)
            .chartXAxis {
                AxisMarks(values: .stride(by: .month)) { value in
                    AxisGridLine()
                    AxisValueLabel {
                        if let date = value.as(Date.self) {
                            let calendar = Calendar.current
                            let monthIndex = calendar.component(.month, from: date) - 1
                            let fullMonthName = DateFormatter().monthSymbols[monthIndex]
                            let initial = String(fullMonthName.prefix(1))
                            Text(initial)
                        }
                    }
                }
            }.chartYAxis {
                AxisMarks {
                    AxisGridLine()
                    AxisValueLabel()
                }
            }
    }
}

#Preview {
    YearlyStepsChart()
}
