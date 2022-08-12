//
//  ChatHeaderView.swift
//  animalgo
//
//  Created by rocateer on 2021/11/24.
//  Copyright © 2021 rocateer. All rights reserved.
//


import UIKit

class ChatHeaderView: UIView {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var dayWrapView: UIView!
  @IBOutlet weak var dayLabel: UILabel!
  
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
    self.dayWrapView.setCornerRadius(radius: self.dayWrapView.frame.size.height / 2)
  }
  
  func loadViewFromNib() -> UIView {
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: "ChatHeaderView", bundle: bundle)
    let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    return view
  }
}
