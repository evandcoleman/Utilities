//
//  CloseButton.swift
//  FourteenPoints
//
//  Created by Evan Coleman on 1/13/21.
//

import SwiftUI
import UIKit

#if os(iOS)
public struct CloseButton: View {

    public var action: () -> Void

    public var body: some View {
        Button(action: action) {
            NavigationImage(systemName: "xmark.circle.fill")
                .foregroundColor(Color(.systemGray2))
        }
        .accessibilityIdentifier("CloseButton")
    }

    public init(action: @escaping () -> Void) {
        self.action = action
    }
}
#endif
