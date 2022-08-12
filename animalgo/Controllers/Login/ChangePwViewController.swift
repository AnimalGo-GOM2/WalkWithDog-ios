//
//  ChangePwViewController.swift
//  animalgo
//
//  Created by rocateer on 2020/01/15.
//  Copyright © 2020 rocateer. All rights reserved.
//

import UIKit
import Defaults

class ChangePwViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var oldPwTextField: UITextField!
  @IBOutlet weak var newPwTextField: UITextField!
  @IBOutlet weak var newCheckPwTextField: UITextField!
  @IBOutlet weak var changeButton: UIButton!
  
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
    self.oldPwTextField.addBorderBottom(size: 1, color: UIColor(named: "DDDDDD")!)
    self.newPwTextField.addBorderBottom(size: 1, color: UIColor(named: "DDDDDD")!)
    self.newCheckPwTextField.addBorderBottom(size: 1, color: UIColor(named: "DDDDDD")!)
    self.changeButton.setCornerRadius(radius: 5)
  }
  
  override func initRequest() {
    super.initRequest()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 비밀번호 변경
  func memberPwModUpAPI() {
    let memberParam = MemberModel()
    memberParam.member_idx = Defaults[.member_idx]
    memberParam.member_pw = self.oldPwTextField.text ?? ""
    memberParam.new_member_pw = self.newPwTextField.text ?? ""
    memberParam.new_member_pw_check = self.newCheckPwTextField.text ?? ""
    
    
    APIRouter.shared.api(path: .member_pw_mod_up, parameters: memberParam.toJSON()) { response in
      if let memberResponse = MemberModel(JSON: response), Tools.shared.isSuccessResponse(response: memberResponse) {
        Defaults[.member_pw] = self.newPwTextField.text ?? ""
        self.dismiss(animated: true, completion: nil)
      }
    } fail: { error in
      Tools.shared.showToast(message: "알수 없는 오류가 발생하였습니다.")
    }
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 변경
  /// - Parameter sender: 버튼
  @IBAction func changeTouched(sender: UIButton) {
    if self.newPwTextField.text != self.newCheckPwTextField.text {
      let alert = UIAlertController(title: "", message: "새 비밀번호와 새 비밀번호 확인이 일치하지 않습니다.\n다시 확인해 주세요.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    } else {
      self.memberPwModUpAPI()
    }
  }
  
}

