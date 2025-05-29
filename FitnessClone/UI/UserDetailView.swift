//
//  UserDetailView.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 28/05/25.
//

import SwiftUI

struct UserDetailView: View {
    @Environment(\.modelContext) var modelContext
    @StateObject var userVM = UserViewModel()
    
    @State var activePicker: ActivePicker = .none
    
    @State var showUserGoalView: Bool = false
    
    @State var birthDate = Date()
    @State var tempBirthDate = Date()
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: birthDate)
    }
    
    @State var gender: String = "Not Set"
    @State var tempGender = "Not Set"
    
    @State var height = "170 cm"
    @State var tempHeight = "170 cm"
    
    @State var weight = "70 kg"
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
                            Text(formattedDate).foregroundColor((activePicker == .birthDate) ? .accent : .gray)
                        }.onTapGesture {
                            if activePicker == .birthDate {
                                activePicker = .none
                            } else {
                                tempBirthDate = birthDate
                                activePicker = .birthDate
                            }
                        }
                        
                        HStack{
                            Text("Sex")
                            Spacer()
                            Text(gender).foregroundColor((activePicker == .sex) ? .accent : .gray)
                        }.onTapGesture {
                            if activePicker == .sex {
                                activePicker = .none
                            } else {
                                tempGender = gender
                                activePicker = .sex
                            }
                        }
                        
                        HStack{
                            Text("Height")
                            Spacer()
                            Text(height).foregroundColor((activePicker == .height) ? .accent : .gray)
                        }.onTapGesture {
                            if activePicker == .height {
                                activePicker = .none
                            } else {
                                tempHeight = height
                                activePicker = .height
                            }
                        }
                        
                        HStack{
                            Text("Weight")
                            Spacer()
                            Text(weight).foregroundColor((activePicker == .weight) ? .accent : .gray)
                        }.onTapGesture {
                            if activePicker == .weight {
                                activePicker = .none
                            } else {
                                tempWeight = weight
                                activePicker = .weight
                            }
                        }
                        
                    }.frame(height: 250)
                }
                
                Button{
                    userVM.createUser(name: "", surname: "", birthDate: birthDate, gender: gender, height: height, weight: weight, modelContext: modelContext)
                    showUserGoalView.toggle()
                }label: {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
//                .disabled(true)
                
                if activePicker != .none {
                    UserDetailPickers(activePicker: activePicker, birthDate: $birthDate, gender: $gender, height: $height, weight: $weight)
                }
                
            }.padding(20)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button{
                            activePicker = .none
                        }label: {
                            Text("Done")
                                .fontWeight(.medium)
                        }.opacity(activePicker == .none ? 0 : 1)
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button{
                            switch activePicker {
                            case .birthDate: birthDate = tempBirthDate
                            case .sex: gender = tempGender
                            case .height: height = tempHeight
                            case .weight: weight = tempWeight
                            default: break
                            }
                            activePicker = .none
                        }label: {
                            Text("Cancel")
                        }.opacity(activePicker == .none ? 0 : 1)
                        
                    }
                }.navigationDestination(isPresented: $showUserGoalView) {
                    UserGoalView()
                }
        }
    }
}

#Preview {
    UserDetailView()
}
