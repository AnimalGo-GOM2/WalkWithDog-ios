//
//  BlockListCell.swift
//  animalgo
//
//  Created by rocateer on 2022/03/22.
//  Copyright © 2022 rocateer. All rights reserved.
//

import UIKit

class BlockListCell : UITableViewCell {
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var nickNameLabel: UILabel!
  @IBOutlet weak var blockButton: UIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.profileImageView.setCornerRadius(radius: 14)
    self.blockButton.setCornerRadius(radius: 6)
    self.blockButton.addBorder(width: 1, color: UIColor(named: "666666")!)
    
  }
  
  // 데이터 세팅
  func setBlockData(member: MemberModel) {
    self.profileImageView.sd_setImage(with: URL(string: "\(baseURL)\(member.member_img ?? "")"), placeholderImage: UIImage(named: "default_profile"), options: .lowPriority, context: nil)
    self.nickNameLabel.text = member.member_nickname
  }
}
