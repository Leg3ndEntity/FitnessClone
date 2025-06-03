//
//  WorkoutView.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 03/06/25.
//

import SwiftUI
import Charts

struct WorkoutView: View {
    
    @StateObject var healthVM = HealthViewModel.shared
    @StateObject var calendarVM = CalendarViewModel.shared
    @StateObject var exportVM = ExportViewModel()
    
    var body: some View {
        NavigationStack{
            
            if let workout = healthVM.workouts.first{
                VStack(alignment: .leading){
                    
                    VStack(alignment: .leading){
                        Text(healthVM.workoutType)
                            .fontWeight(.bold)
                        Text("\(calendarVM.formatHour(workout.startDate)) - \(calendarVM.formatHour(workout.endDate))")
                            .font(.footnote)
                    }.padding(.bottom, 15)
                    
                    Text("Workout Details")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    WorkoutCardInfo(duration: healthVM.workoutDuration, distance: healthVM.workoutDuration, kiloCalories: healthVM.workoutActiveCalories, pace: healthVM.workoutAveragePace)
                    
                    Spacer()
                    
                }.padding(20)
                    .navigationTitle(calendarVM.formatFullWeekdayDate(workout.startDate))
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            
                            let url = exportVM.renderWorkoutCardView(type: healthVM.workoutType, duration: healthVM.workoutDuration, distance: healthVM.workoutDuration, kiloCalories: healthVM.workoutActiveCalories, pace: healthVM.workoutAveragePace)
                            
                            ShareLink("Share Workout Card", item: url, message: Text("Check out my progress today with the Fitness app."))
                            
                        }
                    }
                
            }
        }
    }
    
}

#Preview {
    WorkoutView()
}
