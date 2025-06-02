//
//  ActivityRingCard.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 30/05/25.
//

import SwiftUI
import SwiftData

struct ActivityRingCard: View {
    
    @Query var users: [UserModel]
    
    @StateObject var healthVM = HealthViewModel.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15){
            
            Text("Activity Ring")
                .font(.headline)
            
            Divider()
            
            HStack(alignment: .center, spacing: 25){
                
                if let user = users.first {
                    ProgressRing(progress: .constant(healthVM.calories), goal: user.goal!, selectedColor: .magentaRing, width: 25)
                        .frame(width: 100, height: 100)
                    
                    VStack(alignment: .leading){
                        Text("Move")
                            .font(.title3)
                            .fontWeight(.medium)
                        
                        
                        Text("\(healthVM.calories)/\(user.goal!)")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundStyle(.magentaRing)
                        
                        + Text("KCAL")
                            .fontWeight(.medium)
                            .foregroundStyle(.magentaRing)
                    }
                }
                
            }.padding(10)
            
        }.padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(12)
    }
}

#Preview {
    ActivityRingCard()
        .modelContainer(for: UserModel.self, inMemory: true)
}
