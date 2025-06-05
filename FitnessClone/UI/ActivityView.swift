//
//  ActivityView.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 30/05/25.
//

import SwiftUI
import SwiftData

struct ActivityView: View {
    
    @Query var users: [UserModel]
    
    @StateObject var healthVM = HealthViewModel.shared
    @StateObject var exportVM = ExportViewModel()
    @StateObject var calendarVM = CalendarViewModel.shared
    
    @State var showActivityCalendar: Bool = false
    
    var calories: Int
    var steps: Int
    var distance: Double
    var flightsClimbed: Int
    var currentDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: Date())
    }
    
    var body: some View {
        NavigationStack{
            VStack{
                WeeklyActivityRingsBanner()
                ScrollView{
                    if let user = users.first {
                        VStack(spacing: 25){
                            ProgressRing(progress: $healthVM.calories, goal: user.goal!, isMainActivityRing: true, lineWidth: 50, frameWidth: 200)
                            
                            HStack{
                                VStack(alignment: .leading){
                                    Text("Move")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    
                                    Text("\(healthVM.calories)/\(user.goal!)")
                                        .font(.title)
                                        .fontWeight(.medium)
                                        .foregroundStyle(.magentaRing)
                                    
                                    + Text("KCAL")
                                        .font(.title2)
                                        .fontWeight(.medium)
                                        .foregroundStyle(.magentaRing)
                                    
                                }
                                
                                Spacer()
                                
                                Button{
                                    
                                }label: {
                                    Image(systemName: "arrow.up.circle")
                                }.foregroundStyle(.magentaRing)
                            }
                            CaloriesChart()
                                .frame(height: 100)
                            
                            VStack(alignment: .leading){
                                HStack(spacing: 50){
                                    VStack(alignment: .leading){
                                        Text("Steps")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                        
                                        Text("\(healthVM.steps)")
                                            .font(.title)
                                            .fontWeight(.medium)
                                    }
                                    
                                    VStack(alignment: .leading){
                                        Text("Distance")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                        
                                        Text(String(format: "%.2f", healthVM.distance * 0.001))
                                            .font(.title)
                                            .fontWeight(.medium)
                                        + Text("KM")
                                            .font(.title2)
                                            .fontWeight(.medium)
                                    }
                                }
                                
                                Divider()
                                
                                VStack(alignment: .leading){
                                    Text("Flights climbed")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    
                                    Text("\(healthVM.flightsClimbed)")
                                        .font(.title)
                                        .fontWeight(.medium)
                                }
                            }
                            
                        }.padding(.horizontal, 15)
                            .padding(.top, 50)
                    }
                }.scrollIndicators(.visible)
                
            }.navigationTitle("Today, \(currentDate)")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button{
                            showActivityCalendar.toggle()
                        }label: {
                            Image(systemName: "calendar")
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if let user = users.first {
                            let url = exportVM.renderProgressRingView(progress: healthVM.calories, goal: user.goal!, formattedDate: calendarVM.formatShortDate(Date()))
                            
                            ShareLink("Share Progress", item: url, message: Text("Check out my progress today with the Fitness app."))
                            
                        }
                    }
                }
                .sheet(isPresented: $showActivityCalendar) {
                    MonthlyActivityRings()
                }
        }
    }
}

#Preview {
    ActivityView(calories: 120, steps: 546, distance: 0.34, flightsClimbed: 3)
}
