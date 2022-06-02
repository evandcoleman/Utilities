//
//  Sequence+Extensions.swift
//  Clean Food
//
//  Created by Evan Coleman on 7/8/20.
//  Copyright © 2020 Evan Coleman. All rights reserved.
//

import Foundation

public extension Sequence {
    var array: Array<Element> {
        return Array(self)
    }

    func grouped<T>(by keyPath: KeyPath<Element, T>) -> [T: [Element]] {
        return reduce(into: [:]) { $0[$1[keyPath: keyPath], default: []].append($1) }
    }

    func grouped<T, U>(by keyPath: KeyPath<Element, T>, transformingKey: (T) -> U) -> [U: [Element]] {
        return reduce(into: [:]) { $0[transformingKey($1[keyPath: keyPath]), default: []].append($1) }
    }
}

public extension Sequence where Iterator.Element: Identifiable, Iterator.Element.ID: Comparable {
    func unique() -> [Iterator.Element] {
        return Array(reduce(into: [:]) { $0[$1.id] = $1 }
            .values)
            .sorted { $0.id < $1.id }
    }
}

extension String: Identifiable {
    public var id: String { self }
}

extension Array {
    public func linspace(from start: Index, through end: Index, in samples: Int) -> [Element] {
        let indices = stride(from: start, through: end, by: (end - start) / samples)

        return indices
            .map { self[$0] }
    }

    public func sample(maxCount: Int) -> [Element] {
        if maxCount >= count {
            return Array(self)
        } else {
            let samples = Int(ceil(Double(count) / Double(maxCount))) + 1
            let indices = stride(from: startIndex, through: endIndex, by: samples)
                .map { $0 }

            if let last = indices.last, last != count - 1 {
                let diff = (count - 1) - last

                return indices
                    .map { $0 == startIndex ? self[$0] : self[$0 + diff] }
            } else {
                return indices
                    .map { self[$0] }
            }
        }
    }
}

extension RandomAccessCollection {
    public func removingEveryOtherElement(keepingLast: Bool = false) -> [Element] {
        return enumerated()
            .compactMap { offset, element -> Element? in
                if keepingLast {
                    if offset == 0 || offset == count - 1 {
                        return element
                    } else {
                        return Swift.min(count - 3, offset + 2) % 2 == 1 ? nil : element
                    }
                }

                return offset % 2 == 1 ? nil : element
            }
    }

    public func concurrentMap<T>(_ transform: @escaping (Element) async throws -> T) async rethrows -> [T] {
        let unorderedResults = try await withThrowingTaskGroup(of: (Index, T).self) { group -> [(Index, T)] in
            var output: [(Index, T)] = []

            for index in indices {
                group.addTask {
                    let i = index
                    let value = try await transform(self[i])

                    return (i, value)
                }
            }

            for try await item in group {
                output.append(item)
            }

            return output
        }

        return unorderedResults
            .sorted { $0.0 < $1.0 }
            .map { $0.1 }
    }

    public func concurrentCompactMap<T>(_ transform: @escaping (Element) async throws -> T?) async rethrows -> [T] {
        return try await concurrentMap(transform)
            .compactMap { $0 }
    }
}

