//
//  PositivePropertyWrapper.swift
//  Clean Kitchen
//
//  Created by Evan Coleman on 11/27/21.
//

import Foundation

@propertyWrapper
public struct Positive<Value: BinaryFloatingPoint> {
    public var wrappedValue: Value {
        didSet { wrappedValue = abs(wrappedValue) }
    }

    public init(wrappedValue: Value) {
        self.wrappedValue = abs(wrappedValue)
    }
}
