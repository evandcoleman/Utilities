import Foundation

public protocol Then {}

public extension Then where Self: AnyObject {

    func then(_ builder: (Self) throws -> Void) rethrows -> Self {
        try builder(self)

        return self
    }
}

public extension Then where Self: Any {

    func with(_ builder: (inout Self) throws -> Void) rethrows -> Self {
        var copy = self
        try builder(&copy)

        return copy
    }

    func `do`(_ builder: (Self) throws -> Void) rethrows {
        try builder(self)
    }
}

extension NSObject: Then {}
extension URLRequest: Then {}

#if canImport(UIKit)
import UIKit

extension CGPoint: Then {}
extension CGSize: Then {}
extension CGRect: Then {}
#endif
