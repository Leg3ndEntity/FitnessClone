//
//  DailyDistanceChart.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 02/06/25.
//

import SwiftUI
import Charts

struct DailyDistanceChart: View {
    
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
            
            let hourDistances = healthVM.hourlyDistance
                .filter { $0.date >= hourStart && $0.date < hourEnd }
                .map { $0.distance }
                .reduce(0, +)
            
            if hourDistances > 0 {
                VStack(alignment: .leading) {
                    Text("TOTAL")
                        .font(.caption)
                        .foregroundStyle(.black.opacity(0.8))
                    Text("\(hourDistances*0.001, specifier: "%.2f")")
                        .font(.title)
                        .foregroundStyle(.black)
                    + Text("KM").font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    Text("\(formatter.string(from: nextHour)) - \(formatter.string(from: Calendar.current.date(byAdding: .hour, value: 1, to: nextHour)!))")
                        .font(.caption)
                        .foregroundStyle(.black.opacity(0.8))
                }.padding(5)
                    .background(.cyanRing)
                    .cornerRadius(5)
            }
        }
    }
    
    var body: some View {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        let todaysStepsDistance = healthVM.hourlyDistance.filter {
            $0.date >= today && $0.date < tomorrow
        }
        
        Chart {
            ForEach(todaysStepsDistance) { entry in
                
                BarMark(
                    x: .value("Hour", entry.date, unit: .hour),
                    y: .value("Distance", entry.distance)
                ).foregroundStyle(.cyanRing.gradient)
                
            }
            
            if let selectedHour {
                let hourStart = Calendar.current.date(bySetting: .minute, value: 0, of: selectedHour)!
                
                RuleMark(x: .value("Hour", hourStart, unit: .hour))
                    .foregroundStyle(.cyanRing.opacity(0.3))
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
    DailyDistanceChart(isPopUp: false)
}
