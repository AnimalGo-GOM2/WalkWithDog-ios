//
//  PetImageCell.swift
//  animalgo
//
//  Created by rocateer on 2021/10/29.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit

class PetImageCell: UICollectionViewCell {
  
  @IBOutlet weak var petImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.petImageView.addBorder(width: 2, color: .white)
    self.petImageView.setCornerRadius(radius: 45)
  }
}
