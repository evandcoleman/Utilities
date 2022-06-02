//
//  Number+Extensions.swift
//  Utilities
//
//  Created by Evan Coleman on 2/13/22.
//

import Foundation

extension Double {
    public func rounded(toNearest: Double, _ rule: FloatingPointRoundingRule) -> Double {
        return (self / toNearest).rounded(rule) * toNearest
    }
}
