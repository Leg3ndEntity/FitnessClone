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
    let lineWidth: CGFloat
    let frameWidth: CGFloat
    
    let ringColors: [Color] = [.magentaRing, .magentaRingLight, .magentaRingDark]
    
    var percentage: Double {
        Double(progress) / Double(goal)
    }
    
    var fullCircles: Int {
        Int(percentage)
    }
    
    var remainingFraction: CGFloat {
        CGFloat(percentage.truncatingRemainder(dividingBy: 1.0))
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(.magentaRing.opacity(0.15), lineWidth: lineWidth)
                .frame(width: frameWidth, height: frameWidth)
            
            ForEach(0..<fullCircles, id: \.self) { index in
                let startColor = ringColors[index % ringColors.count]
                let endColor = ringColors[(index + 1) % ringColors.count]
                
                Circle()
                    .trim(from: 0, to: 1)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [startColor, endColor]),
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .frame(width: frameWidth, height: frameWidth)
            }
            
            if remainingFraction > 0 {
                let startColor = ringColors[fullCircles % ringColors.count]
                let endColor = ringColors[(fullCircles + 1) % ringColors.count]
                
                Circle()
                    .trim(from: 0, to: remainingFraction)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [startColor, endColor]),
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .frame(width: frameWidth, height: frameWidth)
            }
            
            let currentStartColor = ringColors[fullCircles % ringColors.count]

            if progress != 0 {
                Circle()
                    .foregroundStyle(currentStartColor)
                    .frame(width: lineWidth)
                    .padding(.bottom, frameWidth)
            }

        }
    }
}

#Preview {
    ProgressRing(progress: .constant(170), goal: 60, lineWidth: 50, frameWidth: 300)
}
