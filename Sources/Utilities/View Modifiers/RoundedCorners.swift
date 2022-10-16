//
//  RoundedCorners.swift
//  Utilities
//
//  Created by Evan Coleman on 5/21/21.
//

#if canImport(SwiftUI) && canImport(UIKit)
import SwiftUI
import UIKit

public struct RoundedCorners: Shape {

    public var radius: CGFloat = .infinity
    public var corners: UIRectCorner = .allCorners

    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

public extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorners(radius: radius, corners: corners))
    }
}
#endif
