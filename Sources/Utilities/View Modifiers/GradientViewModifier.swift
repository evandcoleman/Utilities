//
//  GradientViewModifier.swift
//  
//
//  Created by Evan Coleman on 6/10/22.
//

#if canImport(SwiftUI)
import SwiftUI

struct GradientViewModifier: ViewModifier {

    var maxOpacity: CGFloat

    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(colors: [.white.opacity(0.1), .white.opacity(0.3)], startPoint: .bottom, endPoint: .top)
                    .allowsHitTesting(false)
            )
    }
}

extension View {
    public func gradient(maxOpacity: CGFloat = 0.4) -> some View {
        modifier(GradientViewModifier(maxOpacity: maxOpacity))
    }
}
#endif
