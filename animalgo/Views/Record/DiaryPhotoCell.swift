//
//  DiaryPhotoCell.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/17.
//  Copyright © 2021 rocateer. All rights reserved.
//


import UIKit

class DiaryPhotoCell: UICollectionViewCell {
  @IBOutlet weak var photoImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.photoImageView.setCornerRadius(radius: 20)
  }
  
}
