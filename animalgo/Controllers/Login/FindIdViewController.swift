//
//  FindIdViewController.swift
//  animalgo
//
//  Created by rocateer on 2020/01/03.
//  Copyright © 2020 rocateer. All rights reserved.
//

import UIKit

class FindIdViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var phoneTextField: UITextField!
  @IBOutlet weak var confirmButton: UIButton!
  @IBOutlet weak var beforeFindView: UIView!
  @IBOutlet weak var afterFindView: UIView!
  @IBOutlet weak var resultIdLabel: UILabel!
  @IBOutlet weak var registedDateLabel: UILabel!
  @IBOutlet weak var findPwButton: UIButton!
  @IBOutlet weak var loginButton: UIButton!
  
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
    
    self.confirmButton.setCornerRadius(radius: 10)
    self.nameTextField.addBorderBottom(size: 1, color: UIColor(named: "EAE8E5")!)
    self.phoneTextField.addBorderBottom(size: 1, color: UIColor(named: "EAE8E5")!)
    self.findPwButton.setCornerRadius(radius: 10)
    self.loginButton.setCornerRadius(radius: 10)
    self.findPwButton.addBorder(width: 1, color: UIColor(named: "28E0AB")!)
    
    
  }
  
  override func initRequest() {
    super.initRequest()
  }
  
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// ID 찾기
  func findIdAPI() {
    let memberRequest = MemberModel()
    memberRequest.member_name = self.nameTextField.text
    memberRequest.member_phone = self.phoneTextField.text
  
    APIRouter.shared.api(path: .member_id_find, parameters: memberRequest.toJSON()) { response in
      self.view.endEditing(true)
      if let memberResponse = MemberModel(JSON: response) {
        if memberResponse.code == "1000" {
          self.beforeFindView.isHidden = true
          self.afterFindView.isHidden = false
          
          self.resultIdLabel.text = memberResponse.member_id ?? ""
          self.registedDateLabel.text = memberResponse.ins_date ?? ""
        } else if memberResponse.code == "-2" {
          self.beforeFindView.isHidden = false
          self.afterFindView.isHidden = true
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
  /// 아이디 찾기 확인 버튼 처리시
  ///
  /// - Parameter sender: 버튼
  @IBAction func okButtonTouched(sender: UIButton) {
    self.findIdAPI()
  }
  /// 비밀번호 찾기 버튼
  ///
  /// - Parameter sender: 버튼
  @IBAction func findPwButtonTouched(sender: UIButton) {
    let destination = FindPwViewController.instantiate(storyboard: "Login")
    self.navigationController?.pushViewController(destination, animated: true)
  }
  /// 로그인 버튼
  ///
  /// - Parameter sender: 버튼
  @IBAction func loginButtonTouched(sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
}
