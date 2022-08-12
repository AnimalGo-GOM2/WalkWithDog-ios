//
//  JoinFinishViewController.swift
//  animalgo
//
//  Created by rocateer on 2020/01/15.
//  Copyright © 2020 rocateer. All rights reserved.
//

import UIKit

class JoinFinishViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var toLoginButton: UIButton!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.setNavigationBarHidden(true, animated: false)
    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
//    self.toLoginButton.addBorder(width: 1, color: Colors._EA474F)
    self.toLoginButton.setCornerRadius(radius: 10)
  }
  
  override func initRequest() {
    super.initRequest()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 로그인 화면으로
  /// - Parameter sender: 버튼
  @IBAction func toLoginTouched(sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
  
}
