//
//  Log.swift
//  Rapid
//
//  Created by Evan Coleman on 12/12/17.
//  Copyright © 2017 Evan Coleman. All rights reserved.
//

import Foundation

let log = Log.self

public final class Log {
    public enum Level: Int {
        case debug = 0
        case verbose
        case info
        case warning
        case error

        fileprivate var prefix: String {
            switch self {
            case .debug: return "💜 [DEBUG]"
            case .verbose: return "💙 [VERBOSE]"
            case .info: return "💚 [INFO]"
            case .warning: return "💛 [WARNING]"
            case .error: return "❤️ [ERROR]"
            }
        }
    }

    public static let shared = Log()

    public static var level: Level = .warning
    public static var debugLevel: Level = .debug

    private var observers: [(Message) -> Void] = []

    public static func debug(file: String = #file, line: UInt = #line, _ message: Any...) {
        shared.log(.init(level: .debug, message: message, file: file, line: line))
    }

    public static func verbose(file: String = #file, line: UInt = #line, _ message: Any...) {
        shared.log(.init(level: .verbose, message: message, file: file, line: line))
    }

    public static func info(file: String = #file, line: UInt = #line, _ message: Any...) {
        shared.log(.init(level: .info, message: message, file: file, line: line))
    }

    public static func warning(file: String = #file, line: UInt = #line, _ message: Any...) {
        shared.log(.init(level: .warning, message: message, file: file, line: line))
    }

    public static func error(file: String = #file, line: UInt = #line, _ message: Any...) {
        shared.log(.init(level: .error, message: message, file: file, line: line))
    }

    private static var isDebug: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }

    public func addHandler(_ handler: @escaping (Message) -> Void) {
        observers.append(handler)
    }

    private func log(_ message: Message) {
        if Log.isDebug {
            guard message.level.rawValue >= Log.debugLevel.rawValue else { return }
        } else {
            guard message.level.rawValue >= Log.level.rawValue else { return }
        }

        switch message.level {
        case .debug where Log.isDebug, .verbose, .info, .warning, .error:
            print(message.formatted)
            observers.forEach { $0(message) }
        default:
            break
        }
    }

    public struct Message {
        public let level: Level
        public let message: [Any]
        public let file: String
        public let line: UInt

        public var filename: String {
            return URL(fileURLWithPath: file).lastPathComponent
        }

        public var formatted: String {
            return "\(level.prefix) | [\(filename):\(line)] | \(message.flatMap { $0 as? [Any] ?? [$0] }.map { String(describing: $0) } .joined(separator: " "))"
        }
    }
}
