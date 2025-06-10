//
//  MonthlyStepsChart.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 01/06/25.
//

import SwiftUI
import Charts

struct MonthlyStepsChart: View {
    
    @ObservedObject var stepsVM = StepsViewModel()
    @StateObject var calendarVM = CalendarViewModel.shared
    
    @State var selectedDay: Date? = nil
    
    @ViewBuilder
    var selectionPopOver: some View {
        if let selectedDay {
            let formatter: DateFormatter = {
                let f = DateFormatter()
                f.dateFormat = "dd MMM yyyy"
                return f
            }()
            
            let daySteps = stepsVM.monthlySteps
                .first(where: { Calendar.current.isDate($0.date, inSameDayAs: selectedDay) })?.steps ?? 0
            
            if daySteps > 0 {
                VStack(alignment: .leading) {
                    Text("TOTAL")
                        .font(.caption)
                        .foregroundStyle(.black.opacity(0.8))
                    Text("\(daySteps)")
                        .font(.title)
                        .foregroundStyle(.black)
                    Text(formatter.string(from: selectedDay))
                        .font(.caption)
                        .foregroundStyle(.black.opacity(0.8))
                }.padding(5)
                    .background(.lilacChart)
                    .cornerRadius(5)
            }
        }
    }
    
    var body: some View {
        Chart {
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            let thisMonth = calendar.component(.month, from: today)
            let thisMonthSteps = stepsVM.monthlySteps.filter {
                calendar.component(.month, from: $0.date) == thisMonth
            }
            
            ForEach(thisMonthSteps) { entry in
                BarMark(
                    x: .value("Day", entry.date, unit: .day),
                    y: .value("Steps", entry.steps)
                ).foregroundStyle(.lilacChart.gradient)
                    .opacity(
                        selectedDay == nil ||
                        Calendar.current.isDate(entry.date, inSameDayAs: selectedDay!) ? 1 : 0.5
                    )
            }
            
            if let selectedDay {
                RuleMark(x: .value("Day", selectedDay, unit: .day))
                    .foregroundStyle(.lilacChart.opacity(0.3))
                    .zIndex(-1)
                    .annotation(position: .top, spacing: 5, overflowResolution: .init(x: .fit(to: .chart), y: .disabled)) {
                        selectionPopOver
                    }
            }
            
        }.chartXScale(domain: calendarVM.startOfMonth(for: Date())...calendarVM.endOfMonth(for: Date()))
            .chartXSelection(value: $selectedDay)
            .chartXAxis {
                AxisMarks(values: .stride(by: .day, count: 7)) { value in
                    AxisGridLine()
                    AxisValueLabel {
                        if let date = value.as(Date.self) {
                            let day = Calendar.current.component(.day, from: date)
                            Text("\(day)")
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
    MonthlyStepsChart(stepsVM: StepsViewModel())
}
