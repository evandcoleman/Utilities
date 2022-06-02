//
//  File.swift
//  Image Overlayer
//
//  Created by Evan Coleman on 12/31/21.
//

import Foundation
import SwiftUI

public struct RoundedRectangleButtonStyle: ButtonStyle {

    public let color: Color

    public init(_ color: Color) {
        self.color = color
    }

    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label.foregroundColor(.white).font(.headline)
            Spacer()
        }
        .padding()
        .background(color.cornerRadius(8))
        .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
