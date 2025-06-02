//
//  UnitsListView.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 31/05/25.
//

import SwiftUI

struct UnitsListView: View {

    let energyUnits: [String] = ["Calories", "Kilocalories", "Kilojoules"]
    @State var selectedEnergyUnit: String?
    
    let lenghtUnits: [String] = ["Yards", "Metres"]
    @State var selectedLenghtUnit: String?
    
    let tracktUnits: [String] = ["Miles", "Metres"]
    @State var selectedTracktUnit: String?
    
    let distanceUnits: [String] = ["Miles", "Kilometres"]
    @State var selectedCyclingUnit: String?
    @State var selectedWalkingRunningUnit: String?
    @State var selectedCrossCountrySkiingUnit: String?
    @State var selectedDownhillSnowUnit: String?
    @State var selectedRowingUnit: String?
    @State var selectedPaddlingUnit: String?
    @State var selectedSkatingUnit: String?

    var body: some View {
        
        NavigationStack{
            VStack{
                
                List{
                    Section("ENERGY UNITS") {
                        UnitsList(units: energyUnits, selectedUnit: $selectedEnergyUnit)
                    }
                    
                    Section("POOL LENGHT UNITS") {
                        UnitsList(units: lenghtUnits, selectedUnit: $selectedLenghtUnit)
                    }
                    
                    Section("CYCLING WORKOUTS") {
                        UnitsList(units: distanceUnits, selectedUnit: $selectedCyclingUnit)
                    }
                    
                    Section("WALKING AND RUNNING WORKOUTS") {
                        UnitsList(units: distanceUnits, selectedUnit: $selectedWalkingRunningUnit)
                    }
                    
                    Section("AUTOMATIC TRACK DETECTION") {
                        UnitsList(units: tracktUnits, selectedUnit: $selectedTracktUnit)
                    }
                    
                    Section("CROSS COUNTRY SKIING WORKOUTS") {
                        UnitsList(units: tracktUnits, selectedUnit: $selectedCrossCountrySkiingUnit)
                    }
                    
                    Section("DOWNHILL SNOW SPORTS WORKOUTS") {
                        UnitsList(units: distanceUnits, selectedUnit: $selectedDownhillSnowUnit)
                    }
                    
                    Section("ROWING WORKOUTS") {
                        UnitsList(units: distanceUnits, selectedUnit: $selectedRowingUnit)
                    }
                    
                    Section("PADDLING WORKOUTS") {
                        UnitsList(units: distanceUnits, selectedUnit: $selectedPaddlingUnit)
                    }
                    
                    Section("SKATING SPORTS WORKOUTS") {
                        UnitsList(units: distanceUnits, selectedUnit: $selectedSkatingUnit)
                    }
                }
                
            }.navigationTitle("Units of Measure")
                .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

#Preview {
    UnitsListView()
}
