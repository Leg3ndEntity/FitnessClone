//
//  DistancesCharts.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 02/06/25.
//


import SwiftUI
import Charts

struct DistancesCharts: View {
    
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
                            
                            Text(String(format: "%.2f", healthVM.distance*0.001))
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.cyanRing)
                            + Text("KM").font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(.cyanRing)
                            
                            Text("Today")
                                .font(.footnote)
                            
                            DailyDistanceChart(isPopUp: false)
                                .frame(height: 250)
                        }
                    case .week:
                        
                        let totalDistance = healthVM.weeklyDistance.reduce(0) { $0 + $1.distance }
                        let averageDistance = healthVM.weeklyDistance.isEmpty ? 0 : totalDistance / Double(healthVM.weeklyDistance.count)
                        
                        VStack(alignment: .leading){
                            Text("DAILY AVARAGE")
                                .font(.footnote)
                            
                            Text("\(averageDistance*0.001, specifier: "%.2f")")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.cyanRing)
                            + Text("KM").font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(.cyanRing)
                            
                            Text("This Week")
                                .font(.footnote)
                            
                            WeeklyDistancesChart()
                                .frame(height: 250)
                        }
                    case .month:
                        
                        let totalDistance = healthVM.monthlyDistance.reduce(0) { $0 + $1.distance }
                        let averageDistance = healthVM.monthlyDistance.isEmpty ? 0 : totalDistance / Double(healthVM.monthlyDistance.count)
                        
                        VStack(alignment: .leading){
                            Text("DAILY AVARAGE")
                                .font(.footnote)
                            
                            Text("\(averageDistance*0.001, specifier: "%.2f")")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.cyanRing)
                            + Text("KM").font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(.cyanRing)
                            
                            Text(calendarVM.formatMonthYear(Date()))
                                .font(.footnote)
                            
                            MonthlyDistancesChart()
                                .frame(height: 250)
                        }
                    case .year:
                        let calendar = Calendar.current

                        let totalDistance = healthVM.yearlyDistance.reduce(0.0) { $0 + $1.distance }

                        let totalDays = healthVM.yearlyDistance.reduce(0) { sum, entry in
                            if let days = calendar.range(of: .day, in: .month, for: entry.date)?.count {
                                return sum + days
                            }
                            return sum
                        }

                        let averageDailyDistance = totalDays > 0 ? totalDistance / Double(totalDays) : 0


                        VStack(alignment: .leading){
                            Text("DAILY AVARAGE")
                                .font(.footnote)
                            
                            Text("\(averageDailyDistance*0.001, specifier: "%.2f")")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.cyanRing)
                            + Text("KM").font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(.cyanRing)
                            
                            Text(formattedYear)
                                .font(.footnote)
                            
                            YearlyDistancesChart()
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
                
            }.navigationTitle("Step Distance")
                .navigationBarTitleDisplayMode(.large)
                .padding(.horizontal, 20)
                .background {
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    Color.cyanRing.opacity(0.15),
                                    Color.cyanRing.opacity(0.0)
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
    DistancesCharts()
}
