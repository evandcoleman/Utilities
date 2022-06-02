//
//  OpaqueNavigationBarModifier.swift
//  Utilities
//
//  Created by Evan Coleman on 1/13/22.
//

import Foundation
import SwiftUI
import UIKit

#if os(iOS)
struct OpaqueNavigationBarModifier: ViewModifier {

    func body(content: Content) -> some View {
        content
            .onAppear {
                let navigationBarAppearance = UINavigationBarAppearance()
                navigationBarAppearance.configureWithTransparentBackground()
                navigationBarAppearance.backgroundEffect = UIBlurEffect(style: .light)
                UINavigationBar.appearance().standardAppearance = navigationBarAppearance
                UINavigationBar.appearance().compactAppearance = navigationBarAppearance
                UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
            }
            .onDisappear {
                let navigationBarAppearance = UINavigationBarAppearance()
                navigationBarAppearance.configureWithTransparentBackground()
                UINavigationBar.appearance().standardAppearance = navigationBarAppearance
                UINavigationBar.appearance().compactAppearance = navigationBarAppearance
                UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
            }
    }
}

public extension View {
    func opaqueNavigationBar() -> some View {
        return modifier(OpaqueNavigationBarModifier())
    }
}
#endif
