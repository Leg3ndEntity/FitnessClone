//
//  StepCountPopUp.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 31/05/25.
//

import SwiftUI

struct StepCountPopUp: View {
    
    @StateObject var stepsVM = StepsViewModel()
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading, spacing: 10){
                
                NavigationLink {
                    CountAndDistanceCharts(stepsVM: stepsVM)
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
                    StepsCharts(stepsVM: stepsVM)
                } label: {
                    VStack(alignment: .leading, spacing: 10) {
                        VStack(alignment: .leading){
                            Text("Today")
                                .font(.footnote)
                            
                            Text("\(stepsVM.steps)")
                                .font(.title)
                                .fontWeight(.medium)
                                .foregroundColor(.lilacChart)
                        }
                        
                        DailyStepsChart(stepsVM: stepsVM, isPopUp: true)
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
