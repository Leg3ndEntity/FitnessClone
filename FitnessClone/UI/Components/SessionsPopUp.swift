//
//  SessionsPopUp.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 03/06/25.
//

import SwiftUI

struct SessionsPopUp: View {
    
    @StateObject var healthVM = HealthViewModel.shared
    @StateObject var calendarVM = CalendarViewModel.shared
    
    var body: some View {
        if let workout = healthVM.workouts.first {
            NavigationStack{
                VStack(alignment: .leading, spacing: 10){
                    
                    NavigationLink {
                        WorkoutListView()
                    } label: {
                        HStack{
                            Text("Sessions")
                                .font(.headline)
                                .foregroundStyle(.white)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                    
                    Divider()
                    
                    NavigationLink {
                        WorkoutView(selectedWorkout: workout)
                    } label: {
                        VStack(alignment: .leading, spacing: 10) {
                            
                            Image(systemName: "figure.walk.circle.fill")
                                .font(.title)
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(Color.accentColor)
                            
                            if let workout = healthVM.workouts.first,
                               let distance = workout.totalDistance?.doubleValue(for: .meter()) {
                                
                                VStack(alignment: .leading){
                                    Text("Outdoor Walk")
                                    
                                    Text(String(format: "%.2f", distance * 0.001))
                                        .font(.title)
                                        .fontWeight(.medium)
                                        .foregroundColor(Color.accentColor)
                                    + Text("KM")
                                        .font(.title2)
                                        .fontWeight(.medium)
                                        .foregroundColor(Color.accentColor)
                                }
                                
                                Text(calendarVM.formatFullDate(workout.startDate))
                                    .font(.footnote)
                            }
                            
                        }
                    }.buttonStyle(.plain)
                }.padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12)
            }
        }
    }
}

#Preview {
    SessionsPopUp()
}
