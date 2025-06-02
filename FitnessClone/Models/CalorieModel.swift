//
//  CalorieModel.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 01/06/25.
//

import Foundation

struct CalorieModel: Identifiable {
    let id = UUID()
    let date: Date
    let calories: Int
}
