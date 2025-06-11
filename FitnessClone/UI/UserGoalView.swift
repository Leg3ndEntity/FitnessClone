//
//  UserGoalView.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 29/05/25.
//

import SwiftUI
import SwiftData

enum PickerMode: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    
    case light = "Lightly"
    case medium = "Moderately"
    case high = "Highly"
}

struct UserGoalView: View {
    @AppStorage("IsFirstTime") var isFirstTime: Bool = true
    
    @Environment(\.modelContext) var modelContext
    @Query var users: [UserModel]
    
    @StateObject var goalVM = GoalViewModel()
    
    @State var selectedMode: PickerMode = .light
    
    var body: some View {
        VStack(spacing: 25){
            
            VStack(spacing: 10){
                Text("Your Daily \nMove Goal")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Set a goal based on how active you are, or how active you'd like to be, each day.")
            }.multilineTextAlignment(.center)
                .padding(.horizontal, 20)
    
            Picker("Mode", selection: $selectedMode) {
                ForEach(PickerMode.allCases) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }.pickerStyle(SegmentedPickerStyle())
                .onChange(of: selectedMode) {
                    switch selectedMode {
                    case .light:
                        goalVM.goal = 120
                    case .medium:
                        goalVM.goal = 150
                    case .high:
                        goalVM.goal = 180
                    }
                }
            
            UserGoalCounter(goalVM: goalVM)
            
            Spacer()
            
            Button{
                isFirstTime = false
                if let user = users.first {
                    user.goal = goalVM.goal
                    try? modelContext.save()
                }
            }label: {
                Text("Set Move Goal")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            
        }.padding(30)
            .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    UserGoalView()
}
