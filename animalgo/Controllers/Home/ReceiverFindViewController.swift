//
//  ReceiverFindViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/19.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import Defaults

class ReceiverFindViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var nickNameTextField: UITextField!
  @IBOutlet weak var findNickButton: UIButton!
  @IBOutlet weak var findButton: UIButton!
  @IBOutlet weak var ownerGenderMButton: UIButton!
  @IBOutlet weak var ownerGenderFButton: UIButton!
  @IBOutlet weak var ownerGenderNoMatterButton: UIButton!
  @IBOutlet weak var age20thButton: UIButton!
  @IBOutlet weak var age30thButton: UIButton!
  @IBOutlet weak var age40thButton: UIButton!
  @IBOutlet weak var age50thButton: UIButton!
  @IBOutlet weak var ageNoMatterButton: UIButton!
  @IBOutlet weak var textDeleteButton: UIButton!
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
    
    self.ownerGenderFButton.setCornerRadius(radius: 10)
    self.ownerGenderMButton.setCornerRadius(radius: 10)
    self.ownerGenderNoMatterButton.setCornerRadius(radius: 10)
    self.age20thButton.setCornerRadius(radius: 10)
    self.age30thButton.setCornerRadius(radius: 10)
    self.age40thButton.setCornerRadius(radius: 10)
    self.age50thButton.setCornerRadius(radius: 10)
    self.ageNoMatterButton.setCornerRadius(radius: 10)
    self.findButton.setCornerRadius(radius: 10)
    
    self.ownerGenderFButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.ownerGenderMButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.ownerGenderNoMatterButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.age20thButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.age30thButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.age40thButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.age50thButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.ageNoMatterButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    
    self.ownerGenderNoMatterButton.isSelected = true
    self.ageNoMatterButton.isSelected = true
    
    self.selectedButtonColor(button: self.ownerGenderNoMatterButton)
    self.selectedButtonColor(button: self.ageNoMatterButton)
    
    self.nickNameTextField.delegate = self
  }
  
  override func initRequest() {
    super.initRequest()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  
  
  // 선택된 버튼 색변경
  func selectedButtonColor(button: UIButton){
    button.addBorder(width: 2, color: UIColor(named: "accent")!)
    button.backgroundColor = UIColor(named: "F7FEFC")!
  }
  // 미선택 버튼 색
  func notSelectedButtonColor(button: UIButton) {
    button.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    button.backgroundColor = UIColor.white
  }
  
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  
  /// 보호자 성별 선택
  /// - Parameter sender: UIButton
  @IBAction func ownerGenderButtonTouched(sender:UIButton) {
    if sender == self.ownerGenderMButton {
      self.ownerGenderMButton.isSelected = true
      self.ownerGenderFButton.isSelected = false
      self.ownerGenderNoMatterButton.isSelected = false
      selectedButtonColor(button: self.ownerGenderMButton)
      notSelectedButtonColor(button: self.ownerGenderFButton)
      notSelectedButtonColor(button: self.ownerGenderNoMatterButton)
    }else if sender == self.ownerGenderFButton {
      self.ownerGenderMButton.isSelected = false
      self.ownerGenderFButton.isSelected = true
      self.ownerGenderNoMatterButton.isSelected = false
      selectedButtonColor(button: self.ownerGenderFButton)
      notSelectedButtonColor(button: self.ownerGenderMButton)
      notSelectedButtonColor(button: self.ownerGenderNoMatterButton)
    }else {
      self.ownerGenderMButton.isSelected = false
      self.ownerGenderFButton.isSelected = false
      self.ownerGenderNoMatterButton.isSelected = true
      selectedButtonColor(button: self.ownerGenderNoMatterButton)
      notSelectedButtonColor(button: self.ownerGenderMButton)
      notSelectedButtonColor(button: self.ownerGenderFButton)
    }
  }
  
  /// 보호자 나이
  /// - Parameter sender: UIButton
  @IBAction func ageButtonTouched(sender: UIButton) {
    if sender == self.age20thButton {
      self.age20thButton.isSelected = true
      self.age30thButton.isSelected = false
      self.age40thButton.isSelected = false
      self.age50thButton.isSelected = false
      self.ageNoMatterButton.isSelected = false
      selectedButtonColor(button: self.age20thButton)
      notSelectedButtonColor(button: self.age30thButton)
      notSelectedButtonColor(button: self.age40thButton)
      notSelectedButtonColor(button: self.age50thButton)
      notSelectedButtonColor(button: self.ageNoMatterButton)
    }else if sender == self.age30thButton {
      self.age20thButton.isSelected = false
      self.age30thButton.isSelected = true
      self.age40thButton.isSelected = false
      self.age50thButton.isSelected = false
      self.ageNoMatterButton.isSelected = false
      notSelectedButtonColor(button: self.age20thButton)
      selectedButtonColor(button: self.age30thButton)
      notSelectedButtonColor(button: self.age40thButton)
      notSelectedButtonColor(button: self.age50thButton)
      notSelectedButtonColor(button: self.ageNoMatterButton)
    }else if sender == self.age40thButton {
      self.age20thButton.isSelected = false
      self.age30thButton.isSelected = false
      self.age40thButton.isSelected = true
      self.age50thButton.isSelected = false
      self.ageNoMatterButton.isSelected = false
      notSelectedButtonColor(button: self.age20thButton)
      notSelectedButtonColor(button: self.age30thButton)
      selectedButtonColor(button: self.age40thButton)
      notSelectedButtonColor(button: self.age50thButton)
      notSelectedButtonColor(button: self.ageNoMatterButton)
    }else if sender == self.age50thButton {
      self.age20thButton.isSelected = false
      self.age30thButton.isSelected = false
      self.age40thButton.isSelected = false
      self.age50thButton.isSelected = true
      self.ageNoMatterButton.isSelected = false
      notSelectedButtonColor(button: self.age20thButton)
      notSelectedButtonColor(button: self.age30thButton)
      notSelectedButtonColor(button: self.age40thButton)
      selectedButtonColor(button: self.age50thButton)
      notSelectedButtonColor(button: self.ageNoMatterButton)
    }else {
      self.age20thButton.isSelected = false
      self.age30thButton.isSelected = false
      self.age40thButton.isSelected = false
      self.age50thButton.isSelected = false
      self.ageNoMatterButton.isSelected = true
      notSelectedButtonColor(button: self.age20thButton)
      notSelectedButtonColor(button: self.age30thButton)
      notSelectedButtonColor(button: self.age40thButton)
      notSelectedButtonColor(button: self.age50thButton)
      selectedButtonColor(button: self.ageNoMatterButton)
    }
  }
  @IBAction func findButtonTouched(sender: UIButton) {
    if self.nickNameTextField.text?.count ?? 0 == 0 && self.ownerGenderNoMatterButton.isSelected && self.ageNoMatterButton.isSelected {
      AJAlertController.initialization().showAlertWithOkButton(astrTitle: "", aStrMessage: "닉네임, 성별, 나이대 중 최소 하나를 입력 해야 합니다.", alertViewHiddenCheck: false){
        
        (position, title) in
      }
    } else {
      let destination = ReceiverListViewController.instantiate(storyboard: "Home")
      
      if self.ownerGenderFButton.isSelected {
        destination.memberRequest.member_gender = "1"
      } else if self.ownerGenderMButton.isSelected {
        destination.memberRequest.member_gender = "0"
      } else {
        destination.memberRequest.member_gender = ""
      }
      
      if self.age20thButton.isSelected {
        destination.memberRequest.member_age = "20"
      } else if self.age30thButton.isSelected {
        destination.memberRequest.member_age = "30"
      } else if self.age40thButton.isSelected {
        destination.memberRequest.member_age = "40"
      } else if self.age50thButton.isSelected {
        destination.memberRequest.member_age = "50"
      } else {
        destination.memberRequest.member_age = ""
      }
      
      destination.nickname = self.nickNameTextField.text ?? ""
      self.navigationController?.pushViewController(destination, animated: true)
    }
  }
  
  @IBAction func textDeleteButtonTouched(sender: UIButton) {
    self.nickNameTextField.text = ""
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UITextFieldDelegate
//-------------------------------------------------------------------------------------------
extension ReceiverFindViewController : UITextFieldDelegate {
  func textFieldDidChangeSelection(_ textField: UITextField) {
    
    if textField.text?.count ?? 0 > 0 {
      self.textDeleteButton.isHidden = false
    } else {
      self.textDeleteButton.isHidden = true
    }
  }
  
}
