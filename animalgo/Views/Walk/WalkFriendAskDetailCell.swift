//
//  WalkFriendAskDetailCell.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/09.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit

class WalkFriendAskDetailCell: UICollectionViewCell {
  @IBOutlet weak var petImageView: UIImageView!
  @IBOutlet weak var petNameLabel: UILabel!
  @IBOutlet weak var breedLabel: UILabel!
  @IBOutlet weak var ageLabel: UILabel!
  @IBOutlet weak var personalityLabel: UILabel!
  @IBOutlet weak var neuterLabel: UILabel!
  @IBOutlet weak var trainedLabel: UILabel!
  @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  /// 데이터 세팅
  /// - Parameter recordData: 반려견 정보
  func setPetData(recordData: RecordModel) {
    self.petImageView.sd_setImage(with: URL(string: "\(baseURL)\(recordData.animal_img_path ?? "")"), placeholderImage: UIImage(named: "default_dog1"), options: .lowPriority, context: nil)
    self.petNameLabel.text = recordData.animal_name
    self.breedLabel.text = recordData.category_name
    self.ageLabel.text = "\(recordData.animal_year ?? "0")살"
    self.personalityLabel.text = characterString(animal_character: recordData.animal_character ?? "")
    self.neuterLabel.text = recordData.animal_neuter == "Y" ? "O" : "X"
    self.trainedLabel.text = recordData.animal_training == "Y" ? "O" : "X"
    
  }
}
