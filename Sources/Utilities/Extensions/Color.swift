//
//  Color.swift
//  Covidualizer
//
//  Created by Evan Coleman on 6/25/20.
//  Copyright © 2020 Evan Coleman. All rights reserved.
//

import Foundation

private func hexStringToColorComponents(_ hex: String) -> (alpha: Double, red: Double, green: Double, blue: Double) {
    let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int: UInt64 = 0
    Scanner(string: hex).scanHexInt64(&int)
    let a, r, g, b: UInt64
    switch hex.count {
    case 3: // RGB (12-bit)
        (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
        (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8: // ARGB (32-bit)
        (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
        (a, r, g, b) = (1, 1, 1, 0)
    }

    return (Double(a), Double(r), Double(g), Double(b))
}

private func colorComponentsToHexString(_ red: Double, _ green: Double, _ blue: Double) -> String {
    let rgb: Int = (Int)(red * 255) << 16 | (Int)(green * 255) << 8 | (Int)(blue * 255) << 0

    return String(format:"#%06x", rgb)
}

#if canImport(SwiftUI) && canImport(UIKit)
import SwiftUI
import UIKit
public extension Color {

    var hex: String { UIColor(self).toHexString() }

    init(light: UIColor, dark: UIColor) {
        self.init(UIColor(dynamicProvider: { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return dark
            default:
                return light
            }
        }))
    }

    init(light: Color, dark: Color) {
        self.init(light: UIColor(light), dark: UIColor(dark))
    }

    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat) {

        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0

        guard UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &o) else {
            return (0, 0, 0, 0)
        }

        return (r, g, b, o)
    }
}
#endif

#if canImport(UIKit)
import UIKit
public extension UIColor {
    convenience init(hex: String) {
        let components = hexStringToColorComponents(hex)
        
        self.init(
            red: components.red / 255,
            green: components.green / 255,
            blue:  components.blue / 255,
            alpha: components.alpha / 255
        )
    }

    func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        return colorComponentsToHexString(r, g, b)
    }
}
#endif

#if canImport(SwiftUI)
import SwiftUI

extension Color {
    init(hex: String) {
        let components = hexStringToColorComponents(hex)

        self.init(
            .sRGB,
            red: components.red / 255,
            green: components.green / 255,
            blue:  components.blue / 255,
            opacity: components.alpha / 255
        )
    }
}
#endif
