//
//  WorkoutRowItem.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 07/06/25.
//

import SwiftUI
import HealthKit

struct WorkoutRowItem: View {
    
    @StateObject var calendarVM = CalendarViewModel.shared
    let workout: HKWorkout
    
    var body: some View {
        
        HStack(alignment: .bottom, spacing: 25){
            VStack(alignment: .leading, spacing: 5) {
                Text(workout.workoutActivityType.name)
                
                let distanceInKm = (workout.totalDistance?.doubleValue(for: .meter()) ?? 0) * 0.001
                Text(String(format: "%.2f km", distanceInKm))
                    .font(.title)
                    .foregroundStyle(.accent)
            }
            
            Spacer()
            
            Text(calendarVM.formatFullDate(workout.startDate))
                .font(.caption)
                .foregroundColor(.gray)
        }.padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(12)
    }
}
