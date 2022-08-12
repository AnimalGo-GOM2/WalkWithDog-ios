//
//  LoginViewController.swift
//  animalgo
//
//  Created by rocateer on 19/09/2019.
//  Copyright © 2019 rocateer. All rights reserved.
//
import UIKit
import Defaults


class LoginViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var findIdButton: UIButton!
  @IBOutlet weak var findPwButton: UIButton!
  @IBOutlet weak var joinButton: UIButton!
  @IBOutlet weak var passwordView: UIView!
  @IBOutlet weak var emailView: UIView!


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
    self.loginButton.setCornerRadius(radius: 10)
    
    self.emailView.addBorderBottom(size: 1, color: UIColor(named: "EAE8E5")!)
    self.passwordView.addBorderBottom(size: 1, color: UIColor(named: "EAE8E5")!)
    self.emailTextField.addLeftTextPadding(20)
    self.passwordTextField.addLeftTextPadding(20)
  
  }
  
  override func initRequest() {
    super.initRequest()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 회원 로그인 API
  private func memberLoginAPI() {
    let memberReqeust = MemberModel()
    memberReqeust.member_id = self.emailTextField.text
    memberReqeust.member_pw = self.passwordTextField.text
    memberReqeust.device_os = "I"
    memberReqeust.gcm_key = self.appDelegate.fcmKey ?? "TEST"

    APIRouter.shared.api(path: .member_login, parameters: memberReqeust.toJSON()) { response in
      if let memberResponse = MemberModel(JSON: response), Tools.shared.isSuccessResponse(response: memberResponse) {
        Defaults[.member_idx] = memberResponse.member_idx
        Defaults[.member_id] = self.emailTextField.text
        Defaults[.member_pw] = self.passwordTextField.text
        Defaults[.member_nickname] = memberResponse.member_nickname
        Defaults[.guide_alarm_yn] = memberResponse.guide_alarm_yn
        
        let destination = MainTabBarViewController.instantiate(storyboard: "Main")
        destination.hero.isEnabled = true
        destination.hero.modalAnimationType = .zoom
        destination.modalPresentationStyle = .fullScreen
        self.present(destination, animated: true, completion: nil)
        
        
      }
    } fail: { error in
      Tools.shared.showToast(message: "알수 없는 오류가 발생하였습니다.")
    }
  }
  
 
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 로그인 버튼 터치시
  ///
  /// - Parameter sender: 버튼
  @IBAction func loginButtonTouched(sender: UIButton) {
    self.memberLoginAPI()
  }
  
  /// 아이디 찾기 버튼 터치시
  ///
  /// - Parameter sender: 버튼
  @IBAction func findIdButtonTouched(sender: UIButton) {
    let destination = FindIdViewController.instantiate(storyboard: "Login").coverNavigationController()
    destination.hero.isEnabled = true
    destination.hero.modalAnimationType = .autoReverse(presenting: .cover(direction: .left))
    destination.modalPresentationStyle = .fullScreen
    self.present(destination, animated: true, completion: nil)
  }
  
  /// 비밀번호 찾기 버튼 터치시
  ///
  /// - Parameter sender: 버튼
  @IBAction func findPwButtonTouched(sender: UIButton) {
    let destination = FindPwViewController.instantiate(storyboard: "Login").coverNavigationController()
    destination.hero.isEnabled = true
    destination.hero.modalAnimationType = .autoReverse(presenting: .cover(direction: .left))
    destination.modalPresentationStyle = .fullScreen
    self.present(destination, animated: true, completion: nil)
  }
  
  /// 회원가입 버튼 터치시
  ///
  /// - Parameter sender: 버튼
  @IBAction func joinButtonTouched(sender: UIButton) {
    let destination = AgreementViewController.instantiate(storyboard: "Login").coverNavigationController()
    destination.hero.isEnabled = true
    destination.hero.modalAnimationType = .autoReverse(presenting: .cover(direction: .left))
    destination.modalPresentationStyle = .fullScreen
    self.present(destination, animated: true, completion: nil)
  }
  
  
}

