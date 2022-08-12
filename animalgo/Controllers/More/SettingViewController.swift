//
//  SettingViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/03.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import Defaults

class SettingViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var friendChatAlarmSwitch: UISwitch!
  @IBOutlet weak var guideMessageAlarmSwitch: UISwitch!
  @IBOutlet weak var marketingInfoAgreementSwitch: UISwitch!
  @IBOutlet weak var alertSetView: UIView!
  @IBOutlet weak var unregisterButton: UIButton!
  @IBOutlet weak var logoutView: UIView!
  @IBOutlet weak var versionLabel: UILabel!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var memberAlarmData = MemberModel()
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    self.friendChatAlarmSwitch.transform = CGAffineTransform(scaleX: 0.95, y:0.95)
    self.guideMessageAlarmSwitch.transform = CGAffineTransform(scaleX: 0.95, y:0.95)
    self.marketingInfoAgreementSwitch.transform = CGAffineTransform(scaleX: 0.95, y:0.95)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
      self.versionLabel.text = version
      
    }
    
  }
  
  override func initRequest() {
    super.initRequest()
    self.alarmToggleViewAPI()
    
    // 알림 설정
    self.alertSetView.addTapGesture { recognizer in
      guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
        return
      }
      
      if UIApplication.shared.canOpenURL(settingsUrl) {
        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
          print("Settings opened: \(success)") // Prints true
        })
      }
    }
    
    
    // 로그아웃
    self.logoutView.addTapGesture { recognizer in
      AJAlertController.initialization().showAlert(astrTitle: "", aStrMessage: "로그아웃 하시겠습니까?", aCancelBtnTitle: "취소", aOtherBtnTitle: "확인") { position, title in
        if position == 1 {
          self.logoutAPI()
        }
      }
    }
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 로그아웃
  func logoutAPI() {
    let memberParam = MemberModel()
    memberParam.member_idx = Defaults[.member_idx]

    APIRouter.shared.api(path: APIURL.member_logout, method: .post, parameters: memberParam.toJSON()) { response in
      if let memberResponse = MemberModel(JSON: response), Tools.shared.isSuccessResponse(response: memberResponse) {
        Defaults.removeAll()
        Defaults[.tutorial] = true
        let destination = LoginViewController.instantiate(storyboard: "Login").coverNavigationController()
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        window?.rootViewController = destination
      }
    } fail: { error in
      AJAlertController.initialization().showAlertWithOkButton(astrTitle: "", aStrMessage: "\(error?.localizedDescription ?? "")", alertViewHiddenCheck: false) { position, title in
        
      }
    }

  }
  
  /// 알람설정 보기 API
  func alarmToggleViewAPI() {
    let memberRequest = MemberModel()
    memberRequest.member_idx = Defaults[.member_idx]
    
    APIRouter.shared.api(path: .alarm_toggle_view, parameters: memberRequest.toJSON()) { response in
      if let memberResponse = MemberModel(JSON: response), Tools.shared.isSuccessResponse(response: memberResponse) {
        self.memberAlarmData = memberResponse
        self.switchOnOff(selSwitch: self.friendChatAlarmSwitch, isOn: memberResponse.chatting_alarm_yn ?? "")
        self.switchOnOff(selSwitch: self.guideMessageAlarmSwitch, isOn: memberResponse.guide_alarm_yn ?? "")
        self.switchOnOff(selSwitch: self.marketingInfoAgreementSwitch, isOn: memberResponse.marketing_agree_yn ?? "")
        
        Defaults[.guide_alarm_yn] = memberResponse.guide_alarm_yn
      }
    } fail: { error in
      Tools.shared.showToast(message: "알수 없는 오류가 발생하였습니다.")
    }
  }
  
  /// on off 세팅
  func switchOnOff(selSwitch: UISwitch, isOn: String) {
    if isOn == "Y" {
      selSwitch.isOn = true
    } else {
      selSwitch.isOn = false
    }
  }
  
  /// 알림 설정 API
  func alarmToggleAPI(type: String, value: String) {
    let memberRequest = MemberModel()
    memberRequest.member_idx = Defaults[.member_idx]
    memberRequest.type = type
    memberRequest.value = value
    
    APIRouter.shared.api(path: .alarm_toggle, parameters: memberRequest.toJSON()) { response in
      if let memberResponse = MemberModel(JSON: response), Tools.shared.isSuccessResponse(response: memberResponse) {
        if memberRequest.type == "1" {
          if self.guideMessageAlarmSwitch.isOn {
            Defaults[.guide_alarm_yn] = "Y"
          } else {
            Defaults[.guide_alarm_yn] = "N"
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
  
  /// 회원탈퇴
  /// - Parameter sender: UIButton
  @IBAction func unregisterButtonTouched(sender: UIButton) {
    let destination = UnregisterPopupViewController.instantiate(storyboard: "More")
    destination.modalPresentationStyle = .overCurrentContext
    destination.modalTransitionStyle = .crossDissolve
    self.present(destination, animated: true, completion:  nil)
  }
  
  @IBAction func alarmSwitchToggled(sender: UISwitch) {
    var type = ""
    var value = ""
    if sender == self.friendChatAlarmSwitch {
      type = "0"
    } else if sender == self.guideMessageAlarmSwitch {
      type = "1"
    } else {
      type = "2"
    }
    if sender.isOn {
      value = "Y"
    } else {
      value = "N"
    }
    self.alarmToggleAPI(type: type, value: value)
  }
}
