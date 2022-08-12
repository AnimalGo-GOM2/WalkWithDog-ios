//
//  MemberOutViewController.swift
//  animalgo
//
//  Created by rocateer on 2020/03/03.
//  Copyright © 2020 rocateer. All rights reserved.
//

import UIKit
import Defaults

class MemberOutViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var reasonWrapView: UIView!
  @IBOutlet weak var reasonTextField: UITextField!
  @IBOutlet weak var reationTextView: UITextView!
  @IBOutlet weak var moreUserButton: UIButton!
  
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var pickerArray = ["선택해주세요", "사용하지 않음", "컨텐츠 부족", "부적절한 컨텐츠", "기타"]
  var pickerView = UIPickerView()
  var type = ""
  
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.pickerView.delegate = self
    self.reasonTextField.inputView = pickerView
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    self.reasonTextField.addBorder(width: 1, color: UIColor(named: "DDDDDD")!)
    self.moreUserButton.addBorder(width: 1, color: UIColor(named: "DDDDDD")!)
    self.reasonTextField.addLeftTextPadding(20)
    self.reasonTextField.tintColor = .clear
  }
  
  override func initRequest() {
    super.initRequest()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 회원탈퇴
  func memberOutUpAPI() {
    let memberRequest = MemberModel()
    memberRequest.member_idx = Defaults[.member_idx]
    memberRequest.member_leave_type = self.type
    memberRequest.member_leave_reason = self.reationTextView.text
    
    APIRouter.shared.api(path: .member_out_up, parameters: memberRequest.toJSON()) { response in
      if let memberResponse = MemberModel(JSON: response), Tools.shared.isSuccessResponse(response: memberResponse) {
        AJAlertController.initialization().showAlertWithOkButton(astrTitle: "", aStrMessage: "회원 탈퇴가 완료되었습니다.", alertViewHiddenCheck: false) { position, title in
          if position == 0 {
            Defaults.removeAll()
            Defaults[.tutorial] = true
            self.navigationController?.popViewController(animated: true)
          }
        }
      }
    } fail: { error in
      Tools.shared.showToast(message: "알수 없는 오류가 발생하였습니다.")
    }

  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 안내사항 동의
  /// - Parameter sender: 버튼
  @IBAction func agreeTouched(sender: UIButton) {
    sender.isSelected = !sender.isSelected
  }
  
  /// 탈퇴할래요
  /// - Parameter sender: 버튼
  @IBAction func memberoutTouched(sender: UIButton) {
//    if !self.agreeButton.isSelected {
//    AJAlertController.initialization().showAlertWithOkButton(astrTitle: "", aStrMessage: "회원탈퇴 동의에 체크해주세요.", alertViewHiddenCheck: false) { position, title in
//      
//    }
//    } else {
//      self.memberOutUpAPI()
//    }
    self.memberOutUpAPI()
  }
  
}

//-------------------------------------------------------------------------------------------
// MARK: - UIPickerViewDelegate
//-------------------------------------------------------------------------------------------
extension MemberOutViewController: UIPickerViewDelegate {
  
}


//-------------------------------------------------------------------------------------------
// MARK: - UIPickerViewDataSource
//-------------------------------------------------------------------------------------------
extension MemberOutViewController: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return self.pickerArray.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return self.pickerArray[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if row == 0 {
      self.type = ""
    } else {
      self.type = "\(row - 1)"
    }
    self.reasonTextField.text = self.pickerArray[row]
  }
  
}



