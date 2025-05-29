//
//  SummaryView.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 29/05/25.
//

import SwiftUI
import SwiftData

struct SummaryView: View {
    @Query var users: [UserModel]

    var body: some View {
        VStack{
            if let user = users.first {
                Text("Goal: \(user.goal)")
            }
        }.navigationBarBackButtonHidden(true)
    }
}
