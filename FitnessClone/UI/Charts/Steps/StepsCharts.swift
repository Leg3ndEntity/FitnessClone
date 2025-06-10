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
    
    @ObservedObject var stepsVM = StepsViewModel()
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
                            
                            Text("\(stepsVM.steps)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.lilacChart)
                            
                            Text("Today")
                                .font(.footnote)
                            
                            DailyStepsChart(stepsVM: stepsVM, isPopUp: false)
                                .frame(height: 250)
                        }
                    case .week:
                        
                        let totalSteps = stepsVM.weeklySteps.reduce(0) { $0 + $1.steps }
                        let averageSteps = stepsVM.weeklySteps.isEmpty ? 0 : totalSteps / stepsVM.weeklySteps.count
                        
                        VStack(alignment: .leading){
                            Text("DAILY AVARAGE")
                                .font(.footnote)
                            
                            Text("\(averageSteps)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.lilacChart)
                            
                            Text("This Week")
                                .font(.footnote)
                            
                            WeeklyStepsChart(stepsVM: stepsVM)
                                .frame(height: 250)
                        }
                    case .month:
                        
                        let totalSteps = stepsVM.monthlySteps.reduce(0) { $0 + $1.steps }
                        let averageSteps = stepsVM.monthlySteps.isEmpty ? 0 : totalSteps / stepsVM.monthlySteps.count
                        
                        VStack(alignment: .leading){
                            Text("DAILY AVARAGE")
                                .font(.footnote)
                            
                            Text("\(averageSteps)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.lilacChart)
                            
                            Text(calendarVM.formatMonthYear(Date()))
                                .font(.footnote)
                            
                            MonthlyStepsChart(stepsVM: stepsVM)
                                .frame(height: 250)
                        }
                    case .year:
                        let calendar = Calendar.current
                        let now = Date()
                        let daysSoFar = calendar.ordinality(of: .day, in: .year, for: now) ?? 365
                        
                        let totalSteps = stepsVM.yearlySteps.reduce(0) { acc, model in
                            let daysInMonth = calendar.range(of: .day, in: .month, for: model.date)?.count ?? 0
                            return acc + (model.steps * daysInMonth)
                        }
                        let averageSteps = daysSoFar > 0 ? totalSteps / daysSoFar : 0
                        
                        VStack(alignment: .leading){
                            Text("DAILY AVARAGE")
                                .font(.footnote)
                            
                            Text("\(averageSteps)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.lilacChart)
                            
                            Text(formattedYear)
                                .font(.footnote)
                            
                            YearlyStepsChart(stepsVM: stepsVM)
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
                .navigationBarTitleDisplayMode(.large)
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
