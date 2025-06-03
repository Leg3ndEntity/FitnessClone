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
        NavigationStack{
            VStack(alignment: .leading, spacing: 10){
                
                NavigationLink {
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
                    WorkoutView()
                } label: {
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Image(systemName: "figure.walk.circle.fill")
                            .font(.title)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(Color.accentColor)
                        
                        VStack(alignment: .leading){
                            Text("Outdoor Walk")
                            
                            Text(String(format: "%.2f", healthVM.workoutDistance * 0.001))
                                .font(.title)
                                .fontWeight(.medium)
                                .foregroundColor(Color.accentColor)
                            + Text("KM")
                                .font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(Color.accentColor)
                        }
                        
                        Text(calendarVM.formatFullDate(Date()))
                            .font(.footnote)
                    }
                }.buttonStyle(.plain)
            }.padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
        }
    }
}

#Preview {
    SessionsPopUp()
}
