//
//  YearlyStepsChart.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 01/06/25.
//

import SwiftUI
import Charts

struct YearlyStepsChart: View {
    
    @ObservedObject var stepsVM = StepsViewModel()
    @StateObject var calendarVM = CalendarViewModel.shared
    
    @State private var selectedMonth: Date? = nil
    
    @ViewBuilder
    private var selectionPopOver: some View {
        if let selected = selectedMonth,
           let entry = stepsVM.yearlySteps.first(where: {
             Calendar.current.isDate($0.date, equalTo: selected, toGranularity: .month)
           })
        {
            let formatter: DateFormatter = {
                let f = DateFormatter()
                f.dateFormat = "MMM yyyy"
                return f
            }()
            
            VStack(alignment: .leading) {
                Text("DAILY AVERAGE")
                    .font(.caption)
                    .foregroundStyle(.black.opacity(0.8))
                Text("\(entry.steps)")
                    .font(.title)
                    .foregroundStyle(.black)
                Text(formatter.string(from: entry.date))
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
            ForEach(stepsVM.yearlySteps) { entry in
                BarMark(
                    x: .value("Month", entry.date, unit: .month),
                    y: .value("Avg Daily Steps", entry.steps)
                )
                .foregroundStyle(.lilacChart.gradient)
                .opacity(
                    selectedMonth == nil ||
                    Calendar.current.isDate(entry.date, equalTo: selectedMonth!, toGranularity: .month)
                    ? 1 : 0.5
                )
            }
            
            if let sel = selectedMonth {
                RuleMark(x: .value("Month", sel, unit: .month))
                    .foregroundStyle(.lilacChart.opacity(0.3))
                    .zIndex(-1)
                    .annotation(position: .top, spacing: 5, overflowResolution: .init( x: .fit(to: .chart), y: .disabled )) {
                        selectionPopOver
                    }
            }
        }
        .chartXScale(
            domain: calendarVM.startOfYear(for: Date()) ... calendarVM.endOfYear(for: Date())
        )
        .chartXSelection(value: $selectedMonth)
        .chartXAxis {
            AxisMarks(values: .stride(by: .month)) { mark in
                AxisGridLine()
                AxisValueLabel {
                    if let date = mark.as(Date.self) {
                        let idx = Calendar.current.component(.month, from: date) - 1
                        let letter = DateFormatter().shortMonthSymbols[idx].first!
                        Text(String(letter))
                    }
                }
            }
        }
        .chartYAxis {
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
