//
//  StepsCharts.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 31/05/25.
//

import SwiftUI
import Charts

enum TimeRange: String, CaseIterable, Identifiable {
    case day = "D"
    case week = "W"
    case month = "M"
    case year = "Y"
    
    var id: String { self.rawValue }
}

struct StepsCharts: View {
    
    @StateObject var healthVM = HealthViewModel.shared
    @StateObject var calendarVM = CalendarViewModel.shared
    
    @State var selectedRange: TimeRange = .day
    
    var formattedYear: String {
        let calendar = Calendar(identifier: .gregorian)
        
        let date = Date()
        let year = calendar.component(.year, from: date)
        
        return "\(year)"
    }
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading, spacing: 10){
                Picker("Time Range", selection: $selectedRange) {
                    ForEach(TimeRange.allCases) { range in
                        Text(range.rawValue).tag(range)
                    }
                }.pickerStyle(.segmented)
                
                VStack(alignment: .leading){
                    
                    switch selectedRange {
                    case .day:
                        VStack(alignment: .leading){
                            
                            Text("TOTAL")
                                .font(.footnote)
                            
                            Text("\(healthVM.steps)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.lilacChart)
                            
                            Text("Today")
                                .font(.footnote)
                            
                            DailyStepsChart(isPopUp: false)
                                .frame(height: 250)
                        }
                    case .week:
                        
                        let totalSteps = healthVM.weeklySteps.reduce(0) { $0 + $1.steps }
                        let averageSteps = healthVM.weeklySteps.isEmpty ? 0 : totalSteps / healthVM.weeklySteps.count
                        
                        VStack(alignment: .leading){
                            Text("DAILY AVARAGE")
                                .font(.footnote)
                            
                            Text("\(averageSteps)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.lilacChart)
                            
                            Text("This Week")
                                .font(.footnote)
                            
                            WeeklyStepsChart()
                                .frame(height: 250)
                        }
                    case .month:
                        
                        let totalSteps = healthVM.monthlySteps.reduce(0) { $0 + $1.steps }
                        let averageSteps = healthVM.monthlySteps.isEmpty ? 0 : totalSteps / healthVM.monthlySteps.count
                        
                        VStack(alignment: .leading){
                            Text("DAILY AVARAGE")
                                .font(.footnote)
                            
                            Text("\(averageSteps)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.lilacChart)
                            
                            Text(calendarVM.formatMonthYear(Date()))
                                .font(.footnote)
                            
                            MonthlyStepsChart()
                                .frame(height: 250)
                        }
                    case .year:
                        let totalSteps = healthVM.yearlySteps.reduce(0) { $0 + $1.steps }
                        let averageSteps = healthVM.yearlySteps.isEmpty ? 0 : totalSteps / 365
                        
                        VStack(alignment: .leading){
                            Text("DAILY AVARAGE")
                                .font(.footnote)
                            
                            Text("\(averageSteps)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.lilacChart)
                            
                            Text(formattedYear)
                                .font(.footnote)
                            
                            YearlyStepsChart()
                                .frame(height: 250)
                        }
                    }
                }
                
                Button{
                }label: {
                    Text("View All Steps Metrics")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                }.padding(.vertical)
                
                Spacer()
                
            }.navigationTitle("Step Count")
                .padding(.horizontal, 20)
                .background {
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    Color.lilacChart.opacity(0.15),
                                    Color.lilacChart.opacity(0.0)
                                ]),
                                center: .center,
                                startRadius: 0,
                                endRadius: 300
                            )
                        )
                        .frame(width: 600, height: 600)
                        .offset(x: 0, y: -200)
                }

        }
    }
}

#Preview {
    StepsCharts()
}
