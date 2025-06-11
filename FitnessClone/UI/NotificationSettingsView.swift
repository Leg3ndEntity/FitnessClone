//
//  NotificationSettingsView.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 31/05/25.
//

import SwiftUI

struct NotificationSettingsView: View {
    var body: some View {
        
        NavigationStack{
            VStack{
                
                List{
                    Section {
                        HStack{
                            Text("Daily Coaching")
                            Toggle("", isOn: .constant(false))
                        }
                    } header: {
                        Text("ACTIVITY")
                    } footer: {
                        Text("Get notifications that help you complete your Activity goals.")
                            .font(.caption2)
                    }
                    
                    Section {
                        HStack{
                            Text("Goal Completions")
                            Toggle("", isOn: .constant(false))
                        }
                    } header: {
                    } footer: {
                        Text("Receive a notification when you close your Move ring or earn a award.")
                            .font(.caption2)
                    }
                    
                    Section {
                        HStack{
                            Text("Activity Sharing")
                            Toggle("", isOn: .constant(false))
                        }
                    } header: {
                    } footer: {
                        Text("Receive a notification when someone who shares Activity with you completes a workout or ears an award.")
                            .font(.caption2)
                    }
                    
                    
                    Section {
                        VStack{
                            HStack{
                                Text("New Features")
                                Toggle("", isOn: .constant(false))
                            }
                            HStack{
                                Text("Offers")
                                Toggle("", isOn: .constant(false))
                            }
                        }
                    } header: {
                        Text("FITNESS+")
                    } footer: {
                    }
                    
                    Section {
                        HStack{
                            Text("Fitness+ Plan Reminders")
                            Toggle("", isOn: .constant(false))
                        }
                    } header: {
                    } footer: {
                        Text("Receive a notification on days when your have a scheduled activity.")
                            .font(.caption2)
                    }
                }
                
            }.navigationTitle("Notifications")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NotificationSettingsView()
}
