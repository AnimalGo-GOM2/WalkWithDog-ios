//
//  NSLabel.swift
//  animalgo
//
//  Created by rocateer on 2021/10/29.
//  Copyright © 2021 rocateer. All rights reserved.
//


import UIKit

@IBDesignable
class NSLabel : UILabel {
  @IBInspectable var weight: String = "r" {
    didSet {
      if weight == "b" {
        self.font = UIFont(name: "NotoSansCJKkr-Bold", size: self.font.pointSize)
      } else if weight == "m" {
        self.font = UIFont(name: "NotoSansCJKkr-Medium", size: self.font.pointSize)
      } else {
        self.font = UIFont(name: "NotoSansCJKkr-Regular", size: self.font.pointSize)
      }
    }
  }
}
