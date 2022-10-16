//
//  Binding+Extensions.swift
//  
//
//  Created by Evan Coleman on 6/12/22.
//

import SwiftUI

extension Binding {
    public func print(file: String = #file, line: UInt = #line) -> Self {
        return .init {
            log.debug(file: file, line: line, "[\(String(describing: type(of: self))).get]", self.wrappedValue)

            return self.wrappedValue
        } set: { newValue in
            log.debug(file: file, line: line, "[\(String(describing: type(of: self))).set]", newValue)

            self.wrappedValue = newValue
        }
    }
}

extension Binding {
    public func optional() -> Binding<Value?> {
        return .init(
            get: { self.wrappedValue },
            set: { newValue in
                if let newValue = newValue {
                    self.wrappedValue = newValue
                }
            }
        )
    }
}
