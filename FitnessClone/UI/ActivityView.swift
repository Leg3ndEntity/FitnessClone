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
                            ProgressRing(progress: $healthVM.calories, goal: user.goal!, selectedColor: .magentaRing, width: 50)
                                .frame(width: 200, height: 200)
                            
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
                            
                        }.padding(.vertical, 50)
                        
                    }
                }
                
            }.padding(.horizontal, 30)
                .navigationTitle("Today, \(currentDate)")
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
                        Button{
                        }label: {
                            Image(systemName: "square.and.arrow.up")
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
