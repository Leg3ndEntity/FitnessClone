//
//  GoalViewModel.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 29/05/25.
//

import Foundation
import SwiftData

class GoalViewModel: ObservableObject {
    
    @Published var goal: Int = 120
    
    var timer: Timer?
    var durata = 0.0
    
    func loadSavedGoal(user: UserModel, modelContext: ModelContext){
        self.goal = user.goal ?? 120
    }
    
    func editGoal(user: UserModel, modelContext: ModelContext){
        user.goal = self.goal
        
        do {
            try modelContext.save()
        } catch {
            print("Error editing goal: ", error)
        }
    }
    
    func startTimer(increase: Bool) {
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { timer in
            if increase {
                self.goal += 10
            } else {
                if self.goal != 10{
                    self.goal -= 10
                }
            }
            
            self.durata += 0.2
            if self.durata >= 1 {
                self.stopTimer()
                self.startFastTimer(increase: increase)
            }
        }
    }
    
    
    func startFastTimer(increase: Bool) {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if increase {
                self.goal += 10
            } else {
                if self.goal != 10{
                    self.goal -= 10
                }
            }
        }
    }
    
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        durata = 0
    }
    
}
