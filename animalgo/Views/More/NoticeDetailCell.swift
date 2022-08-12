//
//  NoticeDetailCell.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/03.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit

class NoticeDetailCell: UITableViewCell {
  @IBOutlet weak var contentsLabel: UILabel!
  @IBOutlet weak var noticeImageView: UIImageView!
  @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
  override func awakeFromNib() {
    super.awakeFromNib()
  }
}
