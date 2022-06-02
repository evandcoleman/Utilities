//
//  PublishedState.swift
//  Clean Kitchen
//
//  Created by Evan Coleman on 12/5/21.
//

import Combine
import SwiftUI

@propertyWrapper
public struct PublishedState<Value>: DynamicProperty {

    @StateObject private var base: Object

    public var willChange: AnyPublisher<Void, Never> {
        base.objectWillChange.eraseToAnyPublisher()
    }

    public var didChange: AnyPublisher<Value, Never> {
        base.$wrappedValue.eraseToAnyPublisher()
    }

    public var wrappedValue: Value {
        get {
            return base.wrappedValue
        }
        nonmutating set {
            base.wrappedValue = newValue
        }
    }

    public var projectedValue: Binding<Value> {
        return $base.wrappedValue
    }

    public init(wrappedValue value: Value) {
        self._base = .init(wrappedValue: .init(value))
    }
}

extension PublishedState {
    private final class Object: ObservableObject {

        @Published var wrappedValue: Value

        init(_ wrappedValue: Value) {
            self.wrappedValue = wrappedValue
        }
    }
}

@propertyWrapper
public struct PublishedBinding<Value>: DynamicProperty {

    @State private var _willChange: AnyPublisher<(), Never>
    @State private var _didChange: AnyPublisher<Value, Never>

    public var willChange: AnyPublisher<Void, Never> {
        return _willChange
    }

    public var didChange: AnyPublisher<Value, Never> {
        return _didChange
    }

    public var wrappedValue: Value {
        get { projectedValue.wrappedValue }
        nonmutating set { projectedValue.wrappedValue = newValue }
    }

    public let projectedValue: Binding<Value>

//    public init(wrappedValue value: Value) {
//        __willChange = 
//    }

    public init(willChange: AnyPublisher<(), Never>, didChange: AnyPublisher<Value, Never>, get: @escaping () -> Value, set: @escaping (Value) -> Void) {
        __willChange = .init(wrappedValue: willChange)
        __didChange = .init(wrappedValue: didChange)
        projectedValue = .init(get: get, set: set)
    }
}

@MainActor
private struct OnDebouncedChangeModifier<T>: ViewModifier {

    let publisher: AnyPublisher<T, Never>
    let interval: RunLoop.SchedulerTimeType.Stride
    let action: (T) -> Void

    @State private var cancellable: AnyCancellable?

    init(publishedState: PublishedState<T>, interval: RunLoop.SchedulerTimeType.Stride, action: @escaping (T) -> Void) {
        self.publisher = publishedState.didChange
        self.interval = interval
        self.action = action
    }

    func body(content: Content) -> some View {
        content
            .onAppear {
                cancellable?.cancel()
                cancellable = publisher
                    .debounce(for: interval, scheduler: RunLoop.main)
                    .sink(receiveValue: action)
            }
            .onDisappear {
                cancellable?.cancel()
                cancellable = nil
            }
    }
}

public extension View {
    @MainActor
    func onDebouncedChange<T>(of publishedState: PublishedState<T>, interval: RunLoop.SchedulerTimeType.Stride, perform action: @escaping (T) -> Void) -> some View {
        return modifier(OnDebouncedChangeModifier<T>(
            publishedState: publishedState,
            interval: interval,
            action: action
        ))
    }
}
