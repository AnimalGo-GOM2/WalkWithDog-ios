//
//  EmptyWalkCell.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/05.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit

class EmptyWalkCell: UITableViewCell {
  @IBOutlet weak var emptyCellButton: UIButton!
  @IBOutlet weak var emptyLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.emptyCellButton.setCornerRadius(radius: 20)
  }
}
