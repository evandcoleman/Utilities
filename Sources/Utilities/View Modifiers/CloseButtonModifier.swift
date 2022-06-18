//
//  CloseButtonModifier.swift
//  
//
//  Created by Evan Coleman on 6/7/22.
//

import SwiftUI

struct CloseButtonModifier: ViewModifier {

    var action: () -> Void

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    CloseButton(action: action)
                }
            }
    }
}

public extension View {
    func closeButton(action: @escaping () -> Void) -> some View {
        return modifier(CloseButtonModifier(action: action))
    }
}
