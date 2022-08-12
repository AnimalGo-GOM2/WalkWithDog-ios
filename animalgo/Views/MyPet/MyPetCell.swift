//
//  MyPetCell.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/04.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit

class MyPetCell: UITableViewCell {
  @IBOutlet weak var petImageView: UIImageView!
  @IBOutlet weak var petNameLabel: UILabel!
  @IBOutlet weak var petGenderLabel: UILabel!
  @IBOutlet weak var countLabel: UILabel!
  @IBOutlet weak var birthLabel: UILabel!
  @IBOutlet weak var breedLabel: UILabel!
  @IBOutlet weak var neutralLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.petImageView.setCornerRadius(radius: 42)
  }
  
  /// 데이터 세팅
  /// - Parameter petData: 반려견 
  func setPetData(petData: AnimalModel) {
    self.petImageView.sd_setImage(with: URL(string: Tools.shared.thumbnailImageUrl(url: petData.animal_img_path ?? "")), placeholderImage: UIImage(named: "default_dog1"), options: .lowPriority, context: nil)
    self.petNameLabel.text = petData.animal_name
    self.petGenderLabel.text = petData.animal_gender == "0" ? "남아" : "여아"
    self.countLabel.text = "\(petData.record_cnt ?? "0")회"
    self.birthLabel.text = "\(petData.ins_date ?? "")(\(calculateAge(birth: petData.animal_birth ?? ""))살)"
    self.breedLabel.text = "\(petData.first_category ?? "")(\(petData.second_category ?? ""))"
    self.neutralLabel.text = petData.animal_neuter == "Y" ? "O" : "X"
    
  }
}
