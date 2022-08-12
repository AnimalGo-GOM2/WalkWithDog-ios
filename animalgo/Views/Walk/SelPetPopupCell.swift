//
//  selPetPopupCell.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/15.
//  Copyright © 2021 rocateer. All rights reserved.
//


import UIKit

class SelPetPopupCell: UITableViewCell {
  
  @IBOutlet weak var petNameLabel: UILabel!
  @IBOutlet weak var petImageView: UIImageView!
  @IBOutlet weak var checkButton: UIButton!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.petImageView.setCornerRadius(radius: 16)
  }
}


