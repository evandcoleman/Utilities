//
//  ThrottledOnChangeViewModifier.swift
//  ThrottledOnChangeViewModifier
//
//  Created by Evan Coleman on 7/25/21.
//

import SwiftUI

extension View {
    public func onChange<T: Equatable>(of value: T, throttle: TimeInterval, perform action: @escaping (T) -> Void) -> some View {
        return self
            .modifier(ThrottledOnChangeViewModifier(action: action, throttle: throttle, value: value))
    }
}

public struct ThrottledOnChangeViewModifier<Value: Equatable>: ViewModifier {

    private var action: (Value) -> Void
    private var value: Value
    private var throttle: TimeInterval

    @State private var lastChangedAt: Date = .distantPast

    public init(action: @escaping (Value) -> Void, throttle: TimeInterval, value: Value) {
        self.action = action
        self.value = value
        self.throttle = throttle
    }

    public func body(content: Content) -> some View {
        content
            .onChange(of: value) { newValue in
                log.debug(Date.now.timeIntervalSince1970 - lastChangedAt.timeIntervalSince1970)
                guard Date.now.timeIntervalSince1970 - lastChangedAt.timeIntervalSince1970 >= throttle else { return }

                lastChangedAt = Date.now
                action(newValue)
            }
    }
}
