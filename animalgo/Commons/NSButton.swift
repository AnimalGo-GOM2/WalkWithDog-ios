//
//  NSButton.swift
//  animalgo
//
//  Created by rocateer on 2021/12/21.
//  Copyright © 2021 rocateer. All rights reserved.
//


import UIKit

@IBDesignable
class NSButton : UIButton {
  @IBInspectable var weight: String = "r" {
    didSet {
      if weight == "bk" {
        self.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Black", size: self.titleLabel?.font.pointSize ?? 14)
      } else if weight == "b" {
        self.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Bold", size: self.titleLabel?.font.pointSize ?? 14)
      } else if weight == "d" {
        self.titleLabel?.font = UIFont(name: "NotoSansCJKkr-DemiLight", size: self.titleLabel?.font.pointSize ?? 14)
      } else if weight == "l" {
        self.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Light", size: self.titleLabel?.font.pointSize ?? 14)
      } else if weight == "m" {
        self.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Medium", size: self.titleLabel?.font.pointSize ?? 14)
      } else if weight == "t" {
        self.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Thin", size: self.titleLabel?.font.pointSize ?? 14)
      } else {
        self.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Regular", size: self.titleLabel?.font.pointSize ?? 14)
      }
    }
  }
}
