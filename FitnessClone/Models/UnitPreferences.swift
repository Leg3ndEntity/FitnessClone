//
//  UnitPreferences.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 31/05/25.
//

import Foundation
import SwiftData

@Model
class UnitPreferences {
    var energyUnit: String?
    var poolLengthUnit: String?
    var trackDetectionUnit: String?
    
    var cyclingUnit: String?
    var walkingRunningUnit: String?
    var crossCountrySkiingUnit: String?
    var downhillSnowUnit: String?
    var rowingUnit: String?
    var paddlingUnit: String?
    var skatingUnit: String?
    
    init() {}
}
