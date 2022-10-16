//
//  View+Extensions.swift
//  CleanKitchen
//
//  Created by Evan Coleman on 3/20/22.
//

#if os(iOS)
import SwiftUI
import UIKit

extension View {
    public func snapshot(size: CGSize? = nil) -> UIImage {
        let controller = UIHostingController(rootView: self)

        return controller.view.snapshot(size: size)
    }
}
#endif
