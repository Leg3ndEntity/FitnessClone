//
//  WorkoutListView.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 07/06/25.
//

import SwiftUI
import HealthKit

struct WorkoutListView: View {
    
    @StateObject var healthVM = HealthViewModel.shared
    @StateObject var calendarVM = CalendarViewModel.shared
    
    var groupedWorkouts: [(date: Date, workouts: [HKWorkout])] {
        let filteredList: [HKWorkout] = healthVM.workouts
        
        let sortedList: [HKWorkout] = filteredList.sorted {
            $0.startDate > $1.startDate
        }

        let grouped = Dictionary(grouping: sortedList) { workout in
            calendarVM.startOfMonth(for: workout.startDate)
        }

        return grouped
            .map { (key: Date, value: [HKWorkout]) in (date: key, workouts: value) }
            .sorted { $0.date > $1.date }
    }

    
    var body: some View {
        NavigationStack {
            VStack {
                if healthVM.workouts.isEmpty {
                    Text("No workouts available")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        VStack(alignment: .leading){
                            ForEach(groupedWorkouts, id: \.date) { group in
                                Section {
                                    ForEach(group.workouts, id: \.uuid) { workout in
                                        NavigationLink {
                                            WorkoutView(selectedWorkout: workout)
                                        } label: {
                                            WorkoutRowItem(workout: workout)
                                        }.buttonStyle(.plain)
                                    }
                                } header: {
                                    Text(calendarVM.formatMonthYear(group.date))
                                        .font(.headline)
                                        .padding(.top, 20)
                                }
                            }.listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                        }.padding(.horizontal, 20)
                    }
                }
            }.navigationTitle("Sessions")
                .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    WorkoutListView()
}
