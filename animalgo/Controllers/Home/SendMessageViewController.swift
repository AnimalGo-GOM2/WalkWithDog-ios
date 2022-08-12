//
//  SendMessageViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/19.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import Defaults
import SkeletonView

class SendMessageViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var nickNameLabel: UILabel!
  @IBOutlet weak var ageLabel: UILabel!
  @IBOutlet weak var genderLabel: UILabel!
  @IBOutlet weak var contentLabel: UILabel!
  @IBOutlet weak var sendButton: UIButton!
  @IBOutlet weak var contentTextView: UITextView!
  @IBOutlet weak var textCountLabel: UILabel!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var member_idx = ""
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
    self.sendButton.setCornerRadius(radius: 10)
    self.contentTextView.delegate = self
    self.profileImageView.setCornerRadius(radius: 14)
    self.view.showAnimatedSkeleton()
  }
  
  override func initRequest() {
    super.initRequest()
    self.memoRegViewAPI()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  ///메시지 보내기 폼 API
  func memoRegViewAPI() {
    let memberRequest = MemberModel()
    memberRequest.partner_member_idx = self.member_idx
    APIRouter.shared.api(path: .memo_reg_view, parameters: memberRequest.toJSON()) { response in
      if let memberResponse = MemberModel(JSON: response), Tools.shared.isSuccessResponse(response: memberResponse) {
        self.profileImageView.sd_setImage(with: URL(string: "\(baseURL)\(memberResponse.member_img ?? "")"), placeholderImage: UIImage(named: "default_profile"), options: .lowPriority, context: nil)
        self.nickNameLabel.text = memberResponse.member_nickname
        self.ageLabel.text = "\(memberResponse.member_age ?? "")대"
        self.genderLabel.text = memberResponse.member_gender == "0" ? "남성" : "여성"
        self.view.hideSkeleton()
      }
    } fail: { error in
      Tools.shared.showToast(message: "알수 없는 오류가 발생하였습니다.")
    }
  }
  
  ///메시지 보내기 API
  func memoSendAPI() {
    let memberRequest = MemberModel()
    memberRequest.member_idx = Defaults[.member_idx]
    memberRequest.partner_member_idx = self.member_idx
    memberRequest.contents = self.contentTextView.text
    
    APIRouter.shared.api(path: .memo_reg_in, parameters: memberRequest.toJSON()) { response in
      if let memberResponse = MemberModel(JSON: response), Tools.shared.isSuccessResponse(response: memberResponse) {
        NotificationCenter.default.post(name: Notification.Name("SendMessage"), object: nil)
        self.navigationController?.popToRootViewController(animated: true)
      }
    } fail: { error in
      Tools.shared.showToast(message: "알수 없는 오류가 발생하였습니다.")
    }
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 보내기
  /// - Parameter sender: 버튼
  @IBAction func sendButtonTouched(sender: UIButton) {
    self.memoSendAPI()
    
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UITextViewDelegate
//-------------------------------------------------------------------------------------------
extension SendMessageViewController: UITextViewDelegate {
  
  func textViewDidChange(_ textView: UITextView) {
    self.textCountLabel.text = textView.text?.count.toString
    
    if textView.text?.count ?? 0 > 0 {
      self.contentLabel.isHidden = true
    } else {
      self.contentLabel.isHidden = false
    }
    
  }
  
  // 글자수 제한
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    let currentCharacterCount = textView.text?.count ?? 0
    if (range.length + range.location > currentCharacterCount){
      return false
    }
    let newLength = currentCharacterCount + text.count - range.length
    return newLength <= 300
  }
}
