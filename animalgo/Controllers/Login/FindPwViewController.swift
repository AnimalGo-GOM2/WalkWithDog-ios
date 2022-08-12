//
//  FindPwViewController.swift
//  animalgo
//
//  Created by rocateer on 2020/01/03.
//  Copyright © 2020 rocateer. All rights reserved.
//

import UIKit

class FindPwViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var idTextField: UITextField!
  @IBOutlet weak var okButton: UIButton!
  @IBOutlet weak var beforeFindView: UIView!
  @IBOutlet weak var afterFindView: UIView!
  @IBOutlet weak var goLoginButton: UIButton!
  
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
   
    self.okButton.setCornerRadius(radius: 10)
    self.goLoginButton.setCornerRadius(radius: 10)
    self.idTextField.addBorderBottom(size: 1, color: UIColor(named: "EAE8E5")!)
  }
  
  override func initRequest() {
    super.initRequest()
  }

  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// Pw 찾기
  func findPwAPI() {
    let memberRequest = MemberModel()
    memberRequest.member_id = self.idTextField.text
    
    APIRouter.shared.api(path: .member_pw_reset_send_email, parameters: memberRequest.toJSON()) { response in
      self.view.endEditing(true)
      if let memberResponse = MemberModel(JSON: response) {
        if memberResponse.code == "1000" {
          self.beforeFindView.isHidden = true
          self.afterFindView.isHidden = false
        } else if memberResponse.code == "-2" {
          self.beforeFindView.isHidden = false
          self.afterFindView.isHidden = true
          Tools.shared.showToast(message: memberResponse.code_msg ?? "")
        } else {
          Tools.shared.showToast(message: memberResponse.code_msg ?? "")
        }
      }
    } fail: { error in
      Tools.shared.showToast(message: "알수 없는 오류가 발생하였습니다.")
    }

  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 비밀번호 확인
  /// - Parameter sender: 버튼
  @IBAction func okButtonTouched(sender: UIButton) {
    self.findPwAPI()
  }
  
  /// 로그인 화면으로 이동
  /// - Parameter sender: 버튼
  @IBAction func goLoginButtonTouched(sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
  
}


