//
//  StepModel.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 31/05/25.
//

import Foundation

struct StepModel: Identifiable {
    let id = UUID()
    let date: Date
    let steps: Int
}
