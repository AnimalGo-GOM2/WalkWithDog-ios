//
//  MessageListCell.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/18.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit

class MessageListCell : UITableViewCell {
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var nickNameLabel: UILabel!
  @IBOutlet weak var ageLabel: UILabel!
  @IBOutlet weak var genderLabel: UILabel!
  @IBOutlet weak var contentLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var isNewImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.profileImageView.setCornerRadius(radius: 14)
    self.isNewImageView.isHidden = true
//    self.isNewImageView.isHiddenWhenSkeletonIsActive = true
  }
  
  // 세팅
  func setMessageData(msgData: MemberModel) {
    self.profileImageView.sd_setImage(with: URL(string: "\(baseURL)\(msgData.member_img ?? "")"), placeholderImage: UIImage(named: "default_profile"), options: .lowPriority, context: nil)
    self.nickNameLabel.text = msgData.member_nickname
    self.ageLabel.text = "\(msgData.member_age ?? "")대"
    if msgData.member_gender == "0" {
      self.genderLabel.text = "남성"
    } else {
      self.genderLabel.text = "여성"
    }
    self.contentLabel.text = msgData.contents
    self.timeLabel.text = msgData.ins_date
    if !msgData.read_yn.isNil {
      self.isNewImageView.isHidden = msgData.read_yn == "Y"
    }
  }
}
