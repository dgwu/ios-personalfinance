//
//  DateHelper.swift
//  PersonalFinance
//
//  Created by Daniel Gunawan on 09/01/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import Foundation
extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    func previousStartOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: -1), to: self.startOfMonth())!
    }
    func nextStartOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1), to: self.startOfMonth())!
    }
}
