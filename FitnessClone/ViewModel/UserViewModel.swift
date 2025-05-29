//
//  UserViewModel.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 29/05/25.
//

import SwiftUI
import SwiftData

class UserViewModel: ObservableObject {
    
    @Published var user: UserModel?

//    static let shared = UserViewModel()
//    private init() { }
    
    func createUser(name: String?, surname: String?, birthDate: Date, gender: String, height: String, weight: String, modelContext: ModelContext){
        let newUser = UserModel(name: name ?? nil, surname: surname ?? nil, birthDate: birthDate, gender: gender, height: height, weight: weight, goal: nil)
        
        modelContext.insert(newUser)
    }
    
    func editUser(user: UserModel, name: String?, surname: String?, birthDate: Date, gender: String, height: String, weight: String, modelContext: ModelContext){

    }
    
    func deleteUser(user: UserModel, modelContext: ModelContext){
        modelContext.delete(user)
    }
    
    
}
