//
//  ScaledValue.swift
//  Utilities
//
//  Created by Evan Coleman on 2/6/22.
//

import Foundation
import UIKit

#if os(iOS)
@propertyWrapper
public struct ScaledValue<Value> where Value: BinaryFloatingPoint {

    public var wrappedValue: Value {
        get { projectedValue.value }
        set { projectedValue.value = newValue }
    }

    public var projectedValue: Scaler

    public init(wrappedValue: Value, relativeTo: Value) {
        projectedValue = Scaler(value: wrappedValue, relativeTo: relativeTo)
    }

    public init(wrappedValue: Value) {
        projectedValue = Scaler(value: wrappedValue, relativeTo: Value(UIScreen.main.bounds.width))
    }
}

extension ScaledValue {
    public struct Scaler {
        var value: Value
        let relativeTo: Value

        public func scaling(using referenceValue: Value) -> Value {
            return (referenceValue / relativeTo) * value
        }
    }
}
#endif
