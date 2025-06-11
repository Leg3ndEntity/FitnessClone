//
//  EditUserDetailView.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 10/06/25.
//

import SwiftUI
import SwiftData

struct EditUserDetailView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Query var users: [UserModel] = []
    
    @StateObject var userVM = UserViewModel()
    @StateObject var calendarVM = CalendarViewModel.shared
    
    @State var activePicker: ActivePicker = .none
    
    @State var birthDate = Date()
    @State var gender = "Not Set"
    @State var height = "170 cm"
    @State var weight = "70 kg"
    
    @State var tempBirthDate = Date()
    @State var tempGender = "Not Set"
    @State var tempHeight = "170 cm"
    @State var tempWeight = "70 kg"
    
    var body: some View {
        NavigationStack{
            VStack{
                
                ScrollView{
                    VStack(spacing: 10){
                        Text("Personalise Fitness and Health")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("This information ensures Fitness and Health data are as accurate as possible. These datails are not shared with Apple.")
                    }.multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    List{
                        HStack{
                            Text("Date of birth")
                            Spacer()
                            Text(calendarVM.formatShortDate(birthDate)).foregroundColor((activePicker == .birthDate) ? .accent : .gray)
                        }.onTapGesture {
                            if activePicker == .none {
                                tempBirthDate = birthDate
                            }
                            activePicker = (activePicker == .birthDate) ? .none : .birthDate
                        }
                        
                        HStack{
                            Text("Sex")
                            Spacer()
                            Text(gender).foregroundColor((activePicker == .sex) ? .accent : .gray)
                        }.onTapGesture {
                            if activePicker == .none {
                                tempGender = gender
                            }
                            activePicker = (activePicker == .sex) ? .none : .sex
                        }
                        
                        HStack{
                            Text("Height")
                            Spacer()
                            Text(height).foregroundColor((activePicker == .height) ? .accent : .gray)
                        }.onTapGesture {
                            if activePicker == .none {
                                tempHeight = height
                            }
                            activePicker = (activePicker == .height) ? .none : .height
                        }
                        
                        HStack{
                            Text("Weight")
                            Spacer()
                            Text(weight).foregroundColor((activePicker == .weight) ? .accent : .gray)
                        }.onTapGesture {
                            if activePicker == .none {
                                tempWeight = weight
                            }
                            activePicker = (activePicker == .weight) ? .none : .weight
                        }
                        
                    }.frame(height: 250)
                }
                
                Button{
                    userVM.editUser(user: users.first!, birthDate: birthDate, gender: gender, height: height, weight: weight, modelContext: modelContext)
                    dismiss()
                }label: {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                
                if activePicker != .none {
                    UserDetailPickers(activePicker: activePicker, birthDate: $birthDate, gender: $gender, height: $height, weight: $weight)
                }
                
            }.padding(20)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button{
                            tempBirthDate = birthDate
                            tempGender = gender
                            tempHeight = height
                            tempWeight = weight
                            activePicker = .none
                        }label: {
                            Text("Done")
                                .fontWeight(.medium)
                        }.opacity(activePicker == .none ? 0 : 1)
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button{
                            birthDate = tempBirthDate
                            gender = tempGender
                            height = tempHeight
                            weight = tempWeight
                            activePicker = .none
                        }label: {
                            Text("Cancel")
                        }.opacity(activePicker == .none ? 0 : 1)
                        
                    }
                }
                .onAppear{
                    if let user = users.first{
                        (birthDate, tempBirthDate) = (user.birthDate, user.birthDate)
                        (gender, tempGender) = (user.gender, user.gender)
                        (height, tempHeight) = (user.height, user.height)
                        (weight, tempWeight) = (user.weight, user.weight)
                    }
                }
        }
    }
}

#Preview {
    EditUserDetailView()
}
