//
//  FaqDetailCell.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/03.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit

class FaqDetailCell: UITableViewCell {
  @IBOutlet weak var contentsLabel: UILabel!
  @IBOutlet weak var faqImageView: UIImageView!
  @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
}
