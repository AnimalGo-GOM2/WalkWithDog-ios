//
//  RecordListCell.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/17.
//  Copyright © 2021 rocateer. All rights reserved.
//



import UIKit

class RecordListCell: UITableViewCell {
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var totalTimeLabel: UILabel!
  @IBOutlet weak var walkTimeLabel: UILabel!
  @IBOutlet weak var friendNickNameLabel: UILabel!
  @IBOutlet weak var friendAgeLabel: UILabel!
  @IBOutlet weak var friendGenderLabel: UILabel!
  @IBOutlet weak var friendPetNameLabel: UILabel!
  @IBOutlet weak var friendPetBreedLabel: UILabel!
  @IBOutlet weak var friendPetGenderLabel: UILabel!
  @IBOutlet weak var friendPetAgeLabel: UILabel!
  @IBOutlet weak var friendImageView: UIImageView!
  @IBOutlet weak var friendPetImageView: UIImageView!
  @IBOutlet weak var friendView: UIView!
  @IBOutlet weak var petImageStackView: UIStackView!
  
  var haveFriend = false
  let imgWrapView = UIView(frame: CGRect(x: 0, y: 0, w: 68, h: 68))
  let imageView1 = UIImageView(frame: CGRect(x: 0, y: 0, w: 68, h: 68))
  let imageView2 = UIImageView(frame: CGRect(x: 0, y: 0, w: 68, h: 68))
  let imageView3 = UIImageView(frame: CGRect(x: 0, y: 0, w: 68, h: 68))
  let imageView4 = UIImageView(frame: CGRect(x: 0, y: 0, w: 68, h: 68))
  let moreImageView = UIImageView(frame: CGRect(x: 44, y: 44, width: 22, height: 22))
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.friendImageView.setCornerRadius(radius: 20)
    self.friendPetImageView.setCornerRadius(radius: 16)
    
    if haveFriend {
      self.friendView.isHidden = false
    } else {
      self.friendView.isHidden = true
    }
  }
  
  // 반려견 이미지 세팅
  func setPetImageView(recordData: RecordModel) {
    let imageViews = [self.imageView1, self.imageView2, self.imageView3, self.imageView4]
    
    for (index, _) in imageViews.enumerated() {
      imageViews[index].setCornerRadius(radius: 34)
      imageViews[index].addBorder(width: 2, color: .white)
      imageViews[index].contentMode = .scaleAspectFill
      imageViews[index].removeFromSuperview()
    }
    
    self.imgWrapView.backgroundColor = .clear
    self.moreImageView.setCornerRadius(radius: 11)
    self.moreImageView.image = UIImage(named: "dog_more")!
    self.moreImageView.contentMode = .scaleAspectFill
    
    
    self.moreImageView.removeFromSuperview()
    self.imgWrapView.removeFromSuperview()
    
    if let my_animal_array = recordData.my_animal_array {
      for (index, _) in my_animal_array.enumerated() {
        self.petImageStackView.addArrangedSubview(imageViews[index])
      }
      
      if my_animal_array.count > 4 {
        self.imgWrapView.clipsToBounds = true
        self.imgWrapView.addSubview(self.imageView4)
        self.imgWrapView.addSubview(self.moreImageView)
        
        self.imageView4.translatesAutoresizingMaskIntoConstraints = false
        self.imageView4.centerXAnchor.constraint(equalTo: self.imgWrapView.centerXAnchor).isActive = true
        self.imageView4.centerYAnchor.constraint(equalTo: self.imgWrapView.centerYAnchor).isActive = true
      
        self.imageView4.widthAnchor.constraint(equalToConstant: 68).isActive = true
        self.imageView4.heightAnchor.constraint(equalToConstant: 68).isActive = true

        self.petImageStackView.addArrangedSubview(self.imgWrapView)
      }
    }
   
  }
  
  /// 데이터 세팅
  /// - Parameter recordData: 기록
  func setRecordData(recordData: RecordModel) {
    self.distanceLabel.text = "\(recordData.record_distant ?? "0.0")km"
    self.totalTimeLabel.text = "\(recordData.record_hour ?? "0")분"
    self.walkTimeLabel.text = recordData.record_start_date
    
    let imageViews = [self.imageView1, self.imageView2, self.imageView3, self.imageView4]
    if let my_animal_array = recordData.my_animal_array {
      for (index, value) in my_animal_array.enumerated() {
        imageViews[index].sd_setImage(with: URL(string: Tools.shared.thumbnailImageUrl(url: value.animal_img_path ?? "")), placeholderImage: UIImage(named: "default_profile"), options: .lowPriority, context: nil)
      }
    }
    
    self.setPetImageView(recordData: recordData)
    
  }
}
