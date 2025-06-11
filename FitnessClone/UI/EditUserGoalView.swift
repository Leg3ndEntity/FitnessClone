//
//  EditUserGoalView.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 10/06/25.
//

import SwiftUI
import SwiftData

struct EditUserGoalView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Query var users: [UserModel]
    
    @StateObject var goalVM = GoalViewModel()
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 25){
                
                VStack(spacing: 10){
                    Text("Daily Move Goal")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Set a goal based on how active you are, or how active you'd like to be, each day.")
                }.multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Spacer()
                
                UserGoalCounter(goalVM: goalVM)
                
                Spacer()
                
                Button{
                    if let user = users.first {
                        goalVM.editGoal(user: user, modelContext: modelContext)
                        dismiss()
                    }
                }label: {
                    Text("Change Move Goal")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                }
                
            }.padding(30)
                .navigationBarBackButtonHidden(true)
                .onAppear{
                    if let user = users.first {
                        goalVM.loadSavedGoal(user: user, modelContext: modelContext)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Button{
//                        }label: {
//                            HStack{
//                                Image(systemName: "calendar.badge.clock")
//                                    .font(.caption)
//                                Text("Schedule")
//                            }
//                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button{
                            dismiss()
                        }label: {
                            Text("Cancel")
                        }
                        
                    }
                }
        }
    }
}

#Preview {
    EditUserGoalView()
}
