//
//  ChatSendCell.swift
//  animalgo
//
//  Created by rocateer on 2021/11/24.
//  Copyright © 2021 rocateer. All rights reserved.
//


import UIKit

class ChatSendCell: UITableViewCell {
  
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var chatWrapView: UIView!
  @IBOutlet weak var chatContentLabel: UILabel!
  @IBOutlet weak var chatContentWrapView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.chatWrapView.setCornerRadius(radius: 15)
//    self.chatContentWrapView.addBorder(width: 1, color: UIColor(named: "accent")!)
//    self.chatWrapView.clipsToBounds = true
//    self.chatWrapView.layer.cornerRadius = 15
//    self.chatWrapView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner, .layerMinXMinYCorner]
//    self.chatWrapView.layer.borderColor = UIColor(named: "accent")!.cgColor
//    self.chatWrapView.layer.borderWidth = 1
    
  }
  
}
