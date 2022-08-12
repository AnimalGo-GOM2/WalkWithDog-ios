//
//  RankingCell.swift
//  animalgo
//
//  Created by rocateer on 2021/10/29.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit

class RankingCell: UITableViewCell {
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var nickNameLabel: UILabel!
  @IBOutlet weak var ageLabel: UILabel!
  @IBOutlet weak var genderLabel: UILabel!
  @IBOutlet weak var petImageView: UIImageView!
  @IBOutlet weak var petNameLabel: UILabel!
  @IBOutlet weak var petBreedLabel: UILabel!
  @IBOutlet weak var petGenderLabel: UILabel!
  @IBOutlet weak var petAgeLabel: UILabel!
  @IBOutlet weak var personalityTagButton: UIButton!
  @IBOutlet weak var neuterTagButton: UIButton!
  @IBOutlet weak var trainedTagButton: UIButton!
  @IBOutlet weak var underView: UIView!
  @IBOutlet weak var totalWalksLabel: UILabel!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.profileImageView.setCornerRadius(radius: 20)
    self.petImageView.setCornerRadius(radius: 16)
    
    self.personalityTagButton.setCornerRadius(radius: 14.5)
    self.neuterTagButton.setCornerRadius(radius: 14.5)
    self.trainedTagButton.setCornerRadius(radius: 14.5)
    self.personalityTagButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.neuterTagButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.trainedTagButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
  }
  
  
  
  /// 데이터 세팅
  /// - Parameter recordData: recordData
  func setRankingData(recordData: MainModel) {
    self.profileImageView.sd_setImage(with: URL(string: Tools.shared.thumbnailImageUrl(url: recordData.member_img ?? "")), placeholderImage: UIImage(named: "default_profile"), options: .lowPriority, context: nil)
    self.nickNameLabel.text = recordData.member_nickname
    self.ageLabel.text = "\(recordData.member_age ?? "")대"
    self.genderLabel.text = recordData.member_gender == "0" ? "남성" : "여성"
    
    self.totalWalksLabel.text = "총 \(recordData.record_cnt ?? "0")회"
    if let petData = recordData.animal_obj {
      self.petImageView.sd_setImage(with: URL(string: "\(Tools.shared.thumbnailImageUrl(url: petData.animal_img_path ?? ""))"), completed: nil)
      self.petImageView.sd_setImage(with: URL(string: "\(Tools.shared.thumbnailImageUrl(url: petData.animal_img_path ?? ""))"), placeholderImage: UIImage(named: "default_dog1"), options: .lowPriority, context: nil)
      let animalList = recordData.member_animal_idxs?.components(separatedBy: ",") ?? [String]()
      if animalList.count > 1 {
        self.petNameLabel.text = "\(petData.animal_name ?? "") 외 \(animalList.count - 1)마리"
      } else {
        self.petNameLabel.text = "\(petData.animal_name ?? "")"
      }
      self.petBreedLabel.text = "\(petData.category_name ?? "")"
      self.petGenderLabel.text = petData.animal_gender == "0" ? "남아" : "여아"
      self.petAgeLabel.text = petData.animal_year ?? ""
      self.personalityTagButton.setTitle("#\(characterString(animal_character: petData.animal_character ?? ""))", for: .normal)
      self.neuterTagButton.setTitle("\(petData.animal_neuter == "Y" ? "#중성화 했어요" : "#중성화 안 했어요")", for: .normal)
      self.trainedTagButton.setTitle("\(petData.animal_training == "Y" ? "#훈련 했어요" : "#훈련 안 했어요")", for: .normal)
    }
  }
  
}
