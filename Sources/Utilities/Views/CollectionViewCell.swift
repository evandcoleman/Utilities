//
//  Storme
//  Copyright © 2017 Evan Coleman. All rights reserved.
//

#if canImport(UIKit)
import UIKit

public protocol CollectionViewCellProtocol {
    func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes
}

public final class CollectionViewCell<Subject: UIView>: UICollectionViewCell, Reusable where Subject: ReusableView {
    public let subjectView = Subject()
    
    public var contentInset: UIEdgeInsets {
        get { return contentView.layoutMargins }
        set { contentView.layoutMargins = newValue }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layoutMargins = .zero
        contentView.preservesSuperviewLayoutMargins = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(subjectView)

        NSLayoutConstraint.activate([
            subjectView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            subjectView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            subjectView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            subjectView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        if let view = subjectView as? CollectionViewCellProtocol {
            return view.preferredLayoutAttributesFitting(layoutAttributes)
        } else {
            return super.preferredLayoutAttributesFitting(layoutAttributes)
        }
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        
        subjectView.prepareForReuse()
    }
}
#endif
