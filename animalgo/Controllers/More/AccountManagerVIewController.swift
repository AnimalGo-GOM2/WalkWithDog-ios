//
//  AccountManagerVIewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/03.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import Defaults

class AccountManagerVIewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var nowPwTextField: UITextField!
  @IBOutlet weak var newPwTextField: UITextField!
  @IBOutlet weak var newPwConfirmTextField: UITextField!
  @IBOutlet weak var finishButton: UIButton!
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
    
    self.nowPwTextField.addBorderBottom(size: 1, color: UIColor(named: "EAE8E5")!)
    self.newPwTextField.addBorderBottom(size: 1, color: UIColor(named: "EAE8E5")!)
    self.newPwConfirmTextField.addBorderBottom(size: 1, color: UIColor(named: "EAE8E5")!)
    self.finishButton.setCornerRadius(radius: 10)
  }
  
  override func initRequest() {
    super.initRequest()
    self.memberPwModViewAPI()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 비밀번호 변경 API
  func memberPwModAPI() {
    let memberRequest = MemberModel()
    memberRequest.member_idx = Defaults[.member_idx]
    memberRequest.member_pw = self.nowPwTextField.text
    memberRequest.new_member_pw = self.newPwTextField.text
    memberRequest.new_member_pw_check = self.newPwConfirmTextField.text
    
    APIRouter.shared.api(path: .member_pw_mod_up, parameters: memberRequest.toJSON()) { response in
      if let memberResponse = MemberModel(JSON: response), Tools.shared.isSuccessResponse(response: memberResponse) {
        AJAlertController.initialization().showAlertWithOkButton(astrTitle: "", aStrMessage: memberResponse.code_msg ?? "", alertViewHiddenCheck: false){
          (position, title) in
          if position == 0 {
            self.dismiss(animated: true)
          }
        }
      }
    } fail: { error in
      Tools.shared.showToast(message: "알수 없는 오류가 발생하였습니다.")
    }
  }
  
  /// 계정관리 뷰 API
  func memberPwModViewAPI() {
    let memberRequest = MemberModel()
    memberRequest.member_idx = Defaults[.member_idx]
    
    APIRouter.shared.api(path: .member_pw_mod_view, parameters: memberRequest.toJSON()) { response in
      if let memberResponse = MemberModel(JSON: response), Tools.shared.isSuccessResponse(response: memberResponse) {
        self.emailLabel.text = memberResponse.member_id ?? ""
      }
    } fail: { error in
      Tools.shared.showToast(message: "알수 없는 오류가 발생하였습니다.")
    }
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 완료 버튼
  /// - Parameter sender: 버튼
  @IBAction func finishButtonTouched(sender: UIButton) {
    self.memberPwModAPI()
  }
}
