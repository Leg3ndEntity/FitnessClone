//
//  YearlyDistancesChart.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 02/06/25.
//

import SwiftUI
import Charts

struct YearlyDistancesChart: View {
    
    @StateObject var healthVM = HealthViewModel.shared
    @StateObject var calendarVM = CalendarViewModel.shared
    
    @State var selectedMonth: Date? = nil
    
    @ViewBuilder
    var selectionPopOver: some View {
        if let selectedMonth {
            
            let formatter: DateFormatter = {
                let f = DateFormatter()
                f.dateFormat = "MMM yyyy"
                return f
            }()
            
            if let entry = healthVM.yearlyDistance.first(where: {
                Calendar.current.isDate($0.date, equalTo: selectedMonth, toGranularity: .month)
            }) {
                let calendar = Calendar.current
                let daysInMonth = calendar.range(of: .day, in: .month, for: entry.date)?.count ?? 30
                let dailyAverage = entry.distance / Double(daysInMonth)
                let formattedAverage = String(format: "%.1f", dailyAverage / 1000)
                
                VStack(alignment: .leading) {
                    Text("DAILY AVERAGE")
                        .font(.caption)
                        .foregroundStyle(.black.opacity(0.8))
                    Text("\(formattedAverage)")
                        .font(.title)
                        .foregroundStyle(.black)
                    + Text("KM").font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    Text(formatter.string(from: selectedMonth))
                        .font(.caption)
                        .foregroundStyle(.black.opacity(0.8))
                }
                .padding(5)
                .background(.cyanRing)
                .cornerRadius(5)
            }
        }
    }

    
    var body: some View {
        Chart {
            ForEach(healthVM.yearlyDistance) { entry in
                
                let calendar = Calendar.current
                let daysInMonth = calendar.range(of: .day, in: .month, for: entry.date)?.count ?? 30
                let average = entry.distance / Double(daysInMonth)
                
                BarMark(
                    x: .value("Month", entry.date, unit: .month),
                    y: .value("Distance", average)
                )
                .foregroundStyle(.cyanRing.gradient)
                .opacity(
                    selectedMonth == nil ||
                    calendar.isDate(entry.date, inSameDayAs: selectedMonth!) ? 1 : 0.5
                )
            }
            
            if let selectedMonth {
                RuleMark(x: .value("Month", selectedMonth, unit: .month))
                    .foregroundStyle(.cyanRing.opacity(0.3))
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
    YearlyDistancesChart()
}
