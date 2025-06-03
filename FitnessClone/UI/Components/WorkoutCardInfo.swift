//
//  WorkoutCardInfo.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 03/06/25.
//

import SwiftUI

struct WorkoutCardInfo: View {
    
    let columns: [GridItem] = Array(repeating: GridItem(.flexible(minimum: 140)), count: 2)
    
    var duration: Double
    var distance: Double
    var kiloCalories: Double
    var pace: Double
    
    func formatDuration(_ duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: duration) ?? "--:--"
    }
    
    func formatPace(_ pace: Double) -> String {
        guard pace > 0 && pace < .infinity else { return "--'--\"" }
        let minutes = Int(pace)
        let seconds = Int(round((pace - Double(minutes)) * 60))
        return String(format: "%d'%02d\"", minutes, seconds)
    }
    
    var body: some View {
        VStack{
            LazyVGrid(columns: columns, alignment: .leading, spacing: 50) {
                VStack(alignment: .leading) {
                    Text("Workout Time")
                    Text(formatDuration(duration))
                        .font(.title)
                        .foregroundStyle(.yellow)
                }
                
                VStack(alignment: .leading) {
                    Text("Distance")
                    Text(String(format: "%.2f", distance * 0.001))
                        .font(.title)
                        .foregroundStyle(.cyanRing)
                    + Text("KM")
                        .font(.title2)
                        .foregroundStyle(.cyanRing)
                }
            }
            
            Divider()
            
            LazyVGrid(columns: columns, alignment: .leading, spacing: 50) {
                VStack(alignment: .leading) {
                    Text("Active Kilocalories")
                    Text(String(format: "%.0f", kiloCalories))
                        .font(.title)
                        .foregroundStyle(.magentaRing)
                    + Text("KCAL")
                        .font(.title2)
                        .foregroundStyle(.magentaRing)
                }
                
                VStack(alignment: .leading) {
                    Text("Avg Pace")
                    Text(formatPace(pace))
                        .font(.title)
                        .foregroundStyle(.cyan)
                    + Text("/KM")
                        .font(.title2)
                        .foregroundStyle(.cyan)
                }
            }
        }.padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(12)
    }
}
