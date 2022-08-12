//
//  ChatReceiveCell.swift
//  animalgo
//
//  Created by rocateer on 2021/11/24.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit

class ChatReceiveCell: UITableViewCell {
  
  @IBOutlet weak var bubbleWrapView: UIView!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var chatWrapView: UIView!
  @IBOutlet weak var chatContentLabel: UILabel!
  @IBOutlet weak var chatContentWrapView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.bubbleWrapView.setCornerRadius(radius: 15)
//    self.bubbleWrapView.clipsToBounds = true
//    self.bubbleWrapView.layer.cornerRadius = 15
//    self.bubbleWrapView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
  }
}
