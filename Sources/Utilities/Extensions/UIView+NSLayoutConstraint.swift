//
//  UIView+NSLayoutConstraint.swift
//  
//
//  Created by Evan Coleman on 6/14/22.
//

#if canImport(UIKit)
import UIKit

extension UIView {
    public func constrainToEdges(of view: UIView) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}
#endif
