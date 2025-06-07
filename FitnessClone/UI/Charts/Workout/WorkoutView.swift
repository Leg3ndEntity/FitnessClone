//
//  WorkoutView.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 03/06/25.
//

import SwiftUI
import HealthKit

struct WorkoutView: View {
    
    @StateObject var healthVM = HealthViewModel.shared
    @StateObject var calendarVM = CalendarViewModel.shared
    @StateObject var exportVM = ExportViewModel()
    
    var selectedWorkout: HKWorkout
    
    var body: some View {
        NavigationStack{
            
            let metrics = healthVM.workoutMetrics(for: selectedWorkout)
                
                VStack(alignment: .leading) {
                    
                    VStack(alignment: .leading) {
                        Text(selectedWorkout.workoutActivityType.name)
                            .fontWeight(.bold)
                        Text("\(calendarVM.formatHour(selectedWorkout.startDate)) - \(calendarVM.formatHour(selectedWorkout.endDate))")
                            .font(.footnote)
                    }
                    .padding(.bottom, 15)
                    
                    Text("Workout Details")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    WorkoutCardInfo(duration: metrics.duration, distance: metrics.distance, kiloCalories: metrics.activeKilocalories, pace: metrics.averagePace, totalKiloCalories: metrics.totalKilocalories, heartRate: Int(metrics.averageHeartRate))
                    
                    Spacer()
                    
                }
                .padding(20)
                .navigationTitle(calendarVM.formatFullWeekdayDate(selectedWorkout.startDate))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        let url = exportVM.renderWorkoutCardView(type: selectedWorkout.workoutActivityType.name, duration: metrics.duration, distance: metrics.distance, kiloCalories: metrics.activeKilocalories, pace: metrics.averagePace, totalKiloCalories: metrics.totalKilocalories, heartRate: Int(metrics.averageHeartRate))
                        
                        ShareLink("Share Workout Card", item: url, message: Text("Check out my progress today with the Fitness app."))
                    }
                }
            
        }
    }
    
}
