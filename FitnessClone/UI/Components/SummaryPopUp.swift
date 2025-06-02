//
//  SummaryPopUp.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 30/05/25.
//

import SwiftUI

struct SummaryPopUp: View {
    
    var onTap: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 10){
            
            Image(systemName: "character.duployan")
                .font(.largeTitle)
            
            VStack(alignment: .leading, spacing: 10){
                
                HStack{
                    Text("A Customisable Summary")
                        .font(.headline)
                    
                    Spacer()
                    
                    Button{
                        onTap()
                    }label: {
                        Image(systemName: "x.circle.fill")
                    }.buttonStyle(.plain)
                }
                
                Text("You can make your Summary tab your own, with custom views of everything from your distance totals and average pace to expanded views of trends and tips.")
                    .font(.callout)
                
                Divider()
                
                
                Button{
                    
                }label: {
                    Text("Edit Your Summary")
                        .font(.headline)
                        .fontWeight(.bold)
                }
            }
            
        }.padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
    }
}

#Preview {
    SummaryPopUp(onTap: {})
}
