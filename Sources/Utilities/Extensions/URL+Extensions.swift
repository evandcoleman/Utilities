//
//  URL+Extensions.swift
//  Clean Kitchen
//
//  Created by Evan Coleman on 11/29/21.
//

import Foundation

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(string: value)!
    }
}

extension URL {
    public var queryParameters: [String: String]? {
        var params = [String: String]()

        if let queryItems = URLComponents(url: self, resolvingAgainstBaseURL: false)?.queryItems {
            for item in queryItems {
                params[item.name] = item.value
            }
        }

        return params
    }

    public func matchesPattern(_ url: URL) -> [String: String]? {
        if url.host != host {
            return nil
        }

        var params = [String: String]()

        var patternComponents = url.routeComponents
        if patternComponents.count > 1, patternComponents[1] == host {
            patternComponents.remove(at: 0)
        }
        let pathComponents = self.routeComponents

        guard patternComponents.count == pathComponents.count else {
            return nil
        }

        for (pattern, path) in zip(patternComponents, pathComponents) {
            let key = pattern.replacingOccurrences(of: ":", with: "", options: [], range: nil)
            let value = self.getValue(path)

            if pattern.contains(":") {
                params[key] = value
            } else {
                if key != value {
                    return nil
                }
            }
        }

        if let queryItems = URLComponents(url: self, resolvingAgainstBaseURL: false)?.queryItems {
            for item in queryItems {
                params[item.name] = item.value
            }
        }

        return params
    }

    private var routeComponents: [String] {
            if let scheme = self.scheme {
                return self.absoluteString
                    .replacingOccurrences(of: "\(scheme)://", with: "")
                    .components(separatedBy: "/")
                    .filter { !$0.isEmpty }
            } else {
                return self.absoluteString
                    .components(separatedBy: "/")
                    .filter { !$0.isEmpty }
            }
    }

    private func getValue(_ original: String) -> String {
        var string = original

        if let dotRange = string.range(of: "?") {
            string.removeSubrange(dotRange.lowerBound..<string.endIndex)
        }

        return string
    }
}

infix operator ~=
public func ~= (lhs: URL, rhs: URL) -> Bool {
    return lhs.matchesPattern(rhs) != nil
}
