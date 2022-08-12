//
//  JoinViewController.swift
//  animalgo
//
//  Created by rocateer on 19/09/2019.
//  Copyright © 2019 rocateer. All rights reserved.
//

import UIKit

class JoinViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var pwTextField: UITextField!
  @IBOutlet weak var pwConfirmTextField: UITextField!
  @IBOutlet weak var nickNameTextField: UITextField!
  @IBOutlet weak var certificationButton: UIButton!
  @IBOutlet weak var nextButton: UIButton!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  let memberRequest = MemberModel()
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
    
    self.emailTextField.addBorderBottom(size: 1, color: UIColor(named: "EAE8E5")!)
    self.pwTextField.addBorderBottom(size: 1, color: UIColor(named: "EAE8E5")!)
    self.pwConfirmTextField.addBorderBottom(size: 1, color: UIColor(named: "EAE8E5")!)
    self.nickNameTextField.addBorderBottom(size: 1, color: UIColor(named: "EAE8E5")!)
    self.certificationButton.setCornerRadius(radius: 10)
    self.certificationButton.addBorder(width: 1, color: UIColor(named: "28E0AB")!)
    self.nextButton.setCornerRadius(radius: 10)
    
  }
  
  override func initRequest() {
    super.initRequest()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  
  /// 회원가입
  func memberRegInAPI() {
    self.memberRequest.member_id = self.emailTextField.text
    self.memberRequest.member_pw = self.pwTextField.text
    self.memberRequest.member_pw_confirm = self.pwConfirmTextField.text
    self.memberRequest.member_nickname = self.nickNameTextField.text
    
//    self.memberRequest.member_name = "test"
//    self.memberRequest.member_birth = "19900101"
//    self.memberRequest.member_phone = "01011112222"
//    self.memberRequest.member_gender = "2"
    
    APIRouter.shared.api(path: APIURL.member_reg_in, method: .post, parameters: self.memberRequest.toJSON()) { data in
      if let memberResponse = MemberModel(JSON: data), Tools.shared.isSuccessResponse(response: memberResponse) {
        let destination = JoinFinishViewController.instantiate(storyboard: "Login")
        self.navigationController?.pushViewController(destination, animated: true)
      }
    } fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }

  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 본인인증
  /// - Parameter sender: 버튼
  @IBAction func authButtonTouched(sender: UIButton) {
    let destination = AuthViewController.instantiate(storyboard: "Commons")
    destination.delegate = self
    self.navigationController?.pushViewController(destination, animated: true)
  }
  
  
  /// 다음 버튼 터치
  /// - Parameter sender: UIButton
  @IBAction func nextButtonTouched(sender: UIButton) {
    self.memberRegInAPI()
  }

}

//-------------------------------------------------------------------------------------------
// MARK: - AuthProtocol
//-------------------------------------------------------------------------------------------
extension JoinViewController: AuthProtocol {
  func authProtocol(member_name: String, member_phone: String, member_gender: String, member_birth: String, auth_code: String) {
    self.memberRequest.member_name = member_name
    self.memberRequest.member_birth = member_birth
    self.memberRequest.member_phone = member_phone
    self.memberRequest.member_gender = member_gender
  }
}
