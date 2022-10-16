//
//  Date+Extensions.swift
//  Rapid
//
//  Created by Evan Coleman on 12/22/17.
//  Copyright © 2017 Evan Coleman. All rights reserved.
//

import Foundation

extension Date {

    public var yearMonthDayString: String {
        return formatted(.yearMonthDay)
    }

    public var isToday: Bool {
        let calendar = Calendar(identifier: .gregorian)
        let nowComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        let selfComponents = calendar.dateComponents([.year, .month, .day], from: self)
        
        return nowComponents.year == selfComponents.year
            && nowComponents.month == selfComponents.month
            && nowComponents.day == selfComponents.day
    }

    public var dateComponents: DateComponents {
        return Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: self)
    }

    public var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }

    public func date(bySetting component: Calendar.Component, to value: Int) -> Date? {
        return Calendar.current.date(bySetting: component, value: value, of: self)
    }

    public func date(byAdding component: Calendar.Component, value: Int) -> Date? {
        return Calendar.current.date(byAdding: component, value: value, to: self)
    }

    public func isInTheNext(_ value: Int, _ component: Calendar.Component, using calendar: Calendar = Calendar(identifier: .gregorian)) -> Bool {
        switch component {
        case .day:
            return calendar.dateComponents([.day], from: Date(), to: self).day! < value
        case .weekOfMonth, .weekOfYear:
            return calendar.dateComponents([.weekOfMonth], from: Date(), to: self).weekOfMonth! < value
        case .month:
            return calendar.dateComponents([.month], from: Date(), to: self).month! < value
        case .year:
            return calendar.dateComponents([.year], from: Date(), to: self).year! < value
        default:
            fatalError("Not supported")
        }
    }

    public func isSameDay(as date: Date) -> Bool {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        let otherComponents = calendar.dateComponents([.year, .month, .day], from: date)

        return components.day == otherComponents.day
            && components.month == otherComponents.month
            && components.year == otherComponents.year
    }
}
