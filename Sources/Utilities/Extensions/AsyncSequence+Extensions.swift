//
//  AsyncSequence+Extensions.swift
//  Utilities
//
//  Created by Evan Coleman on 2/2/22.
//

import Foundation

extension AsyncSequence {
    public func collect() async rethrows -> [Element] {
        try await reduce(into: [Element]()) { $0.append($1) }
    }
}

extension AsyncSequence where Element: Sequence {
    public func collect() async rethrows -> [Element.Element] {
        try await reduce(into: [Element]()) { $0.append($1) }
            .flatMap { $0 }
    }
}
