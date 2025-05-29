//
//  UserDetailPickers.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 29/05/25.
//

import SwiftUI

enum ActivePicker {
    case birthDate, sex, height, weight, none
}

struct UserDetailPickers: View {
    var activePicker: ActivePicker
    
    @Binding var birthDate: Date
    @Binding var gender: String
    @Binding var height: String
    @Binding var weight: String
    
    let genderOptions = ["Not Set", "Male", "Female", "Other"]
    let heightOptions = (30...275).map { "\($0) cm" }
    let weightOptions = (0...454).map { "\($0) kg" }
    
    var body: some View {
        Group {
            switch activePicker {
            case .birthDate:
                DatePicker("", selection: $birthDate, displayedComponents: .date)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .frame(maxHeight: 175)
                
            case .sex:
                Picker("", selection: $gender) {
                    ForEach(genderOptions, id: \.self) { Text($0) }
                }
                .pickerStyle(.wheel)
                .frame(maxHeight: 175)
                
            case .height:
                Picker("", selection: $height) {
                    ForEach(heightOptions, id: \.self) { Text($0) }
                }
                .pickerStyle(.wheel)
                .frame(maxHeight: 175)
                
            case .weight:
                Picker("", selection: $weight) {
                    ForEach(weightOptions, id: \.self) { Text($0) }
                }
                .pickerStyle(.wheel)
                .frame(maxHeight: 175)
                
            case .none:
                EmptyView()
            }
        }
        .background(Color(.systemGray6).opacity(0.3))
        .transition(.move(edge: .bottom))
        .animation(.easeInOut, value: activePicker)
    }
}

struct UserDetailPickerView_Previews: PreviewProvider {
    @State static var sampleDate = Date()
    @State static var sampleGender = "Male"
    @State static var sampleHeight = "5' 10\""
    @State static var sampleWeight = "183 lb"

    static var previews: some View {
        Group {
            UserDetailPickers(
                activePicker: .birthDate,
                birthDate: $sampleDate,
                gender: $sampleGender,
                height: $sampleHeight,
                weight: $sampleWeight
            )
            .previewDisplayName("Date Picker")

            UserDetailPickers(
                activePicker: .sex,
                birthDate: $sampleDate,
                gender: $sampleGender,
                height: $sampleHeight,
                weight: $sampleWeight
            )
            .previewDisplayName("Gender Picker")
            
            UserDetailPickers(
                activePicker: .height,
                birthDate: $sampleDate,
                gender: $sampleGender,
                height: $sampleHeight,
                weight: $sampleWeight
            )
            .previewDisplayName("Height Picker")
            
            UserDetailPickers(
                activePicker: .weight,
                birthDate: $sampleDate,
                gender: $sampleGender,
                height: $sampleHeight,
                weight: $sampleWeight
            )
            .previewDisplayName("Weight Picker")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
