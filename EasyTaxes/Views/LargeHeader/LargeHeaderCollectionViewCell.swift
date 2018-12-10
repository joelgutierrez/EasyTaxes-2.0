//
//  LargeHeaderCollectionViewCell.swift
//  EasyTaxes
//
//  Created by Joel Gutierrez on 11/21/18.
//  Copyright © 2018 Joel Gutierrez. All rights reserved.
//

import UIKit

class LargeHeaderCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setTitleLabel(title: String) {
        self.titleLabel.text = title
        let textRange = NSRange(location: 0, length: (title.count))
        let attributedText = NSMutableAttributedString(string: title)
        attributedText.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: textRange)
        titleLabel.attributedText = attributedText
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
    }
}
