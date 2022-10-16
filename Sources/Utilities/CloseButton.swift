//
//  CloseButton.swift
//  FourteenPoints
//
//  Created by Evan Coleman on 1/13/21.
//

#if os(iOS)
import SwiftUI
import UIKit

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
