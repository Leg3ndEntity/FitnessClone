//
//  FlightsViewModel.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 08/06/25.
//

import Foundation
import HealthKit

class FlightsViewModel: ObservableObject {
    
    @Published var flightsClimbed: Int = 0

    private let manager = HealthKitManager.shared

    init() {
        fetchFlightsClimbed()
    }

    
    private func fetchFlightsClimbed() {
        manager.fetchSum(for: .flightsClimbed) { self.flightsClimbed = Int($0) }
    }
    
}
