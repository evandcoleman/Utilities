//
//  CGRect+Extensions.swift
//  Utilities
//
//  Created by Evan Coleman on 1/25/22.
//

import UIKit

public extension CGRect {
    var topRight: CGPoint {
        return CGPoint(x: maxX, y: minY)
    }

    var bottomLeft: CGPoint {
        return CGPoint(x: minX, y: maxY)
    }

    var bottomRight: CGPoint {
        return CGPoint(x: maxX, y: maxY)
    }

    var topLeft: CGPoint {
        return CGPoint(x: minX, y: minY)
    }

    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}
