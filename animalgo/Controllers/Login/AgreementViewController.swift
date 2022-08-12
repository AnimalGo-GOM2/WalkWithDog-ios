//
//  AgreementViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/02.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit

class AgreementViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var agreeAllButton: UIButton!
  @IBOutlet weak var termsAgreeButton: UIButton!
  @IBOutlet weak var personalInfoAgreeButton: UIButton!
  @IBOutlet weak var locationServiceAgreeButton: UIButton!
  @IBOutlet weak var marketingInfoAgreeButton: UIButton!
  @IBOutlet weak var termsOfUseButton: UIButton!
  @IBOutlet weak var personalInfoButton: UIButton!
  @IBOutlet weak var locationButton: UIButton!
  @IBOutlet weak var nextButton: UIButton!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------

  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    self.nextButton.setCornerRadius(radius: 10)
  }
  
  override func initRequest() {
    super.initRequest()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 개별 동의 버튼 터치
  /// - Parameter sender: UIButton
  @IBAction func agreeButtonTouched(sender : UIButton){
    sender.isSelected = !sender.isSelected
    if !sender.isSelected{
      self.agreeAllButton.isSelected = false
    }
    
    if self.termsAgreeButton.isSelected && self.personalInfoAgreeButton.isSelected && self.marketingInfoAgreeButton.isSelected && self.locationServiceAgreeButton.isSelected{
      self.agreeAllButton.isSelected = true
    }
  }
  
  /// 전체 동의 버튼 터치
  /// - Parameter sender: UIButton
  @IBAction func agreeAllButtonTouched(sender: UIButton){
    
    if !sender.isSelected {
      self.termsAgreeButton.isSelected = true
      self.personalInfoAgreeButton.isSelected = true
      self.marketingInfoAgreeButton.isSelected = true
      self.locationServiceAgreeButton.isSelected = true
      sender.isSelected = true
    } else {
      self.termsAgreeButton.isSelected = false
      self.personalInfoAgreeButton.isSelected = false
      self.marketingInfoAgreeButton.isSelected = false
      self.locationServiceAgreeButton.isSelected = false
      sender.isSelected = false
    }
  }
  
  /// 약관 보기
  /// - Parameter sender: UIButton
  @IBAction func termsButtonTouched(sender: UIButton) {
    let destination = WebViewController.instantiate(storyboard: "Commons")
    if sender == self.termsOfUseButton {
      destination.webType = .Terms0
    } else if sender == self.personalInfoButton {
      destination.webType = .Terms1
    } else if sender == self.locationButton {
      destination.webType = .Terms2
    }
    
    self.navigationController?.pushViewController(destination, animated: true)
  }
  
  /// 다음 버튼 터치
  /// - Parameter sender: UIButton
  @IBAction func nextButtonTouched(sender: UIButton) {
    guard self.termsAgreeButton.isSelected else {
      Tools.shared.showToast(message: "이용약관에 동의하셔야 합니다.")
      return
    }
    
    guard self.personalInfoAgreeButton.isSelected else {
      Tools.shared.showToast(message: "개인정보 취급방침에 동의하셔야 합니다.")
      return
    }
    
    guard self.locationServiceAgreeButton.isSelected else {
      Tools.shared.showToast(message: "위치 서비스 이용 약관에 동의하셔야 합니다.")
      return
    }
    let destination = JoinViewController.instantiate(storyboard: "Login")
    self.navigationController?.pushViewController(destination, animated: true)
  }
}
