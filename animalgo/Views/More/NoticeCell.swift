//
//  NoticeCell.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/03.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit

class NoticeCell: UITableViewCell {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  /// 세팅
  func setNoticeData(noticeData: NoticeModel) {
    self.titleLabel.text = noticeData.title
    self.dateLabel.text = noticeData.ins_date
  }
}
