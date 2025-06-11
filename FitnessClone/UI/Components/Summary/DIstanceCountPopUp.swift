//
//  DIstanceCountPopUp.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 02/06/25.
//

import SwiftUI

struct DistanceCountPopUp: View {
    
    @StateObject var distanceVM = DistanceViewModel()
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading, spacing: 10){
                
                NavigationLink {
                    CountAndDistanceCharts(distanceVM: distanceVM)
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
                    DistancesCharts(distanceVM: distanceVM)
                } label: {
                    VStack(alignment: .leading, spacing: 10) {
                        VStack(alignment: .leading){
                            Text("Today")
                                .font(.footnote)
                            
                            Text(String(format: "%.2f", distanceVM.distance*0.001))
                                .font(.title)
                                .fontWeight(.medium)
                                .foregroundColor(.cyanRing)
                            + Text("KM").font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(.cyanRing)
                        }
                        
                        DailyDistanceChart(distanceVM: distanceVM, isPopUp: true)
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
    DistanceCountPopUp()
}
