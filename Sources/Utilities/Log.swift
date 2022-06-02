//
//  Log.swift
//  Rapid
//
//  Created by Evan Coleman on 12/12/17.
//  Copyright © 2017 Evan Coleman. All rights reserved.
//

import Foundation

let log = Log.self

public struct Log {
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

    public static var level: Level = .warning
    public static var debugLevel: Level = .debug

    public static func debug(file: String = #file, line: Int = #line, column: Int = #column, _ message: Any...) {
        self.log(level: .debug, file: file, line: line, column: column, message)
    }

    public static func verbose(file: String = #file, line: Int = #line, column: Int = #column, _ message: Any...) {
        self.log(level: .verbose, file: file, line: line, column: column, message)
    }

    public static func info(file: String = #file, line: Int = #line, column: Int = #column, _ message: Any...) {
        self.log(level: .info, file: file, line: line, column: column, message)
    }

    public static func warning(file: String = #file, line: Int = #line, column: Int = #column, _ message: Any...) {
        self.log(level: .warning, file: file, line: line, column: column, message)
    }

    public static func error(file: String = #file, line: Int = #line, column: Int = #column, _ message: Any...) {
        self.log(level: .error, file: file, line: line, column: column, message)
    }

    private static var isDebug: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }

    private static func log(level: Level, file: String = #file, line: Int = #line, column: Int = #column, _ message: Any...) {
        if Log.isDebug {
            guard level.rawValue >= Log.debugLevel.rawValue else { return }
        } else {
            guard level.rawValue >= Log.level.rawValue else { return }
        }

        let filename = URL(fileURLWithPath: file).lastPathComponent

        switch level {
        case .debug where Log.isDebug, .verbose, .info, .warning, .error:
            print("\(level.prefix) | [\(filename):\(line):\(column)] | \(message.flatMap { $0 as? [Any] ?? [$0] }.map { String(describing: $0) } .joined(separator: " "))")
        default:
            break
        }
    }
}
