//
//  LargeProfileTableViewCell.swift
//  EasyTaxes
//
//  Created by Joel Gutierrez on 11/23/18.
//  Copyright © 2018 Joel Gutierrez. All rights reserved.
//

import UIKit

class LargeProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressTop: UILabel!
    @IBOutlet weak var addressBottom: UILabel!
    @IBOutlet weak var birthdate: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setLabel(name: String) {
        nameLabel.text = name
    }
    
    func setImageAndLabel(profileImage: UIImage, name: String) {
        profileImageView.image = profileImage
    }
    
    func setInfo(address1: String, address2: String, birth: String, phone: String) {
        addressTop.text = address1
        addressBottom.text = address2
        birthdate.text = birth
        phoneNumber.text = phone
    }
}
