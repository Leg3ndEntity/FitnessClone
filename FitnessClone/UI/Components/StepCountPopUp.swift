//
//  StepCountPopUp.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 31/05/25.
//

import SwiftUI

struct StepCountPopUp: View {
    
    @StateObject var healthVM = HealthViewModel.shared
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading, spacing: 10){
                
                NavigationLink {
                    CountAndDistanceCharts()
                } label: {
                    HStack{
                        Text("Step Count")
                            .font(.headline)
                            .foregroundStyle(.white)
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }
                
                Divider()
                
                NavigationLink {
                    StepsCharts()
                } label: {
                    VStack(alignment: .leading, spacing: 10) {
                        VStack(alignment: .leading){
                            Text("Today")
                                .font(.footnote)
                            
                            Text("\(healthVM.steps)")
                                .font(.title)
                                .fontWeight(.medium)
                                .foregroundColor(.lilacChart)
                        }
                        
                        DailyStepsChart(isPopUp: true)
                            .frame(height: 75)
                    }
                }.buttonStyle(.plain)
            }.padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
        }
    }
}

#Preview {
    StepCountPopUp()
}
