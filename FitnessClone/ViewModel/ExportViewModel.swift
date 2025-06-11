//
//  ExportViewModel.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 03/06/25.
//

import SwiftUI

@MainActor
class ExportViewModel: ObservableObject {
    
    func createExportableProgressRing(progress: Int, goal: Int, formattedDate: String) -> some View {
        ZStack{
            Rectangle()
                .frame(width: 300, height: 300)
            
            VStack(spacing: 40) {
                ProgressRing(progress: .constant(progress), goal: goal, isMainActivityRing: true, lineWidth: 40, frameWidth: 150)
                
                Text(formattedDate)
                    .font(.callout)
                    .foregroundStyle(.white)
            }
            .padding()
            .background(Color.black)
        }
    }
    
    
    func renderProgressRingView(progress: Int, goal: Int, formattedDate: String) -> URL {
        let viewToExport = createExportableProgressRing(progress: progress, goal: goal, formattedDate: formattedDate)
        let renderer = ImageRenderer(content: viewToExport)
        renderer.scale = 2.0
        
        if let uiImage = renderer.uiImage, let pngData = uiImage.pngData() {
            let tempDir = FileManager.default.temporaryDirectory
            let fileURL = tempDir.appendingPathComponent("progress.png")
            
            do {
                try pngData.write(to: fileURL)
                return fileURL
            } catch {
                return URL(fileURLWithPath: "")
            }
        }
        
        return URL(fileURLWithPath: "")
    }
    
    
    func createWorkoutCard(type: String, duration: Double, distance: Double, avgKiloCalories: Double, pace: Double, totalKiloCalories: Double, heartRate: Int) -> some View {
        
        VStack(alignment: .leading, spacing: 10) {
            Text(type)
                .font(.title)
            WorkoutCardInfo(duration: duration, distance: distance, kiloCalories: avgKiloCalories, pace: pace, totalKiloCalories: totalKiloCalories, heartRate: heartRate)
        }
        .padding()
        .foregroundStyle(.white)
        
    }
    
    func renderWorkoutCardView(type: String, duration: Double, distance: Double, kiloCalories: Double, pace: Double, totalKiloCalories: Double, heartRate: Int) -> URL {
        let viewToExport = createWorkoutCard(type: type, duration: duration, distance: distance, avgKiloCalories: kiloCalories, pace: pace, totalKiloCalories: totalKiloCalories, heartRate: heartRate)
        let renderer = ImageRenderer(content: viewToExport)
        renderer.scale = 2.0
        
        if let uiImage = renderer.uiImage, let pngData = uiImage.pngData() {
            let tempDir = FileManager.default.temporaryDirectory
            let fileURL = tempDir.appendingPathComponent("workoutCard.png")
            
            do {
                try pngData.write(to: fileURL)
                return fileURL
            } catch {
                return URL(fileURLWithPath: "")
            }
        }
        
        return URL(fileURLWithPath: "")
    }
    
}
