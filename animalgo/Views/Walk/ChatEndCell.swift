//
//  ChatEndCell.swift
//  animalgo
//
//  Created by rocateer on 2021/12/20.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit

class ChatEndCell: UITableViewCell {
  
  @IBOutlet weak var endWrapView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.endWrapView.setCornerRadius(radius: 14)
  }
}
