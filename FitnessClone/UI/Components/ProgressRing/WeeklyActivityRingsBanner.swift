//
//  WeeklyActivityRingsBanner.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 02/06/25.
//

import SwiftUI
import SwiftData

struct WeeklyActivityRingsBanner: View {
    
    @Query var users: [UserModel]
    @ObservedObject var caloriesVM = CaloriesViewModel()
    
    var body: some View {
        if let user = users.first {
            HStack(spacing: 20){
                ForEach(caloriesVM.weeklyCalories){ entry in
                    VStack {
                        
                        let initial = entry.date.formatted(.dateTime.weekday(.abbreviated)).prefix(1).uppercased()
                        let isToday = Calendar.current.isDateInToday(entry.date)
                        
                        ZStack {
                            if isToday {
                                Circle()
                                    .fill(Color.magentaRing)
                                    .frame(width: 20, height: 20)
                            }
                            Text(initial)
                                .font(.caption)
                                .fontWeight(.semibold)
                        }.frame(width: 20, height: 20)
                        ProgressRing(progress: .constant(entry.calories), goal: user.goal!, lineWidth: 7.5, frameWidth: 35)
                        
                    }
                    
                }
            }
        }
    }
}

#Preview {
    WeeklyActivityRingsBanner()
}
