//
//  Preferences.swift
//  Utilities
//
//  Created by Evan Coleman on 2/6/22.
//

import Foundation
import SwiftUI

public struct Preferences {

    public static var current: Preferences = .standard

    public static var standard: Preferences { .init(userDefaults: .standard) }

    fileprivate var store: PreferencesStore

    public init(userDefaults: UserDefaults) {
        store = .userDefaults(userDefaults)
    }

    public init(path: String) {
        let dictionary = (NSDictionary(contentsOfFile: path) as? [String: Any]) ?? [:]

        store = .propertyList(.init(dictionary, path: path))
    }

    public subscript<T>(key: String) -> T? {
        get { store.getValue(forKey: key) }
        set { store.setValue(newValue, forKey: key) }
    }

    public func synchronize() {
        store.synchronize()
    }
}

@propertyWrapper
public struct Preference<Value> {

    public var wrappedValue: Value {
        get { Preferences.current[key] ?? defaultValue }
        set { Preferences.current[key] = newValue }
    }

    public let key: String
    public let defaultValue: Value

    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

private enum PreferencesStore {
    case userDefaults(UserDefaults)
    case propertyList(PropertyList)

    func getValue<T>(forKey key: String) -> T? {
        switch self {
        case .userDefaults(let userDefaults):
            if let value = userDefaults.object(forKey: key) {
                return (value as! T)
            } else {
                return nil
            }
        case .propertyList(let propertyList):
            if let value = propertyList[key] {
                return (value as! T)
            } else {
                return nil
            }
        }
    }

    func setValue<T>(_ value: T?, forKey key: String) {
        switch self {
        case .userDefaults(let userDefaults):
            if let value = value {
                userDefaults.set(value, forKey: key)
            } else {
                userDefaults.removeObject(forKey: key)
            }
        case .propertyList(let propertyList):
            propertyList[key] = value
            synchronize()
        }
    }

    func synchronize() {
        switch self {
        case .userDefaults(let userDefaults):
            userDefaults.synchronize()
        case .propertyList(let propertyList):
            try! propertyList.synchronize()
        }
    }
}

private class PropertyList {
    var dictionary: [String: Any]
    var path: String

    init(_ dictionary: [String: Any], path: String) {
        self.dictionary = dictionary
        self.path = path
    }

    subscript(key: String) -> Any? {
        get { dictionary[key] }
        set { dictionary[key] = newValue }
    }

    func synchronize() throws {
        let dict = dictionary as NSDictionary

        try dict.write(to: URL(fileURLWithPath: path))
    }
}

private struct PreferencesKey: EnvironmentKey {
    static let defaultValue: Binding<Preferences> = .constant(.standard)
}

public extension EnvironmentValues {
    var preferences: Binding<Preferences> {
        get { self[PreferencesKey.self] }
        set { self[PreferencesKey.self] = newValue }
    }
}
