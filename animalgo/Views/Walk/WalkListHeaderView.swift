//
//  WalkListHeaderView.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/05.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit

class WalkListHeaderView: UIView {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var topButtonView: UIView!
  @IBOutlet weak var topView: UIView!
  @IBOutlet weak var headerTitleLabel: UILabel!
  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var walkJustMyPetButton: UIButton!
  @IBOutlet weak var walkWithFriendButton: UIButton!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var view: UIView!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - initialize
  //-------------------------------------------------------------------------------------------
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    initView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initView()
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  func initView() {
    view = loadViewFromNib()
    view.frame = bounds
    view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
    addSubview(view)
    
  }
  
  func loadViewFromNib() -> UIView {
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: "WalkListHeaderView", bundle: bundle)
    let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    return view
  }
}

