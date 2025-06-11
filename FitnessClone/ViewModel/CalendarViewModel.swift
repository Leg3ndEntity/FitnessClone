//
//  CalendarViewModel.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 02/06/25.
//

import Foundation

class CalendarViewModel: ObservableObject {
    static let shared = CalendarViewModel()
    private let calendar = Calendar.current
    
    private init() {}
    
    
    func formatShortDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }
    
    func formatFullDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }
    
    func formatFullWeekdayDateUppercased(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMM"
        formatter.locale = Locale.current
        return formatter.string(from: date).uppercased()
    }
    
    func formatFullWeekdayDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EE, d MMM"
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }
    
    func formatHour(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }
    
    func formatMonthYear(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }
    
    
    func startOfDay(for date: Date) -> Date {
        Calendar.current.startOfDay(for: date)
    }
    
    func endOfDay(for date: Date) -> Date {
        Calendar.current.date(byAdding: DateComponents(day: 1, second: -1), to: startOfDay(for: date))!
    }
    
    
    func startOfWeek(for date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return calendar.date(from: components)!
    }

    func endOfWeek(for date: Date) -> Date {
        let start = startOfWeek(for: date)
        return Calendar.current.date(byAdding: DateComponents(day: 7, second: -1), to: start)!
    }
    
    
    func startOfMonth(for date: Date) -> Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: date))!
    }

    func endOfMonth(for date: Date) -> Date {
        let start = startOfMonth(for: date)
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: start)!
    }
    
    
    func startOfYear(for date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: date)
        return calendar.date(from: components)!
    }

    func endOfYear(for date: Date) -> Date {
        let start = startOfYear(for: date)
        return Calendar.current.date(byAdding: DateComponents(year: 1, second: -1), to: start)!
    }


}
