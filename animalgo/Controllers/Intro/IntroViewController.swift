//
//  IntroViewController.swift
//  animalgo
//
//  Created by rocateer on 2020/01/09.
//  Copyright © 2020 rocateer. All rights reserved.
//

import UIKit
import Defaults

class IntroViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  
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
    self.perform(#selector(self.delay), with: nil, afterDelay: 2)
  }
  
  override func initRequest() {
    super.initRequest()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  @objc func delay() {
    if !(Defaults[.tutorial] ?? false) {
      let destination = TutorialViewController.instantiate(storyboard: "Intro")
      destination.modalPresentationStyle = .fullScreen
      self.present(destination, animated: true, completion: nil)
      return
    }
    
    if Defaults[.member_idx] != nil && Defaults[.member_join_type] != "K" {
      let memberRequest = MemberModel()
      memberRequest.member_id = Defaults[.member_id]
      memberRequest.member_pw = Defaults[.member_pw]
      memberRequest.gcm_key = self.appDelegate.fcmKey ?? ""
      memberRequest.device_os = "I"

      APIRouter.shared.api(path: .member_login, parameters: memberRequest.toJSON()) { response in
        if let memberResponse = MemberModel(JSON: response) {
          if memberResponse.code == "1000" {

            Defaults[.member_idx] = memberResponse.member_idx ?? ""
            Defaults[.member_nickname] = memberResponse.member_nickname
            Defaults[.guide_alarm_yn] = memberResponse.guide_alarm_yn
            self.goToMain()

          } else {
            self.gotoLogin()
          }
        }
      } fail: { error in
        Tools.shared.showToast(message: "알수 없는 오류가 발생하였습니다.")
      }
    } else {
      self.gotoLogin()
    }

  }
  
  
  
  /// 로그인 화면으로
  func gotoLogin() {
    let destination = LoginViewController.instantiate(storyboard: "Login")
    destination.hero.isEnabled = true
    destination.hero.modalAnimationType = .zoom
    destination.modalPresentationStyle = .fullScreen
    self.present(destination, animated: true, completion: nil)
  }
  
  // 메인 화면으로
  func goToMain() {
    let destination = MainTabBarViewController.instantiate(storyboard: "Main")
    destination.hero.isEnabled = true
    destination.hero.modalAnimationType = .zoom
    destination.modalPresentationStyle = .fullScreen
    self.present(destination, animated: true, completion: nil)
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  
}


