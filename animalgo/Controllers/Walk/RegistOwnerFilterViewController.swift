//
//  RegistOwnerFilterViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/15.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import Defaults

class RegistOwnerFilterViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var ownerGenderMButton: UIButton!
  @IBOutlet weak var ownerGenderFButton: UIButton!
  @IBOutlet weak var ownerGenderNoMatterButton: UIButton!
  @IBOutlet weak var age20thButton: UIButton!
  @IBOutlet weak var age30thButton: UIButton!
  @IBOutlet weak var age40thButton: UIButton!
  @IBOutlet weak var age50thButton: UIButton!
  @IBOutlet weak var ageNoMatterButton: UIButton!
  @IBOutlet weak var expsureToAllButton: UIButton!
  @IBOutlet weak var registButton: UIButton!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var recordRequest = RecordModel()
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
    self.cancelButton.setCornerRadius(radius: 10)
    self.registButton.setCornerRadius(radius: 10)
    self.ownerGenderFButton.setCornerRadius(radius: 10)
    self.ownerGenderMButton.setCornerRadius(radius: 10)
    self.ownerGenderNoMatterButton.setCornerRadius(radius: 10)
    self.age20thButton.setCornerRadius(radius: 10)
    self.age30thButton.setCornerRadius(radius: 10)
    self.age40thButton.setCornerRadius(radius: 10)
    self.age50thButton.setCornerRadius(radius: 10)
    self.ageNoMatterButton.setCornerRadius(radius: 10)
    
    self.ownerGenderFButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.ownerGenderMButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.ownerGenderNoMatterButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.age20thButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.age30thButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.age40thButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.age50thButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.ageNoMatterButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    
    self.expsureToAllButton.isSelected = true
    
    if self.expsureToAllButton.isSelected {
      self.ageNoMatterButton.isSelected = true
      self.ownerGenderNoMatterButton.isSelected = true
      self.selectedButtonColor(button: self.ageNoMatterButton)
      self.selectedButtonColor(button: self.ownerGenderNoMatterButton)
    }
  }
  
  override func initRequest() {
    super.initRequest()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  // 선택된 버튼 색변경
  func selectedButtonColor(button: UIButton){
    if button.isSelected {
      button.addBorder(width: 2, color: UIColor(named: "accent")!)
      button.backgroundColor = UIColor(named: "F7FEFC")!
    } else {
      button.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
      button.backgroundColor = UIColor.white
    }
  }
  
  // 모두 상관없어요 체크
  func checkNoMattherAllButton() {
    if self.ageNoMatterButton.isSelected && self.ownerGenderNoMatterButton.isSelected {
      self.expsureToAllButton.isSelected = true
    } else {
      self.expsureToAllButton.isSelected = false
    }
  }
  
  /// 산책 등록
  func recordRegInAPI() {
    self.recordRequest.member_idx = Defaults[.member_idx]

    if self.ownerGenderMButton.isSelected {
      self.recordRequest.guardian_gender = "0"
    } else if self.ownerGenderFButton.isSelected {
      self.recordRequest.guardian_gender = "1"
    } else {
      self.recordRequest.guardian_gender = ""
    }
    
    if self.age20thButton.isSelected {
      self.recordRequest.guardian_age = "20"
    } else if self.age30thButton.isSelected {
      self.recordRequest.guardian_age = "30"
    } else if self.age40thButton.isSelected {
      self.recordRequest.guardian_age = "40"
    } else if self.age50thButton.isSelected {
      self.recordRequest.guardian_age = "50"
    } else {
      self.recordRequest.guardian_age = ""
    }
    
    APIRouter.shared.api(path: APIURL.record_reg_in, method: .post, parameters: recordRequest.toJSON()) { response in
      if let recordResponse = RecordModel(JSON: response), Tools.shared.isSuccessResponse(response: recordResponse) {
        NotificationCenter.default.post(name: Notification.Name("RegisteredRecordListUpdate"), object: nil)
        self.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
      }
    } fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }

  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  
  /// 모든 회원에게 노출
  /// - Parameter sender: UIButton
  @IBAction func exposureToAllButtonTouched(sender: UIButton) {
    self.expsureToAllButton.isSelected = true
    
    self.ownerGenderMButton.isSelected = false
    self.ownerGenderFButton.isSelected = false
    self.ownerGenderNoMatterButton.isSelected = true
    selectedButtonColor(button: self.ownerGenderNoMatterButton)
    selectedButtonColor(button: self.ownerGenderMButton)
    selectedButtonColor(button: self.ownerGenderFButton)
    
    self.age20thButton.isSelected = false
    self.age30thButton.isSelected = false
    self.age40thButton.isSelected = false
    self.age50thButton.isSelected = false
    self.ageNoMatterButton.isSelected = true
    selectedButtonColor(button: self.age20thButton)
    selectedButtonColor(button: self.age30thButton)
    selectedButtonColor(button: self.age40thButton)
    selectedButtonColor(button: self.age50thButton)
    selectedButtonColor(button: self.ageNoMatterButton)
  }
  
  /// 보호자 성별 선택
  /// - Parameter sender: UIButton
  @IBAction func ownerGenderButtonTouched(sender:UIButton) {
    self.ownerGenderMButton.isSelected = false
    self.ownerGenderFButton.isSelected = false
    self.ownerGenderNoMatterButton.isSelected = false
    
    if sender == self.ownerGenderMButton {
      self.ownerGenderMButton.isSelected = true
    } else if sender == self.ownerGenderFButton {
      self.ownerGenderFButton.isSelected = true
    } else {
      self.ownerGenderNoMatterButton.isSelected = true
    }
    
    self.selectedButtonColor(button: self.ownerGenderMButton)
    self.selectedButtonColor(button: self.ownerGenderFButton)
    self.selectedButtonColor(button: self.ownerGenderNoMatterButton)
    self.checkNoMattherAllButton()
  }
  
  /// 보호자 나이
  /// - Parameter sender: UIButton
  @IBAction func ageButtonTouched(sender: UIButton) {
    self.age20thButton.isSelected = false
    self.age30thButton.isSelected = false
    self.age40thButton.isSelected = false
    self.age50thButton.isSelected = false
    self.ageNoMatterButton.isSelected = false
    
    if sender == self.age20thButton {
      self.age20thButton.isSelected = true
    } else if sender == self.age30thButton {
      self.age30thButton.isSelected = true
    } else if sender == self.age40thButton {
      self.age40thButton.isSelected = true
    } else if sender == self.age50thButton {
      self.age50thButton.isSelected = true
    } else {
      self.ageNoMatterButton.isSelected = true
    }
    
    self.selectedButtonColor(button: self.age20thButton)
    self.selectedButtonColor(button: self.age30thButton)
    self.selectedButtonColor(button: self.age40thButton)
    self.selectedButtonColor(button: self.age50thButton)
    self.selectedButtonColor(button: self.ageNoMatterButton)
    self.checkNoMattherAllButton()
  }
  
  /// 취소
  /// - Parameter sender: UIButton
  @IBAction func cancelButtonTouched(sender: UIButton) {
    self.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
  }
  
  /// 등록
  /// - Parameter sender: UIButton
  @IBAction func registButtonTouched(sender: UIButton) {
    self.recordRegInAPI()
  }
  
}
