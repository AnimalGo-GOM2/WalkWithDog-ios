//
//  MessageViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/19.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import Defaults

enum MessageType: String {
  case send
  case recieve
}


class MessageViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var nickNameLabel: UILabel!
  @IBOutlet weak var ageLabel: UILabel!
  @IBOutlet weak var genderLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var contentLabel: UILabel!
  @IBOutlet weak var sendButton: UIButton!
  @IBOutlet weak var dotBarButtonItem: UIBarButtonItem!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var msgType = MessageType.send
  var memo_idx = ""
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
    
    self.profileImageView.setCornerRadius(radius: 14)
    self.sendButton.setCornerRadius(radius: 10)
    
    if self.msgType == .send {
      self.title = "보낸 쪽지"
      self.dotBarButtonItem.image = UIImage()
    } else {
      self.title = "받은 쪽지"
      self.dotBarButtonItem.image = UIImage(named: "head_btn_dot")!
    }
    self.view.showAnimatedSkeleton()
  }
  
  override func initRequest() {
    super.initRequest()
    self.memoListAPI()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 메시지 상세 API
  func memoListAPI() {
    let memoRequest = MemberModel()
    memoRequest.memo_idx = self.memo_idx
    memoRequest.member_idx = Defaults[.member_idx]
    
    APIRouter.shared.api(path: .memo_detail, parameters: memoRequest.toJSON()) { response in
      if let memoResponse = MemberModel(JSON: response), Tools.shared.isSuccessResponse(response: memoResponse) {
        self.member_idx = memoResponse.member_idx ?? ""
        self.profileImageView.sd_setImage(with: URL(string: "\(baseURL)\(memoResponse.member_img ?? "")"), placeholderImage: UIImage(named: "default_profile"), options: .lowPriority, context: nil)
        self.nickNameLabel.text = memoResponse.member_nickname ?? ""
        self.ageLabel.text = "\(memoResponse.member_age ?? "")대"
        if memoResponse.member_gender == "0" {
          self.genderLabel.text = "남성"
        } else {
          self.genderLabel.text = "여성"
        }
        self.timeLabel.text = memoResponse.ins_date ?? ""
        self.contentLabel.text = memoResponse.contents ?? ""
        
        self.view.hideSkeleton()
      }
    } fail: { error in
      Tools.shared.showToast(message: "알수 없는 오류가 발생하였습니다.")
    }
  }
  
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 상단 더보기
  /// - Parameter sender: UIBarButtonItem
  @IBAction func dotBarButtonItemTouched(sender: UIBarButtonItem) {
    let destination = CardPopupViewController.instantiate(storyboard: "Walk")
    destination.fromView = "Message"
    destination.delegate = self
    destination.modalTransitionStyle = .crossDissolve
    destination.modalPresentationStyle = .overCurrentContext
    self.present(destination, animated: false, completion: nil)
  }
  /// 쪽지 보내기
  /// - Parameter sender: UIButton
  @IBAction func sendButtonTouched(sender: UIButton) {
    let destination = SendMessageViewController.instantiate(storyboard: "Home")
    destination.member_idx = self.member_idx
    self.navigationController?.pushViewController(destination, animated: true)
  }
}

//-------------------------------------------------------------------------------------------
  // MARK: - SelectedCardPopupDelegate
  //-------------------------------------------------------------------------------------------
extension MessageViewController: SelectedCardPopupDelegate {
  func denyTouched() {
    log.debug("denyTouched")
  }
  
  func cancelTouched() {
    log.debug("cancelTouched")
  }
  
  func reportTouched() {
    log.debug("reportTouched")
    let destination = ReportViewController.instantiate(storyboard: "Walk").coverNavigationController()
    if let firstViewController = destination.viewControllers.first {
      let viewController = firstViewController as! ReportViewController
      viewController.reportType = .Report
      viewController.partner_member_idx = self.member_idx
    }
    destination.modalPresentationStyle = .fullScreen
    self.present(destination, animated: true, completion: nil)
  }
  
  func blockTouched() {
    log.debug("blockTouched")
    let destination = ReportViewController.instantiate(storyboard: "Walk").coverNavigationController()
    if let firstViewController = destination.viewControllers.first {
      let viewController = firstViewController as! ReportViewController
      viewController.reportType = .Block
      viewController.partner_member_idx = self.member_idx
    }
    destination.modalPresentationStyle = .fullScreen
    self.present(destination, animated: true, completion: nil)
  }
  
  
}
