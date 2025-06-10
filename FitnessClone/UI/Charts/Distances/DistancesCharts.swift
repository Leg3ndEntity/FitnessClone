//
//  DistancesCharts.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 02/06/25.
//


import SwiftUI
import Charts

struct DistancesCharts: View {
    
    @ObservedObject var distanceVM = DistanceViewModel()
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
                            
                            Text(String(format: "%.2f", distanceVM.distance*0.001))
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.cyanRing)
                            + Text("KM").font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(.cyanRing)
                            
                            Text("Today")
                                .font(.footnote)
                            
                            DailyDistanceChart(distanceVM: distanceVM, isPopUp: false)
                                .frame(height: 250)
                        }
                    case .week:
                        
                        let totalDistance = distanceVM.weeklyDistance.reduce(0) { $0 + $1.distance }
                        let averageDistance = distanceVM.weeklyDistance.isEmpty ? 0 : totalDistance / Double(distanceVM.weeklyDistance.count)
                        
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
                            
                            WeeklyDistancesChart(distanceVM: distanceVM)
                                .frame(height: 250)
                        }
                    case .month:
                        
                        let totalDistance = distanceVM.monthlyDistance.reduce(0) { $0 + $1.distance }
                        let averageDistance = distanceVM.monthlyDistance.isEmpty ? 0 : totalDistance / Double(distanceVM.monthlyDistance.count)
                        
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
                            
                            MonthlyDistancesChart(distanceVM: distanceVM)
                                .frame(height: 250)
                        }
                    case .year:
                        let calendar = Calendar.current
                        let now = Date()
                        let daysSoFar = calendar.ordinality(of: .day, in: .year, for: now) ?? 365

                        let totalDistance = distanceVM.yearlyDistance.reduce(0.0) { acc, model in
                            let daysInMonth = calendar.range(of: .day, in: .month, for: model.date)?.count ?? 0
                            return acc + (model.distance * Double(daysInMonth))
                        }

                        let averageDailyDistance = daysSoFar > 0 ? totalDistance / Double(daysSoFar) : 0

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
                            
                            YearlyDistancesChart(distanceVM: distanceVM)
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
