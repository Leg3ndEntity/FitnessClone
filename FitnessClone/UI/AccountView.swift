//
//  AccountView.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 30/05/25.
//

import SwiftUI

struct AccountView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var name: String = "dsdsdsds"
    @State var surname: String = "ffgfg"
    @State var email: String = "saddsadsaasd"
    
    var body: some View {
        NavigationStack{
            VStack{
                
                ScrollView{
                    List{
                        Section{
                            
                            NavigationLink {
                                
                            } label: {
                                HStack(spacing: 25){
                                    Image(systemName: "person.circle")
                                    
                                    VStack(alignment: .leading){
                                        Text("\(name) \(surname)")
                                        Text(email)
                                    }
                                }
                            }
                        }
                        
                        Section{
                            NavigationLink("Health Details") {
                                UserDetailView()
                            }
                            NavigationLink("Change Move Goal") {
                                UserGoalView()
                            }
                            NavigationLink("Units of Measure") {
                                UnitsListView()
                            }
                        }
                        
                        Section{
                            NavigationLink("Notifications") {
                                NotificationSettingsView()
                            }
                        }
                        Section{
                            Button{
                                
                            }label:{
                                Text("Redeeem Gift Card or Code")
                            }
                            Button{
                                
                            }label:{
                                Text("Send Gift Card by Email")
                            }
                        }
                        Section{
                            NavigationLink("Apple Fitness Privacy") {
                            }
                        }
                    }.frame(height: 550)
                }.scrollIndicators(.hidden)
                
            }.navigationTitle("Account")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button{
                            dismiss()
                        }label: {
                            Text("Done")
                                .fontWeight(.medium)
                        }
                    }
                }
        }
    }
}

#Preview {
    AccountView()
}
