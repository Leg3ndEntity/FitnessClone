//
//  CountAndDistanceCharts.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 02/06/25.
//

import SwiftUI
import Charts

struct CountAndDistanceCharts: View {
    
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
                        VStack(alignment: .leading, spacing: 10){
                            NavigationLink {
                                StepsCharts()
                            } label: {
                                VStack(alignment: .leading, spacing: 10) {
                                    VStack(alignment: .leading){
                                        Text("COUNT")
                                            .font(.footnote)
                                        
                                        Text("\(healthVM.steps)")
                                            .font(.title)
                                            .fontWeight(.medium)
                                            .foregroundColor(.lilacChart)
                                    }
                                    
                                    DailyStepsChart(isPopUp: false)
                                        .frame(height: 75)
                                }
                            }.buttonStyle(.plain).padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(12)
                            
                            
                                NavigationLink {
                                    DistancesCharts()
                                } label: {
                                    VStack(alignment: .leading, spacing: 10) {
                                        VStack(alignment: .leading){
                                            Text("COUNT")
                                                .font(.footnote)
                                            
                                            Text(String(format: "%.2f", healthVM.distance*0.001))
                                                .font(.title)
                                                .fontWeight(.medium)
                                                .foregroundColor(.cyan)
                                            + Text("KM").font(.title2)
                                                .fontWeight(.medium)
                                                .foregroundColor(.cyan)
                                        }
                                        
                                        DailyDistanceChart(isPopUp: false)
                                            .frame(height: 75)
                                    }
                                }.buttonStyle(.plain).padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(12)
                        }
                    case .week:
                        
                        let totalSteps = healthVM.weeklySteps.reduce(0) { $0 + $1.steps }
                        let totalDistance = healthVM.weeklyDistance.reduce(0) { $0 + $1.distance }
                        let averageDistance = healthVM.weeklyDistance.isEmpty ? 0 : totalDistance / Double(healthVM.weeklyDistance.count)
                        
                        VStack(alignment: .leading, spacing: 10){
                            NavigationLink {
                                StepsCharts()
                            } label: {
                                VStack(alignment: .leading, spacing: 10) {
                                    VStack(alignment: .leading){
                                        Text("COUNT")
                                            .font(.footnote)
                                        
                                        Text("\(totalSteps)")
                                            .font(.title)
                                            .fontWeight(.medium)
                                            .foregroundColor(.lilacChart)
                                    }
                                    
                                    WeeklyStepsChart()
                                        .frame(height: 75)
                                }
                            }.buttonStyle(.plain).padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(12)
                            
                            
                                NavigationLink {
                                    DistancesCharts()
                                } label: {
                                    VStack(alignment: .leading, spacing: 10) {
                                        VStack(alignment: .leading){
                                            Text("COUNT")
                                                .font(.footnote)
                                            
                                            Text(String(format: "%.2f", averageDistance*0.001))
                                                .font(.title)
                                                .fontWeight(.medium)
                                                .foregroundColor(.cyan)
                                            + Text("KM").font(.title2)
                                                .fontWeight(.medium)
                                                .foregroundColor(.cyan)
                                        }
                                        
                                        WeeklyDistancesChart()
                                            .frame(height: 75)
                                    }
                                }.buttonStyle(.plain).padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(12)
                        }
                    case .month:
                        
                        let totalSteps = healthVM.monthlySteps.reduce(0) { $0 + $1.steps }
                        let averageSteps = healthVM.monthlySteps.isEmpty ? 0 : totalSteps / healthVM.monthlySteps.count
                        
                        let totalDistance = healthVM.monthlyDistance.reduce(0) { $0 + $1.distance }
                        let averageDistance = healthVM.monthlyDistance.isEmpty ? 0 : totalDistance / Double(healthVM.monthlyDistance.count)
                        
                        VStack(alignment: .leading, spacing: 10){
                            NavigationLink {
                                StepsCharts()
                            } label: {
                                VStack(alignment: .leading, spacing: 10) {
                                    VStack(alignment: .leading){
                                        Text("COUNT")
                                            .font(.footnote)
                                        
                                        Text("\(averageSteps)")
                                            .font(.title)
                                            .fontWeight(.medium)
                                            .foregroundColor(.lilacChart)
                                    }
                                    
                                    MonthlyStepsChart()
                                        .frame(height: 75)
                                }
                            }.buttonStyle(.plain).padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(12)
                            
                            
                                NavigationLink {
                                    DistancesCharts()
                                } label: {
                                    VStack(alignment: .leading, spacing: 10) {
                                        VStack(alignment: .leading){
                                            Text("COUNT")
                                                .font(.footnote)
                                            
                                            Text(String(format: "%.2f", averageDistance*0.001))
                                                .font(.title)
                                                .fontWeight(.medium)
                                                .foregroundColor(.cyan)
                                            + Text("KM").font(.title2)
                                                .fontWeight(.medium)
                                                .foregroundColor(.cyan)
                                        }
                                        
                                        MonthlyDistancesChart()
                                            .frame(height: 75)
                                    }
                                }.buttonStyle(.plain).padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(12)
                        }
                    case .year:
                        let totalSteps = healthVM.yearlySteps.reduce(0) { $0 + $1.steps }
                        let averageSteps = healthVM.yearlySteps.isEmpty ? 0 : totalSteps / 365
                        
                        let totalDistance = healthVM.yearlyDistance.reduce(0.0) { $0 + $1.distance }

                        let totalDays = healthVM.yearlyDistance.reduce(0) { sum, entry in
                            if let days = Calendar.current.range(of: .day, in: .month, for: entry.date)?.count {
                                return sum + days
                            }
                            return sum
                        }

                        let averageDailyDistance = totalDays > 0 ? totalDistance / Double(totalDays) : 0

                        
                        VStack(alignment: .leading, spacing: 10){
                            NavigationLink {
                                StepsCharts()
                            } label: {
                                VStack(alignment: .leading, spacing: 10) {
                                    VStack(alignment: .leading){
                                        Text("COUNT")
                                            .font(.footnote)
                                        
                                        Text("\(averageSteps)")
                                            .font(.title)
                                            .fontWeight(.medium)
                                            .foregroundColor(.lilacChart)
                                    }
                                    
                                    YearlyStepsChart()
                                        .frame(height: 75)
                                }
                            }.buttonStyle(.plain).padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(12)
                            
                            
                                NavigationLink {
                                    DistancesCharts()
                                } label: {
                                    VStack(alignment: .leading, spacing: 10) {
                                        VStack(alignment: .leading){
                                            Text("COUNT")
                                                .font(.footnote)
                                            
                                            Text(String(format: "%.2f", averageDailyDistance*0.001))
                                                .font(.title)
                                                .fontWeight(.medium)
                                                .foregroundColor(.cyan)
                                            + Text("KM").font(.title2)
                                                .fontWeight(.medium)
                                                .foregroundColor(.cyan)
                                        }
                                        
                                        YearlyDistancesChart()
                                            .frame(height: 75)
                                    }
                                }.buttonStyle(.plain).padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(12)
                        }
                    }
                }
                
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
    CountAndDistanceCharts()
}
