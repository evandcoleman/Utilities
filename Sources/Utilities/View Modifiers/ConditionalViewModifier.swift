#if canImport(SwiftUI)
import SwiftUI

extension View {
    public func ifSome<T, Content: View>(_ value: T?, @ViewBuilder builder: (Self, T) -> Content) -> some View {
        if let value = value {
            return AnyView(builder(self, value))
        } else {
            return AnyView(self)
        }
    }

    public func ifCondition<Content: View>(_ condition: Bool, @ViewBuilder builder: (Self) -> Content) -> some View {
        if condition {
            return AnyView(builder(self))
        } else {
            return AnyView(self)
        }
    }
}
#endif
