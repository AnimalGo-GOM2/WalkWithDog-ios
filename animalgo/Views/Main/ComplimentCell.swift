//
//  ComplimentCell.swift
//  animalgo
//
//  Created by rocateer on 2021/10/29.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit

class ComplimentCell: UICollectionViewCell {
  
  @IBOutlet weak var memberImageView: UIImageView!
  @IBOutlet weak var nicknameLabel: UILabel!
  @IBOutlet weak var starLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.memberImageView.setCornerRadius(radius: 14)
  }
  
  /// 데이터 세팅
  /// - Parameter complimentData: 칭찬해요 
  func setComplimentData(complimentData: MainModel) {
    self.memberImageView.sd_setImage(with: URL(string: Tools.shared.thumbnailImageUrl(url: complimentData.member_img ?? "")), placeholderImage: UIImage(named: "default_profile"), options: .lowPriority, context: nil)
    self.nicknameLabel.text = complimentData.member_nickname
    self.starLabel.text = complimentData.review_star
  }
}
