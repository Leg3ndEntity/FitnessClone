//
//  MonthlyDistancesChart.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 02/06/25.
//

import SwiftUI
import Charts

struct MonthlyDistancesChart: View {
    
    @StateObject var healthVM = HealthViewModel.shared
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
            
            let dayDistances = healthVM.monthlyDistance
                .first(where: { Calendar.current.isDate($0.date, inSameDayAs: selectedDay) })?.distance ?? 0
            
            if dayDistances > 0 {
                VStack(alignment: .leading) {
                    Text("TOTAL")
                        .font(.caption)
                        .foregroundStyle(.black.opacity(0.8))
                    Text("\(dayDistances*0.001, specifier: "%.2f")")
                        .font(.title)
                        .foregroundStyle(.black)
                    + Text("KM").font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    Text(formatter.string(from: selectedDay))
                        .font(.caption)
                        .foregroundStyle(.black.opacity(0.8))
                }.padding(5)
                    .background(.cyanRing)
                    .cornerRadius(5)
            }
        }
    }
    
    var body: some View {
        Chart {
            ForEach(healthVM.monthlyDistance) { entry in
                BarMark(
                    x: .value("Day", entry.date, unit: .day),
                    y: .value("Distance", entry.distance)
                ).foregroundStyle(.cyanRing.gradient)
                    .opacity(
                        selectedDay == nil ||
                        Calendar.current.isDate(entry.date, inSameDayAs: selectedDay!) ? 1 : 0.5
                    )
            }
            
            if let selectedDay {
                RuleMark(x: .value("Day", selectedDay, unit: .day))
                    .foregroundStyle(.cyanRing.opacity(0.3))
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
    MonthlyDistancesChart()
}
