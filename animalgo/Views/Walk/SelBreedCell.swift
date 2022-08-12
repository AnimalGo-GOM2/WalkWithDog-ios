//
//  SelBreedCell.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/08.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit

class SelBreedCell: UITableViewCell {
  @IBOutlet weak var breedButton: UIButton!
  @IBOutlet weak var breedLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  func breedButtonSelected() {
    if self.breedButton.isSelected {
      self.breedLabel.textColor = .black
      self.breedLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    } else {
      self.breedLabel.textColor = UIColor(named: "999999")
      self.breedLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    }
  }
}
