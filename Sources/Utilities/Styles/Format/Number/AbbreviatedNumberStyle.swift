//
//  StatNumberStyle.swift
//  Utilities
//
//  Created by Evan Coleman on 2/10/22.
//

import Foundation

public struct AbbreviatedNumberStyle: FormatStyle {

    public func format(_ value: Int) -> String {
        let num = abs(Double(value))
        let sign = (value < 0) ? "-" : ""

        switch num {
        case 1_000_000_000...:
            var formatted = num / 1_000_000_000
            formatted = formatted.truncate(places: 1)

            return "\(sign)\(formatted)b"
        case 1_000_000...:
            var formatted = num / 1_000_000
            formatted = formatted.truncate(places: 1)

            return "\(sign)\(formatted)m"
        case 1_000...:
            var formatted = num / 1_000
            formatted = formatted.truncate(places: 1)

            return "\(sign)\(formatted)k"
        case 0...:
            return "\(value)"
        default:
            return "\(sign)\(value)"
        }
    }
}

extension FormatStyle where Self == AbbreviatedNumberStyle {
    public static var abbreviated: AbbreviatedNumberStyle { .init() }
}

private extension Double {
    func truncate(places: Int) -> Double {
        let multiplier = pow(10, Double(places))
        let newDecimal = multiplier * self // move the decimal right
        let truncated = Double(Int(newDecimal)) // drop the fraction
        let originalDecimal = truncated / multiplier // move the decimal back

        return originalDecimal
    }
}
