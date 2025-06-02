//
//  ProgressRing.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 02/06/25.
//

import SwiftUI

struct ProgressRing: View {
    
    @Binding var progress: Int
    
    var goal: Int
    var selectedColor: Color
    let width: CGFloat
    
    var body: some View {
        ZStack{
            Circle()
                .stroke(selectedColor.opacity(0.15), lineWidth: width)
            
            Circle()
                .trim(from: 0, to: CGFloat (progress) / CGFloat (goal))
                .stroke(selectedColor, style: StrokeStyle(lineWidth: width, lineCap: .round))
                .rotationEffect(.degrees(-90))
            
        }
    }
}

#Preview {
    ProgressRing(progress: .constant(60), goal: 120, selectedColor: .magentaRing, width: 50)
}
