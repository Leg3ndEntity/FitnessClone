//
//  User.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 29/05/25.
//

import Foundation
import SwiftData

@Model
class UserModel{
    var id: String = UUID().uuidString
    var name: String?
    var surname: String?
    var birthDate: Date
    var gender: String
    var height: String
    var weight: String
    var goal: Int?
    
    init (name: String?, surname: String?, birthDate: Date, gender: String, height: String, weight: String, goal: Int?){
        self.name = name
        self.surname = surname
        self.birthDate = birthDate
        self.gender = gender
        self.height = height
        self.weight = weight
        self.goal = goal
    }
}
