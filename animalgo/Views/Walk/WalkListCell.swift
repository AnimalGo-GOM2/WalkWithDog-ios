//
//  WalkListCell.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/08.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit

class WalkListCell: UITableViewCell {
  
  @IBOutlet weak var petImageView: UIImageView!
  @IBOutlet weak var petNameLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var isNewImageView: UIImageView!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.petImageView.setCornerRadius(radius: 42)
  }
  
  /// 산책친구
  /// - Parameter recordData: 기록 데이터
  func setWalkData(recordData: RecordModel) {
    self.petImageView.sd_setImage(with: URL(string: Tools.shared.thumbnailImageUrl(url: recordData.animal_img_path ?? "")), placeholderImage: UIImage(named: "default_dog1"), options: .lowPriority, context: nil)
    if let member_animal_cnt = recordData.member_animal_cnt, member_animal_cnt > 1 {
      self.petNameLabel.text = "\(recordData.animal_name ?? "") 외 \(member_animal_cnt - 1)마리"
    } else {
      self.petNameLabel.text = "\(recordData.animal_name ?? "")"
    }
//    if let record_date = recordData.record_date {
//      let dateFormatter = DateFormatter()
//      dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
//      let date = dateFormatter.date(from: record_date)
//
//    }
    self.timeLabel.text = recordData.record_date ?? ""
    self.addressLabel.text = recordData.record_addr
    self.isNewImageView.isHidden = recordData.new_chat_yn == "N"
  }
}
