//
//  DailyStepsChart.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 31/05/25.
//

import SwiftUI
import Charts

struct DailyStepsChart: View {
    
    @StateObject var healthVM = HealthViewModel.shared
    @StateObject var calendarVM = CalendarViewModel.shared
    
    @State var selectedHour: Date? = nil
    @State var isPopUp: Bool
    
    @ViewBuilder
    var selectionPopOver: some View {
        if let selectedHour {
            let nextHour = Calendar.current.date(byAdding: .hour, value: 1, to: selectedHour)!
            
            let formatter: DateFormatter = {
                let f = DateFormatter()
                f.dateFormat = "h a"
                f.amSymbol = "AM"
                f.pmSymbol = "PM"
                return f
            }()
            
            let hourStart = Calendar.current.date(bySetting: .minute, value: 0, of: selectedHour)!
            let hourEnd = Calendar.current.date(byAdding: .hour, value: 1, to: hourStart)!
            
            let hourSteps = healthVM.hourlySteps
                .filter { $0.date >= hourStart && $0.date < hourEnd }
                .map { $0.steps }
                .reduce(0, +)
            
            if hourSteps > 0 {
                VStack(alignment: .leading) {
                    Text("TOTAL")
                        .font(.caption)
                        .foregroundStyle(.black.opacity(0.8))
                    Text("\(hourSteps)")
                        .font(.title)
                        .foregroundStyle(.black)
                    Text("\(formatter.string(from: nextHour)) - \(formatter.string(from: Calendar.current.date(byAdding: .hour, value: 1, to: nextHour)!))")
                        .font(.caption)
                        .foregroundStyle(.black.opacity(0.8))
                }.padding(5)
                    .background(.lilacChart)
                    .cornerRadius(5)
            }
        }
    }
    
    var body: some View {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        let todaysSteps = healthVM.hourlySteps.filter {
            $0.date >= today && $0.date < tomorrow
        }
        //        let totalStepsToday = todaysSteps.map { $0.steps }.reduce(0, +)
        
        Chart {
            ForEach(todaysSteps) { entry in
                let entryHour = Calendar.current.date(bySetting: .minute, value: 0, of: entry.date)!
                let selectedHourNormalized = selectedHour.map { Calendar.current.date(bySetting: .minute, value: 0, of: $0)! }
                
                BarMark(
                    x: .value("Hour", entry.date, unit: .hour),
                    y: .value("Steps", entry.steps)
                )
                .foregroundStyle(.lilacChart.gradient)
                .opacity(selectedHour == nil || selectedHourNormalized == entryHour ? 1 : 0.5)
            }
            
            if let selectedHour {
                let hourStart = Calendar.current.date(bySetting: .minute, value: 0, of: selectedHour)!
                
                RuleMark(x: .value("Hour", hourStart, unit: .hour))
                    .foregroundStyle(.lilacChart.opacity(0.3))
                    .zIndex(-1)
                    .annotation(position: .top, spacing: 5, overflowResolution: .init(x: .fit(to: .chart), y: .disabled)) {
                        selectionPopOver
                    }
            }
            
        }.chartXScale(domain: calendarVM.startOfDay(for: Date())...calendarVM.endOfDay(for: Date()))
            .chartXSelection(value: $selectedHour)
            .chartXAxis {
                AxisMarks(values: .stride(by: .hour, count: 6)) { value in
                    AxisGridLine()
                    AxisValueLabel {
                        if let date = value.as(Date.self) {
                            Text(date.formatted(date: .omitted, time: .shortened))
                        }
                    }
                }
            }
            .chartYAxis {
                if !isPopUp{
                    AxisMarks {
                        AxisGridLine()
                        AxisValueLabel()
                    }
                }
            }
    }
}


#Preview {
    DailyStepsChart(isPopUp: false)
}
