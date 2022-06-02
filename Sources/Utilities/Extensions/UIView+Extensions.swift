//
//  UIView+Extensions.swift
//  Clean Kitchen
//
//  Created by Evan Coleman on 11/27/21.
//

#if canImport(UIKit) && os(iOS)
import UIKit

extension UIView {
    public func superview<T: UIView>(of type: T.Type) -> T? {
        return superview(matching: { $0 is T })
    }

    public func subview<T: UIView>(of type: T.Type) -> T? {
        return findSubviews(matching: { $0 is T }).first as? T
    }

    public func superview<T: UIView>(matching predicate: (UIView) -> Bool) -> T? {
        if let view = superview as? T {
            return view
        } else {
            return superview?.superview(matching: predicate)
        }
    }

    public func findSubviews(matching predicate: (UIView) -> Bool) -> [UIView] {
        return subviews
            .flatMap { subview -> [UIView] in
                let filtered = subview.findSubviews(matching: predicate)

                if predicate(self) {
                    return [self] + filtered
                }

                return filtered
            }
    }

    public func snapshot(size: CGSize? = nil) -> UIImage {
        let view = self

        let targetSize = size ?? view.intrinsicContentSize
        view.bounds = CGRect(origin: .zero, size: targetSize)
        view.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize, format: .init().then {
            $0.scale = 2
        })

        return renderer.image { _ in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
    }
}
#endif
