//
//  SelGroupCell.swift
//  animalgo
//
//  Created by rocateer on 2021/12/03.
//  Copyright © 2021 rocateer. All rights reserved.
//


import UIKit

class SelGroupCell: UITableViewCell {
  
  @IBOutlet weak var groupButton: UIButton!
  @IBOutlet weak var groupLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  func groupButtonSelected() {
    if self.groupButton.isSelected {
      self.groupButton.backgroundColor = UIColor(named: "28E0AB0A")
      self.groupLabel.textColor = UIColor(named: "accent")
      self.groupLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
      self.layer.masksToBounds = true
      self.layer.borderWidth = 1
      self.layer.borderColor = UIColor(named: "accent")!.cgColor
    } else {
      self.groupButton.backgroundColor = UIColor(named: "F9F9F9")
      self.groupLabel.textColor = UIColor(named: "999999")
      self.groupLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
      self.layer.masksToBounds = false
      self.layer.borderWidth = 0
      self.layer.borderColor = UIColor.clear.cgColor
    }
  }
}
