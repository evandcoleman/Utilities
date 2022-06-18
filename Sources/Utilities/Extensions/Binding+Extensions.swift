//
//  Binding+Extensions.swift
//  
//
//  Created by Evan Coleman on 6/12/22.
//

import SwiftUI

extension Binding {
    public func print(file: String = #file, line: Int = #line) -> Self {
        return .init {
            log.debug(file: file, line: line, "[\(String(describing: type(of: self))).get]", self.wrappedValue)

            return self.wrappedValue
        } set: { newValue in
            log.debug(file: file, line: line, "[\(String(describing: type(of: self))).set]", newValue)

            self.wrappedValue = newValue
        }
    }
}
