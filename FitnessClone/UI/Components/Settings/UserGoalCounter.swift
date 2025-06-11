//
//  UserGoalCounter.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 29/05/25.
//

import SwiftUI

struct UserGoalCounter: View {
    
    @ObservedObject var goalVM = GoalViewModel()
    
    var body: some View {
        
        VStack{
            
            HStack{
                Button{
                    if goalVM.goal != 10 {
                        goalVM.goal -= 10
                    }
                }label: {
                    Image(systemName: "minus.circle.fill")
                        .resizable()
                        .font(.largeTitle)
                        .foregroundStyle(.magentaRing)
                        .frame(width: 50, height: 50)
                }.disabled(goalVM.goal == 10)
                .onLongPressGesture(minimumDuration: 5, pressing: { isPressing in
                    if isPressing {
                        goalVM.startTimer(increase: false)
                    } else {
                        goalVM.stopTimer()
                    }
                }){}
                
                Text("\(goalVM.goal)")
                    .font(.system(size: 65, weight: .bold, design: .rounded))
                    .frame(width: 200)
                
                Button{
                    goalVM.goal += 10
                }label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .font(.largeTitle)
                        .foregroundStyle(.magentaRing)
                        .frame(width: 50, height: 50)
                }.onLongPressGesture(minimumDuration: 5, pressing: { isPressing in
                    if isPressing {
                        goalVM.startTimer(increase: true)
                    } else {
                        goalVM.stopTimer()
                    }
                }){}
            }
            
            Text("KILOCALORIES/DAY")
                .font(.system(size: 25, weight: .bold))
                
        }.padding(.vertical, 20)
        
    }
}

#Preview {
    UserGoalCounter()
}
