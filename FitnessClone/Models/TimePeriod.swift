//
//  TimePeriod.swift
//  FitnessClone
//
//  Created by Simone Sarnataro on 02/06/25.
//

import Foundation

enum TimePeriod {
    case hourly, daily, monthly, yearly

    var component: Calendar.Component {
        switch self {
        case .hourly: return .hour
        case .daily: return .day
        case .monthly: return .month
        case .yearly: return .year
        }
    }
}
