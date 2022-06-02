//
//  CancelBag.swift
//  Covidualizer
//
//  Created by Evan Coleman on 6/27/20.
//  Copyright © 2020 Evan Coleman. All rights reserved.
//

import Combine

public final class CancelBag {
    fileprivate var cancellables: Set<AnyCancellable> = []

    public init() {}

    public func cancel() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}

extension AnyCancellable {
    public func store(in bag: CancelBag) {
        bag.cancellables.insert(self)
    }
}
