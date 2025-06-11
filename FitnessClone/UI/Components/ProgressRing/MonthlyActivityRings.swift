//
//  MonthlyActivityRings.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 02/06/25.
//

import SwiftUI
import SwiftData

struct MonthlyActivityRings: View {
    
    @Query var users: [UserModel]
    @ObservedObject var caloriesVM = CaloriesViewModel()
    @StateObject var calendarVM = CalendarViewModel.shared
    
    var body: some View {
        if let user = users.first {
            let calendar = Calendar.current
            let now = Date()
            let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
            let weekdayOfFirst = calendar.component(.weekday, from: monthStart)
            let numberOfPrefixEmptyDays = (weekdayOfFirst - calendar.firstWeekday + 7) % 7
            
            let columns: [GridItem] = Array(repeating: GridItem(spacing: 20), count: 7)
            
            VStack(spacing: 25){
                
                Text(calendarVM.formatMonthYear(Date()))
                
                LazyVGrid(columns: columns, alignment: .center, spacing: 12) {
                    let symbols = calendar.shortWeekdaySymbols
                    let orderedSymbols = Array(symbols[calendar.firstWeekday - 1..<symbols.count] + symbols[0..<calendar.firstWeekday - 1])
                    ForEach(orderedSymbols, id: \.self) { day in
                        Text(day.prefix(1))
                            .font(.caption)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.secondary)
                    }
                }
                
                LazyVGrid(columns: columns, alignment: .center, spacing: 12) {
                    ForEach(0..<numberOfPrefixEmptyDays, id: \.self) { _ in
                        Color.clear.frame(height: 50)
                    }
                    
                    ForEach(caloriesVM.monthlyCalories) { entry in
                        VStack {
                            let dayNumber = calendar.component(.day, from: entry.date)
                            let isToday = calendar.isDateInToday(entry.date)
                            
                            ZStack {
                                if isToday {
                                    Circle()
                                        .fill(Color.magentaRing)
                                        .frame(width: 20, height: 20)
                                }
                                Text("\(dayNumber)")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                            }
                            .frame(width: 20, height: 20)
                            
                            ProgressRing(
                                progress: .constant(entry.calories),
                                goal: user.goal!,
                                lineWidth: 7.5, frameWidth: 30
                            )
                        }
                    }
                }
            }.padding(.horizontal)
        }
    }
}


#Preview {
    MonthlyActivityRings()
}
