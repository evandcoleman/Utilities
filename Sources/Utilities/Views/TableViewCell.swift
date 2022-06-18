//
//  Storme
//  Copyright © 2017 Evan Coleman. All rights reserved.
//

import UIKit

final class TableViewCell<Subject: UIView>: UITableViewCell, Reusable where Subject: ReusableView {
    let subjectView = Subject()
    
    var contentInset: UIEdgeInsets {
        get { return contentView.layoutMargins }
        set { contentView.layoutMargins = newValue }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.layoutMargins = .zero
        contentView.preservesSuperviewLayoutMargins = false
        
        contentView.addSubview(subjectView)

        NSLayoutConstraint.activate([
            subjectView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            subjectView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            subjectView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            subjectView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        subjectView.prepareForReuse()
    }
}
