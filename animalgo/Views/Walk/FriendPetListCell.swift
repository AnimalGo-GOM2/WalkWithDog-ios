//
//  FriendPetListCell.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/10.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit

class FriendPetListCell: UITableViewCell {
  @IBOutlet weak var petImageView: UIImageView!
  @IBOutlet weak var petNameLabel: UILabel!
  @IBOutlet weak var petGenderLabel: UILabel!
  @IBOutlet weak var ageLabel: UILabel!
  @IBOutlet weak var trainedLabel: UILabel!
  @IBOutlet weak var breedLabel: UILabel!
  @IBOutlet weak var neutralLabel: UILabel!
  @IBOutlet weak var personalityLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.petImageView.setCornerRadius(radius: 42)
  }
  
  
  /// 데이터 세팅
  /// - Parameter petData: 반려견 정보
  func setPetData(petData: RecordModel) {
    self.petImageView.sd_setImage(with: URL(string: Tools.shared.thumbnailImageUrl(url: petData.animal_img_path ?? "")), placeholderImage: UIImage(named: "default_dog1"), options: .lowPriority, context: nil)
    self.petNameLabel.text = petData.animal_name
    self.petGenderLabel.text = petData.animal_gender == "0" ? "남아" : "여아"
    self.breedLabel.text = petData.category_name
    self.ageLabel.text = "\(petData.animal_year ?? "0")살"
    self.personalityLabel.text = characterString(animal_character: petData.animal_character ?? "")
    self.neutralLabel.text = petData.animal_neuter == "Y" ? "O" : "X"
    self.trainedLabel.text = petData.animal_training == "Y" ? "O" : "X"
  }
}
