//
//  PastFormInfoTableViewCell.swift
//  EasyTaxes
//
//  Created by Joel Gutierrez on 11/23/18.
//  Copyright © 2018 Joel Gutierrez. All rights reserved.
//

import UIKit

class PastFormInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTitleAndDetail(left: String, right: String, isGreen: Bool) {
        leftLabel.text = left
        rightLabel.text = right
        if(isGreen) {
            rightLabel.textColor = UIColor.green
        } else {
            rightLabel.textColor = UIColor.red
        }
    }
}
