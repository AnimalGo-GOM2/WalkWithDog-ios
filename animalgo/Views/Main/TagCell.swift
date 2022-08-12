//
//  TagCell.swift
//  animalgo
//
//  Created by rocateer on 2021/10/29.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit

class TagCell: UICollectionViewCell {
  
  @IBOutlet weak var tagButton: UIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.tagButton.setCornerRadius(radius: 14.5)
    self.tagButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
  }
}
