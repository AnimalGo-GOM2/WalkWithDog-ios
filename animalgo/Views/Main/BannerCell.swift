//
//  BannerCell.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/23.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit

class BannerCell: UICollectionViewCell {
  
  @IBOutlet weak var bannerImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.bannerImageView.setCornerRadius(radius: 20)
  }
  
  /// 데이터 세팅
  /// - Parameter bannerData: 배너
  func setBannderData(bannerData: MainModel) {
    self.bannerImageView.sd_setImage(with: URL(string: "\(baseURL)\(bannerData.img_path ?? "")"), completed: nil)
  }
}
