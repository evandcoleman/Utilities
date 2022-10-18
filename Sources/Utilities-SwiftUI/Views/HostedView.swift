//
//  HostedView.swift
//  
//
//  Created by Evan Coleman on 6/14/22.
//

#if canImport(UIKit)
import SwiftUI
import UIKit

public struct HostedView<T: UIView>: UIViewRepresentable {

    var builder: () -> T

    public init(_ builder: @escaping () -> T) {
        self.builder = builder
    }

    public func makeUIView(context: Context) -> T {
        return builder()
    }

    public func updateUIView(_ uiView: T, context: Context) {

    }
}
#endif
