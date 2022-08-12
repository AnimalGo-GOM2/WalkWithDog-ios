//
//  WalkViewController.swift
//  animalgo
//
//  Created by rocateer on 2021/10/29.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit

class WalkViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var emptyPetView: UIView!
  @IBOutlet weak var walkView: UIView!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------

  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(self.walkViewUpdate), name: Notification.Name("WalkViewUpdate"), object: nil)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    self.emptyPetView.isHidden = self.appDelegate.myAnimalList.count != 0
    self.walkView.isHidden = self.appDelegate.myAnimalList.count == 0
  }
  
  override func initRequest() {
    super.initRequest()
    
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 산책하기 화면
  @objc func walkViewUpdate() {
    self.emptyPetView.isHidden = self.appDelegate.myAnimalList.count != 0
    self.walkView.isHidden = self.appDelegate.myAnimalList.count == 0
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  
}
