//
//  SummaryView.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 29/05/25.
//

import SwiftUI
import SwiftData

struct SummaryView: View {
    @AppStorage("showPopUp") var showPopUp: Bool = true
    
    @StateObject var calendarVM = CalendarViewModel.shared
    
    @Query var users: [UserModel]
    @State var showAccountView: Bool = false
    
    @State var showInlineTitle: Bool = false
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                VStack{
                    
                    HStack{
                        VStack(alignment: .leading) {
                            Text(calendarVM.formatFullWeekdayDate(Date()))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text("Summary")
                                .font(.largeTitle)
                                .bold()
                        }
                        
                        Spacer()
                        
                        Button{
                            showAccountView.toggle()
                        }label: {
                            Image(systemName: "person.circle")
                        }
                    }.opacity(showInlineTitle ? 0 : 1)
                    
                    GeometryReader { geo in
                        Color.clear
                            .onChange(of: geo.frame(in: .named("scroll")).minY) { newValue in
                                if newValue < 30 {
                                    showInlineTitle = true
                                } else {
                                    showInlineTitle = false
                                }
                            }
                    }
                    .frame(height: 0)
                    
                    if showPopUp{
                        SummaryPopUp(onTap: {showPopUp = false})
                    }
                    
                    NavigationLink{
                        ActivityView(calories: 120, steps: 546, distance: 0.34, flightsClimbed: 3)
                    }label:{
                        ActivityRingCard()
                    }.buttonStyle(.plain)
                    
                    
                    let columns = Array(repeating: GridItem(spacing: 10), count: 2)
                    LazyVGrid(columns: columns, spacing: 10) {
                        
                        StepCountPopUp()
                        DIstanceCountPopUp()
                        
                    }
                    
                    Button{
                    }label: {
                        Text("Edit Summary")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(12)
                    }
                    
                    Button{
                    }label: {
                        Text("See All Categories")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(12)
                    }
                }.padding(.horizontal, 20)
                    .sheet(isPresented: $showAccountView) {
                        AccountView()
                    }
            }.navigationTitle(showInlineTitle ? "Summary" : "")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarHidden(false)
                .coordinateSpace(name: "scroll")
            
        }
    }
}

#Preview {
    SummaryView()
}
