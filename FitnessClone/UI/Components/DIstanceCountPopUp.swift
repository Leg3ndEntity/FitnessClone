//
//  DIstanceCountPopUp.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 02/06/25.
//

import SwiftUI

struct DIstanceCountPopUp: View {
    @StateObject var healthVM = HealthViewModel.shared
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading, spacing: 10){
                
                NavigationLink {
                } label: {
                    HStack{
                        Text("Step Distance")
                            .font(.headline)
                            .foregroundStyle(.white)
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }
                
                Divider()
                
                NavigationLink {
                    DistancesCharts()
                } label: {
                    VStack(alignment: .leading, spacing: 10) {
                        VStack(alignment: .leading){
                            Text("Today")
                                .font(.footnote)
                            
                            Text(String(format: "%.2f", healthVM.distance*0.001))
                                .font(.title)
                                .fontWeight(.medium)
                                .foregroundColor(.cyan)
                            + Text("KM").font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(.cyan)
                        }
                        
                        DailyDistanceChart(isPopUp: true)
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
    DIstanceCountPopUp()
}
