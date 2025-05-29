//
//  Onboarding.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 28/05/25.
//

import SwiftUI

struct Onboarding: View {
    
    @State var showUserDetailView: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 25.0){
                
                Spacer()
                
                Text("Welcome to Fitness")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                OnboardingRowItem(sfSymbol: "gauge", title: "See Your Activity", bodyText: "Keep up with your rings, workouts, awards, and trends.")
                
                OnboardingRowItem(sfSymbol: "figure.run.circle.fill", title: "Learn About Fitness+", bodyText: "Explore workouts and meditations for all levels from the world's top trainers.")
                
                OnboardingRowItem(sfSymbol: "person.2", title: "Share With Others", bodyText: "Cheer on your friends as all of you close your rings.")
                
                Spacer()
                
                Button{
                    showUserDetailView.toggle()
                }label: {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                
            }.padding(.horizontal)
                .navigationDestination(isPresented: $showUserDetailView) {
                    UserDetailView()
                }
        }
    }
    
}

#Preview {
    Onboarding()
}
