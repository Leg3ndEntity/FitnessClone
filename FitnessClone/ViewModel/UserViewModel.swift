//
//  UserViewModel.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 29/05/25.
//

import Foundation
import SwiftData

class UserViewModel: ObservableObject {
    
    func createUser(birthDate: Date, gender: String, height: String, weight: String, modelContext: ModelContext){
        let newUser = UserModel(birthDate: birthDate, gender: gender, height: height, weight: weight, goal: nil)
        
        modelContext.insert(newUser)
    }
    
    
    func editUser(user: UserModel, birthDate: Date, gender: String, height: String, weight: String, modelContext: ModelContext){
        user.birthDate = birthDate
        user.gender = gender
        user.height = height
        user.weight = weight
        
        do {
            try modelContext.save()
        } catch {
            print("Error editing user: ", error)
        }
    }
    
}
