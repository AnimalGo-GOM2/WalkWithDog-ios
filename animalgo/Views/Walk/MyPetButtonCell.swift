//
//  MyPetButtonCell.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/08.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit

class MyPetButtonCell: UITableViewCell {
  
  @IBOutlet weak var petImageView: UIImageView!
  @IBOutlet weak var petNameLabel: UILabel!
  @IBOutlet weak var petButton: UIButton!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.petButton.setCornerRadius(radius: 10)
    self.petButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.petImageView.setCornerRadius(radius: 16)
  }
  
  
  /// 데이터 세팅
  /// - Parameter petData: 버튼
  func setPetData(petData: AnimalModel) {
    self.petImageView.sd_setImage(with: URL(string: Tools.shared.thumbnailImageUrl(url: petData.animal_img_path ?? "")), placeholderImage: UIImage(named: "default_dog1"), options: .lowPriority, context: nil)
    self.petNameLabel.text = petData.animal_name
    
    if petData.isSelected ?? false {
      self.petButton.addBorder(width: 2, color: UIColor(named: "accent")!)
      self.petButton.backgroundColor = UIColor(named: "F7FEFC")!
    } else {
      self.petButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
      self.petButton.backgroundColor = UIColor.clear
    }
  }

}
