//
//  WalkFriendCell.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/08.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit

class WalkFriendCell: UITableViewCell {
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var nickNameLabel: UILabel!
  @IBOutlet weak var ageLabel: UILabel!
  @IBOutlet weak var genderLabel: UILabel!
  @IBOutlet weak var walkTimeLabel: UILabel!
  @IBOutlet weak var petImageView: UIImageView!
  @IBOutlet weak var petNameLabel: UILabel!
  @IBOutlet weak var petBreedLabel: UILabel!
  @IBOutlet weak var petGenderLabel: UILabel!
  @IBOutlet weak var petAgeLabel: UILabel!
  @IBOutlet weak var personalityTagButton: UIButton!
  @IBOutlet weak var neuterTagButton: UIButton!
  @IBOutlet weak var trainedTagButton: UIButton!
  @IBOutlet weak var underView: UIView!
  @IBOutlet weak var isNewImageView: UIImageView!
  
  
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
  
  /// 산책친구와 함께
  func setRecordData(recordData: RecordModel) {
    self.profileImageView.sd_setImage(with: URL(string: Tools.shared.thumbnailImageUrl(url: recordData.member_img ?? "")), placeholderImage: UIImage(named: "default_profile"), options: .lowPriority, context: nil)
    self.nickNameLabel.text = recordData.member_nickname
    self.ageLabel.text = "\(recordData.member_age ?? "")대"
    self.genderLabel.text = recordData.member_gender == "0" ? "남성" : "여성"
    self.walkTimeLabel.text = recordData.record_date
    self.isNewImageView.isHidden = recordData.new_chat_yn == "N"
    if let animal_array = recordData.animal_array, animal_array.count > 0 {
      self.petImageView.sd_setImage(with: URL(string: Tools.shared.thumbnailImageUrl(url: animal_array[0].animal_img_path ?? "")), placeholderImage: UIImage(named: "default_dog1"), options: .lowPriority, context: nil)
      if let member_animal_cnt = animal_array[0].member_animal_cnt, member_animal_cnt > 1 {
        self.petNameLabel.text = "\(animal_array[0].animal_name ?? "") 외 \(member_animal_cnt - 1)"
      } else {
        self.petNameLabel.text = "\(animal_array[0].animal_name ?? "")"
      }
      self.petBreedLabel.text = animal_array[0].category_name
      self.petGenderLabel.text = animal_array[0].animal_gender == "0" ? "남아" : "여아"
      self.petAgeLabel.text = animal_array[0].animal_year
      self.personalityTagButton.setTitle("#\(characterString(animal_character: animal_array[0].animal_character ?? ""))", for: .normal)
      self.neuterTagButton.setTitle("\(animal_array[0].animal_neuter == "Y" ? "#중성화 했어요" : "#중성화 안 했어요")", for: .normal)
      self.trainedTagButton.setTitle("\(animal_array[0].animal_training == "Y" ? "#훈련 했어요" : "#훈련 안 했어요")", for: .normal)
    }
    
  }
  
}
