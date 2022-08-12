//
//  DiaryPictureCell.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/11.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit

class DiaryPictureCell: UICollectionViewCell {
  @IBOutlet weak var walkPictureImageView: UIImageView!
  @IBOutlet weak var removeButton: UIButton!
  @IBOutlet weak var plusButton: UIButton!
  override func awakeFromNib() {
    super.awakeFromNib()
    self.plusButton.setCornerRadius(radius: 10)
    self.walkPictureImageView.setCornerRadius(radius: 10)
    
    self.plusButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    
    
  }
  
}
