//
//  FitnessCloneApp.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 28/05/25.
//

import SwiftUI
import SwiftData

@main
struct FitnessCloneApp: App {
    @AppStorage("IsFirstTime") var isFirstTime: Bool = true

    var body: some Scene {
        WindowGroup {
            if isFirstTime{
                Onboarding()
                    .preferredColorScheme(.dark)
            }else{
                SummaryView()
                    .preferredColorScheme(.dark)
            }
        }.modelContainer(for: UserModel.self)
    }
    
}
