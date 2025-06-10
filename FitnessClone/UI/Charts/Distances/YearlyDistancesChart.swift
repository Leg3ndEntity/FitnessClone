//
//  YearlyDistancesChart.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 02/06/25.
//

import SwiftUI
import Charts

struct YearlyDistancesChart: View {
    
    @ObservedObject var distanceVM = DistanceViewModel()
    @StateObject var calendarVM = CalendarViewModel.shared
    
    @State var selectedMonth: Date? = nil
    
    @ViewBuilder
    private var selectionPopOver: some View {
        if let selected = selectedMonth,
           let entry = distanceVM.yearlyDistance.first(where: {
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
                Text("\(entry.distance*0.001, specifier: "%.2f")")
                    .font(.title)
                    .foregroundStyle(.black)
                + Text(" km")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                Text(formatter.string(from: entry.date))
                    .font(.caption)
                    .foregroundStyle(.black.opacity(0.8))
            }
            .padding(5)
            .background(.cyanRing)
            .cornerRadius(5)
        }
    }
    
    var body: some View {
        Chart {
            ForEach(distanceVM.yearlyDistance) { entry in
            
                BarMark(
                    x: .value("Month", entry.date, unit: .month),
                    y: .value("Distance", entry.distance)
                )
                .foregroundStyle(.cyanRing.gradient)
                .opacity(
                    selectedMonth == nil ||
                    Calendar.current.isDate(entry.date, equalTo: selectedMonth!, toGranularity: .month)
                    ? 1 : 0.5
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
