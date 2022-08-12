//
//  ReceiverCell.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/19.
//  Copyright © 2021 rocateer. All rights reserved.
//


import UIKit

class ReceiverCell : UITableViewCell {
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var nickNameLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.profileImageView.setCornerRadius(radius: 14)
    
  }
  
  // 데이터 세팅
  func setReceiverData(member: MemberModel) {
    self.profileImageView.sd_setImage(with: URL(string: "\(baseURL)\(member.member_img ?? "")"), placeholderImage: UIImage(named: "default_profile"), options: .lowPriority, context: nil)
    self.nickNameLabel.text = member.member_nickname
    self.timeLabel.text = member.memo_date
  }
}
