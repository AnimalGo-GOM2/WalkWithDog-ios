//
//  UnregisterPopupViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/03.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import Defaults

class UnregisterPopupViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var unregisterPopupView: UIView!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var unregisterButton: UIButton!
  @IBOutlet weak var reasonTextView: UITextView!
  @IBOutlet weak var reasonLabel: UILabel!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------

  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.reasonTextView.delegate = self
    self.reasonTextView.textContainerInset = UIEdgeInsets(top: 16 , left: 0, bottom: 10, right: 0)
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    
    
    self.unregisterPopupView.setCornerRadius(radius: 20)
    self.cancelButton.setCornerRadius(radius: 10)
    self.unregisterButton.setCornerRadius(radius: 10)
    self.reasonTextView.addBorderBottom(size: 1, color: UIColor(named: "EAE8E5")!)
  }
  
  override func initRequest() {
    super.initRequest()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 회원탈퇴 API
  func memberOutAPI() {
    let memberRequest = MemberModel()
    memberRequest.member_idx = Defaults[.member_idx]
    memberRequest.member_leave_reason = self.reasonTextView.text
    
    APIRouter.shared.api(path: .member_out_up, parameters: memberRequest.toJSON()) { response in
      if let memberResponse = MemberModel(JSON: response), Tools.shared.isSuccessResponse(response: memberResponse) {
        AJAlertController.initialization().showAlertWithOkButton(astrTitle: "", aStrMessage: memberResponse.code_msg ?? "", alertViewHiddenCheck: false){
          (position, title) in
          if position == 0 {
            Defaults.removeAll()
            Defaults[.tutorial] = true
            let destination = LoginViewController.instantiate(storyboard: "Login").coverNavigationController()
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            window?.rootViewController = destination
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
    self.memberOutAPI()
    
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UITextViewDelegate
//-------------------------------------------------------------------------------------------
extension UnregisterPopupViewController: UITextViewDelegate{
  
  func textViewDidChange(_ textView: UITextView) {
    if textView.text?.count ?? 0 > 0{
      self.reasonLabel.isHidden = true
    }else{
      self.reasonLabel.isHidden = false
    }
  }
  
}
