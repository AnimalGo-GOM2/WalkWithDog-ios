//
//  CalendarDayCell.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/12.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit

class CalendarDayCell: UICollectionViewCell {
  
  @IBOutlet weak var dateButton: UIButton!
  @IBOutlet weak var selectedView: UIView!
  @IBOutlet weak var dateLabel: UILabel!
  
  var year = 0
  var month = 0
  var date = Date()
  override func awakeFromNib() {
    super.awakeFromNib()
    self.dateButton.isSelected = false
    self.dateButton.setCornerRadius(radius: self.dateButton.frame.size.height / 2)
    self.selectedView.setCornerRadius(radius: self.selectedView.frame.size.height / 2)
    self.selectedView.addBorder(width: 2, color: UIColor(named: "accent")!)
    self.selectedView.isHidden = !self.dateButton.isSelected
  }
  
  
  @IBAction func dateButtonTouched(sender: UIButton) {
    self.dateButton.isSelected = true
  }
}
