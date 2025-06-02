//
//  UnitsList.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 31/05/25.
//

import SwiftUI

struct UnitsList: View {
    
    var units: [String]
    @Binding var selectedUnit: String?
    
    var body: some View {
        ForEach(units, id: \.self) { unit in
            Button {
                selectedUnit = unit
            } label: {
                HStack {
                    Text(unit)
                        .foregroundStyle(.white)
                    Spacer()
                    if selectedUnit == unit {
                        Image(systemName: "checkmark")
                    }
                }
            }
        }
    }
}

#Preview {
    UnitsList(units: ["km", "m", "cm"], selectedUnit: .constant("km"))
}
