//
//  ProfileCollectionViewCell.swift
//  EasyTaxes
//
//  Created by Joel Gutierrez on 11/21/18.
//  Copyright © 2018 Joel Gutierrez. All rights reserved.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var titleForPicture: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setTitleAndPicture(title: String, image: UIImage) {
        self.titleForPicture.text = title
        /* for round pictures - not consistent though
        self.pictureImageView.layer.borderWidth = 1
        self.pictureImageView.layer.masksToBounds = false
        self.pictureImageView.layer.borderColor = UIColor.clear.cgColor
        self.pictureImageView.layer.cornerRadius = self.pictureImageView.frame.height/2
        self.pictureImageView.clipsToBounds = true
         */
        self.pictureImageView.image = image
    }
}
