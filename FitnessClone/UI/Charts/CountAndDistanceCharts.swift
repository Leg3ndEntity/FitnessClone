//
//  CountAndDistanceCharts.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 02/06/25.
//

import SwiftUI
import Charts

struct CountAndDistanceCharts: View {
    
    @StateObject var calendarVM = CalendarViewModel.shared
    
    @ObservedObject var distanceVM = DistanceViewModel()
    @ObservedObject var stepsVM = StepsViewModel()
    
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
                
                VStack(alignment: .leading){
                    Text("Steps")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    switch selectedRange {
                    case .day:
                        Text("Today")
                    case .week:
                        Text("This Week")
                    case .month:
                        Text("This Month")
                    case .year:
                        Text("This Year")
                    }
                }
                
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
                                StepsCharts(stepsVM: stepsVM)
                            } label: {
                                VStack(alignment: .leading, spacing: 10) {
                                    VStack(alignment: .leading){
                                        Text("COUNT")
                                            .font(.footnote)
                                        
                                        Text("\(stepsVM.steps)")
                                            .font(.title)
                                            .fontWeight(.medium)
                                            .foregroundColor(.lilacChart)
                                    }
                                    
                                    DailyStepsChart(stepsVM: stepsVM, isPopUp: false)
                                        .frame(height: 75)
                                }
                            }.buttonStyle(.plain).padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(12)
                            
                            
                            NavigationLink {
                                DistancesCharts(distanceVM: distanceVM)
                            } label: {
                                VStack(alignment: .leading, spacing: 10) {
                                    VStack(alignment: .leading){
                                        Text("COUNT")
                                            .font(.footnote)
                                        
                                        Text(String(format: "%.2f", distanceVM.distance*0.001))
                                            .font(.title)
                                            .fontWeight(.medium)
                                            .foregroundColor(.cyan)
                                        + Text("KM").font(.title2)
                                            .fontWeight(.medium)
                                            .foregroundColor(.cyan)
                                    }
                                    
                                    DailyDistanceChart(distanceVM: distanceVM, isPopUp: false)
                                        .frame(height: 75)
                                }
                            }.buttonStyle(.plain).padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(12)
                        }
                    case .week:
                        let totalSteps = stepsVM.weeklySteps.reduce(0) { $0 + $1.steps }
                        let averageSteps = stepsVM.weeklySteps.isEmpty ? 0 : totalSteps / stepsVM.weeklySteps.count
                        
                        let totalDistance = distanceVM.weeklyDistance.reduce(0) { $0 + $1.distance }
                        let averageDistance = distanceVM.weeklyDistance.isEmpty ? 0 : totalDistance / Double(distanceVM.weeklyDistance.count)
                        
                        VStack(alignment: .leading, spacing: 10){
                            NavigationLink {
                                StepsCharts(stepsVM: stepsVM)
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
                                    
                                    WeeklyStepsChart(stepsVM: stepsVM)
                                        .frame(height: 75)
                                }
                            }.buttonStyle(.plain).padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(12)
                            
                            
                            NavigationLink {
                                DistancesCharts(distanceVM: distanceVM)
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
                                    
                                    WeeklyDistancesChart(distanceVM: distanceVM)
                                        .frame(height: 75)
                                }
                            }.buttonStyle(.plain).padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(12)
                        }
                    case .month:
                        
                        let totalSteps = stepsVM.monthlySteps.reduce(0) { $0 + $1.steps }
                        let averageSteps = stepsVM.monthlySteps.isEmpty ? 0 : totalSteps / stepsVM.monthlySteps.count
                        
                        let totalDistance = distanceVM.monthlyDistance.reduce(0) { $0 + $1.distance }
                        let averageDistance = distanceVM.monthlyDistance.isEmpty ? 0 : totalDistance / Double(distanceVM.monthlyDistance.count)
                        
                        VStack(alignment: .leading, spacing: 10){
                            NavigationLink {
                                StepsCharts(stepsVM: stepsVM)
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
                                    
                                    MonthlyStepsChart(stepsVM: stepsVM)
                                        .frame(height: 75)
                                }
                            }.buttonStyle(.plain).padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(12)
                            
                            
                            NavigationLink {
                                DistancesCharts(distanceVM: distanceVM)
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
                                    
                                    MonthlyDistancesChart(distanceVM: distanceVM)
                                        .frame(height: 75)
                                }
                            }.buttonStyle(.plain).padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(12)
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
                        
                        let totalDistance = distanceVM.yearlyDistance.reduce(0.0) { acc, model in
                            let daysInMonth = calendar.range(of: .day, in: .month, for: model.date)?.count ?? 0
                            return acc + (model.distance * Double(daysInMonth))
                        }
                        
                        let averageDailyDistance = daysSoFar > 0 ? totalDistance / Double(daysSoFar) : 0
                        
                        VStack(alignment: .leading, spacing: 10){
                            NavigationLink {
                                StepsCharts(stepsVM: stepsVM)
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
                                    
                                    YearlyStepsChart(stepsVM: stepsVM)
                                        .frame(height: 75)
                                }
                            }.buttonStyle(.plain).padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(12)
                            
                            
                            NavigationLink {
                                DistancesCharts(distanceVM: distanceVM)
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
                                    
                                    YearlyDistancesChart(distanceVM: distanceVM)
                                        .frame(height: 75)
                                }
                            }.buttonStyle(.plain).padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(12)
                        }
                    }
                }
                
                Spacer()
                
            }.padding(.horizontal, 20)
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
