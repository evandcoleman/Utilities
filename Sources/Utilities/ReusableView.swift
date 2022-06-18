//
//  Storme
//  Copyright © 2017 Evan Coleman. All rights reserved.
//

import UIKit

public protocol ReusableView: AnyObject {
    func prepareForReuse()
}

extension UILabel: ReusableView {
    public func prepareForReuse() {
        text = nil
    }
}
