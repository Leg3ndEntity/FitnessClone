//
//  OnboardingRowItem.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 28/05/25.
//

import SwiftUI

struct OnboardingRowItem: View {
    
    var sfSymbol: String
    var title: String
    var bodyText: String
    
    var body: some View {
        
        HStack{
            Image(systemName: sfSymbol)
                .font(.largeTitle)
                .foregroundStyle(.accent)
                .padding()
            
            VStack(alignment: .leading){
                Text(title)
                    .font(.headline)
                Text(bodyText)
                    .font(.subheadline)
            }
        }.padding(.horizontal)
        
    }
    
}
