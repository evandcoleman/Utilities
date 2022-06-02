//
//  YearMonthDayDateStyle.swift
//  Utilities
//
//  Created by Evan Coleman on 2/6/22.
//

import Foundation

public struct YearMonthDayDateStyle: FormatStyle {

    public func format(_ value: Date) -> String {
        return value.formatted(.iso8601.year().month().day().dateSeparator(.omitted))
    }
}

extension FormatStyle where Self == YearMonthDayDateStyle {
    public static var yearMonthDay: YearMonthDayDateStyle { .init() }
}

public struct YearMonthDayDateParseStrategy: ParseStrategy {

    public func parse(_ value: String) throws -> Date {
        return try Date(value, strategy: .iso8601.year().month().day().dateSeparator(.omitted))
    }
}

extension ParseStrategy where Self == YearMonthDayDateParseStrategy {
    public static var yearMonthDay: YearMonthDayDateParseStrategy { .init() }
}
