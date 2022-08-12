//
//  ChatViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/10.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Defaults
import RSKGrowingTextView
import SkeletonView

class ChatViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var nickNameLabel: UILabel!
  @IBOutlet weak var ageLabel: UILabel!
  @IBOutlet weak var genderLabel: UILabel!
  @IBOutlet weak var walkDateLabel: UILabel!
  @IBOutlet weak var startWalkButton: UIButton!
  @IBOutlet weak var chatTableView: UITableView!
  @IBOutlet weak var messageTextView: RSKGrowingTextView!
  @IBOutlet weak var messageWrapView: UIView!
  @IBOutlet weak var sendButton: UIButton!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
//  var state = ""
  
  var chatRequest = ChatModel()
  var chatResponse = ChatModel()
  var chatList = [ChatModel]()
  
  let notificiationCenter = NotificationCenter.default
  
  let refreshControl = UIRefreshControl()
  var selected_member_idx = ""
  var chatting_room_idx = ""
  var partner_member_idx = ""
  
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.profileImageView.setCornerRadius(radius: 14)
    
    UNUserNotificationCenter.current().getDeliveredNotifications { (notifications: [UNNotification]) in
      for notification in notifications {
        let responseUserInfo = notification.request.content.userInfo
        
        if let data = responseUserInfo["data"] {
          let data = (data as? String ?? "").data(using: .utf8) ?? Data()
          
          do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any> {
              log.debug(jsonArray)
              
              if let chattingRoomIdx = jsonArray["chatting_room_idx"] {
                if (self.chatting_room_idx == chattingRoomIdx as? String ?? "") {
                  UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [notification.request.identifier])
                }
              }
              
            } else {
              print("bad json")
            }
          } catch let error as NSError {
            print(error)
          }
        }
      }
    }
    self.chatTableView.registerCell(type: ChatReceiveCell.self)
    self.chatTableView.registerCell(type: ChatSendCell.self)
    self.chatTableView.registerCell(type: ChatEndCell.self)
    self.chatTableView.delegate = self
    self.chatTableView.dataSource = self
    self.chatTableView.addSubview(self.refreshControl)
    self.refreshControl.addTarget(self, action: #selector(self.loadMoreMessages), for: .valueChanged)
    self.chatTableView.shouldIgnoreScrollingAdjustment = true
    self.view.showAnimatedSkeleton()
    
    self.notificiationCenter.addObserver(self, selector: #selector(self.chattingDetailUpdate), name: Notification.Name("ChattingDetailUpdate"), object: nil)
//    self.notificiationCenter.addObserver(self, selector: #selector(self.chattingListUpdate), name: Notification.Name("ChattingListUpdate"), object: nil)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    self.messageWrapView.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.messageWrapView.setCornerRadius(radius: 19)
  }
  
  override func initRequest() {
    super.initRequest()
    self.chattingRoomDetailAPI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    IQKeyboardManager.shared.enableAutoToolbar = false
  }
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    IQKeyboardManager.shared.enableAutoToolbar = true
    NotificationCenter.default.removeObserver(self)
  }
  deinit {
    IQKeyboardManager.shared.enableAutoToolbar = true
    NotificationCenter.default.removeObserver(self)
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  
  /// 채팅방 상세
  func chattingRoomDetailAPI() {
    let chatRequest = ChatModel()
    chatRequest.chatting_room_idx = self.chatting_room_idx
    chatRequest.member_idx = Defaults[.member_idx]
    
    APIRouter.shared.api(path: APIURL.chatting_room_detail, method: .post, parameters: chatRequest.toJSON()) { data in
      if let chatResponse = ChatModel(JSON: data), Tools.shared.isSuccessResponse(response: chatResponse) {
        self.chatResponse = chatResponse
        self.profileImageView.sd_setImage(with: URL(string: Tools.shared.thumbnailImageUrl(url: chatResponse.member_img ?? "")), placeholderImage: UIImage(named: "default_profile"), options: .lowPriority, context: nil)
        self.nickNameLabel.text = chatResponse.member_nickname
        self.ageLabel.text = "\(chatResponse.member_age ?? "")대"
        self.genderLabel.text = chatResponse.member_gender == "0" ? "남성" : "여성"
        self.walkDateLabel.text = chatResponse.record_date
        self.chattingListAPI()
        self.view.hideSkeleton()
        
        // state : 산책 지원 상태 (0:지원중,1:수락,2:거절,3:지원취소,4:산책취소됨)
        if Defaults[.member_idx] == chatResponse.record_owner_idx { // 산책 등록자
          
          if chatResponse.state == "0" {
            self.startWalkButton.setTitle(" 수락", for: .normal)
          } else {
            self.startWalkButton.setTitle(" 산책시작", for: .normal)
          }
        } else { // 산책 지원자
          if chatResponse.state == "1" {
            self.startWalkButton.isEnabled = true
          } else {
            self.startWalkButton.isEnabled = false
          }
        }
        
        
        if chatResponse.block_yn == "Y"  { // 등록자가 지원자 차단
          // -> 지원자는 산책시작 버튼 비활성화
          // -> 지원자는 메세지 발송 불가
          self.startWalkButton.isEnabled = false
          self.sendButton.isEnabled = false
        } else if chatResponse.state == "2" { // 등록자가 지원 거부
          // -> 지원자는 메세지 발송 불가
          self.startWalkButton.isEnabled = false
          self.sendButton.isEnabled = false
        } else if chatResponse.state == "3" { // 지원자가 지원취소
          // -> 등록자는 메세지 발송 불가
          self.startWalkButton.isEnabled = false
          self.sendButton.isEnabled = false
        } else if chatResponse.state == "4" { // 등록자가 산책 취소
          // -> 대화방 종료
          self.closeViewController()
        }
      }
    } fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }

  }
  
  
  /// 채팅 리스트
  func chattingListAPI() {
    self.chatRequest.setNextPage()
    self.chatRequest.chatting_room_idx = self.chatting_room_idx
    self.chatRequest.member_idx = Defaults[.member_idx]

    APIRouter.shared.api(path: APIURL.chatting_list, method: .post, parameters: self.chatRequest.toJSON()) { response in
      if let chatResponse = ChatModel(JSON: response), Tools.shared.isSuccessResponse(response: chatResponse) {
        self.chatRequest.setTotalPage(total_page: chatResponse.total_page ?? 0)
        self.isLoadingList = true
        self.refreshControl.endRefreshing()

        if let data_array = chatResponse.data_array, data_array.count > 0 {

          for value in data_array {
            let index = data_array.firstIndex(where: { $0 === value}) ?? 0
            self.chatList.insert(value, at: index)
          }
          
          // 채팅 종료 여부
          if self.chatResponse.chatting_close_yn == "Y" {
            let chatModel = ChatModel()
            chatModel.chatting_close_yn = self.chatResponse.chatting_close_yn
            self.chatList[self.chatList.count - 1].day_list_array?.append(chatModel)
          }

          if chatResponse.page_num == 1 {
            self.chatTableView.isHidden = true
            self.chatTableView.reloadData()
            self.chatTableView.scrollToBottom()
          } else {
            let newIndexPath = IndexPath(row: 0, section: chatResponse.data_array?.count ?? 0)
            self.chatTableView.reloadDataAndKeepOffset(newIndexPath: newIndexPath)
          }
        }

      }
    } fail: { error in
      AJAlertController.initialization().showAlertWithOkButton(astrTitle: "", aStrMessage: "\(error?.localizedDescription ?? "")", alertViewHiddenCheck: false) { position, title in

      }
    }
  }
  
  /// 채팅등록
  func chatRegInAPI() {
    let chatParam = ChatModel()
    chatParam.member_idx = Defaults[.member_idx]
    chatParam.chatting_room_idx = self.chatting_room_idx
    chatParam.comment = self.messageTextView.text
    chatParam.member_nickname = Defaults[.member_nickname]

    APIRouter.shared.api(path: APIURL.chatting_reg_in, method: .post, parameters: chatParam.toJSON()) { response in
      if let chatResponse = ChatModel(JSON: response), Tools.shared.isSuccessResponse(response: chatResponse) {
        self.messageTextView.text = ""
        self.chatRequest.resetPage()
        self.chatList.removeAll()
        self.chattingListAPI()
        self.view.endEditing(true)
      }
    } fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }

  }
  
  // 지원 취소
  func recordApplyCancelAPI() {
    let recordRequest = RecordModel()
    recordRequest.record_idx = self.chatResponse.record_idx
    recordRequest.member_idx = Defaults[.member_idx]
    
    APIRouter.shared.api(path: APIURL.record_apply_cancel, method: .post, parameters: recordRequest.toJSON()) { data in
      if let recordResponse = RecordModel(JSON: data), Tools.shared.isSuccessResponse(response: recordResponse) {
        NotificationCenter.default.post(name: Notification.Name("RecordApplyListUpdate"), object: nil)
        self.dismiss(animated: true, completion: nil)
      }
    } fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }
  }
  
  // 지원 거부
  func recordApplyRefuseAPI() {
    let recordRequest = RecordModel()
    recordRequest.record_participant_idx = self.chatResponse.record_participant_idx
    recordRequest.member_idx = Defaults[.member_idx]
    
    APIRouter.shared.api(path: APIURL.record_apply_refuse, method: .post, parameters: recordRequest.toJSON()) { data in
      if let recordResponse = RecordModel(JSON: data), Tools.shared.isSuccessResponse(response: recordResponse) {
        NotificationCenter.default.post(name: Notification.Name("RecordApplyListUpdate"), object: nil)
        self.dismiss(animated: true, completion: nil)
      }
    } fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }
  }
  
  // 산책 수락
  func recordStartAPI() {
    let recordRequest = RecordModel()
    recordRequest.record_idx = self.chatResponse.record_idx
    recordRequest.partner_member_idx = self.chatResponse.member_idx
    recordRequest.member_nickname = Defaults[.member_nickname]
    
    APIRouter.shared.api(path: APIURL.record_start, method: .post, parameters: recordRequest.toJSON()) { data in
      if let recordResponse = RecordModel(JSON: data), Tools.shared.isSuccessResponse(response: recordResponse) {
        self.chatRequest.resetPage()
        self.chatList.removeAll()
        self.chattingRoomDetailAPI()
      }
    } fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }
  }
  
  /// 회원 채팅 업데이트
  @objc func chattingDetailUpdate() {
    self.chatRequest.resetPage()
    self.chatList.removeAll()
    self.chatTableView.reloadData()
//    self.chattingListAPI()
    self.chattingRoomDetailAPI()
  }
  
  // 페이징
  @objc func loadMoreMessages() {
    DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
      self.chattingListAPI()
    }
  }
//  /// 회원 채팅 업데이트
//  @objc func chattingListUpdate() {
//    self.chatRequest.resetPage()
//    self.chatList.removeAll()
//    self.chatTableView.reloadData()
//    self.chattingListAPI()
//  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 산책시작
  /// - Parameter sender: UIButton
  @IBAction func startWalkButtonTouched(sender:UIButton) {
    if Defaults[.member_idx] == self.chatResponse.record_owner_idx && self.chatResponse.state == "0" { // 산책 등록자 수락
      self.recordStartAPI()
    } else { // 산책 지원자
      let vc = FriendWalkGuideViewController.instantiate(storyboard: "Walk")
      vc.record_idx = self.chatResponse.record_idx ?? ""
      let destination = vc.coverNavigationController()
      destination.hero.isEnabled = false
      destination.hero.modalAnimationType = .autoReverse(presenting: .cover(direction: .left))
      destination.modalPresentationStyle = .fullScreen
      self.present(destination, animated: true, completion: nil)
    }
  }
  
  /// 지원취소 , 신고, 차단
  @IBAction func dotBarButtonItemTouched(sender: UIBarButtonItem) {
    let destination = CardPopupViewController.instantiate(storyboard: "Walk")
    // 내가 지원자이면 "appliedChat", 내가 등록자이면 "registedFriendAsk"
    if self.chatResponse.record_owner_idx == Defaults[.member_idx] {
      destination.fromView = "registedChat"
    } else {
      destination.fromView = "appliedChat"
    }
    destination.delegate = self
    destination.modalTransitionStyle = .crossDissolve
    destination.modalPresentationStyle = .overCurrentContext
    self.present(destination, animated: false, completion: nil)
    
  }
  
  /// 전송
  /// - Parameter sender: 버튼
  @IBAction func sendTouched(sender: UIButton) {
    self.chatRegInAPI()
  }

}


//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDelegate
//-------------------------------------------------------------------------------------------
extension ChatViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView == self.chatTableView {
      let sectionHeaderHeight: CGFloat = 32
      if scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y > 0 {
        scrollView.contentInset = UIEdgeInsets(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0)
      } else if scrollView.contentOffset.y >= sectionHeaderHeight {
        scrollView.contentInset = UIEdgeInsets(top: -sectionHeaderHeight, left: 0, bottom: 0, right: 0)
      }
      
      let currentOffset = scrollView.contentOffset.y
      log.debug("currentOffset  \(currentOffset)")
      let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
      log.debug("maximumOffset  \(maximumOffset)")
      
      if currentOffset < 0.0 {
        if self.chatRequest.isMore() && self.isLoadingList {
          self.isLoadingList = false
          self.chattingListAPI()
        }
      }
    }
  }
  
}

//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDataSource
//-------------------------------------------------------------------------------------------
extension ChatViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return self.chatList.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let day_list_array = self.chatList[section].day_list_array {
      return day_list_array.count
    } else {
      return 0
    }
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let chatReceiveCell = tableView.dequeueReusableCell(withIdentifier: "ChatReceiveCell", for: indexPath) as! ChatReceiveCell
    let chatSendCell = tableView.dequeueReusableCell(withIdentifier: "ChatSendCell", for: indexPath) as! ChatSendCell
    let chatEndCell = tableView.dequeueReusableCell(withIdentifier: "ChatEndCell", for: indexPath) as! ChatEndCell
    
    let chatData = self.chatList[indexPath.section].day_list_array?[indexPath.row] ?? ChatModel()
    
    if chatData.chatting_close_yn == "Y" {
      return chatEndCell
    }
    
    if chatData.member_idx == Defaults[.member_idx] {
      chatSendCell.timeLabel.text = chatData.ins_hi ?? ""

      if chatData.comment == nil {
        chatSendCell.chatContentWrapView.isHidden = true
        chatSendCell.chatContentLabel.text = nil
      } else {
        chatSendCell.chatContentWrapView.isHidden = false
        chatSendCell.chatContentLabel.text = chatData.comment ?? ""
      }


      return chatSendCell
    } else {
      if chatData.comment == nil {
        chatReceiveCell.chatContentWrapView.isHidden = true
        chatReceiveCell.chatContentLabel.text = nil
      } else {
        chatReceiveCell.chatContentWrapView.isHidden = false
        chatReceiveCell.chatContentLabel.text = chatData.comment ?? ""
      }

      return chatReceiveCell
    }
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 32
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = ChatHeaderView(frame: CGRect(x: 0, y: 0, w: self.view.frame.size.width, h: 32))
    
    let headerData = self.chatList[section]
    let dateFormmater = DateFormatter()
    dateFormmater.dateFormat = "yyyy-MM-dd"
    let date = dateFormmater.date(from: headerData.st_date ?? "")
    headerView.dayLabel.text = date?.toString(format: "yyyy년MM월dd일 EEEE")

    return headerView
  }
  
}


//-------------------------------------------------------------------------------------------
  // MARK: - SelectedCardPopupDelegate
  //-------------------------------------------------------------------------------------------
extension ChatViewController: SelectedCardPopupDelegate {
  func cancelTouched() {
    log.debug("cancelTouched")
    self.recordApplyCancelAPI()
  }
  
  func denyTouched() {
    log.debug("denyTouched")
    self.recordApplyRefuseAPI()
  }
  
  func reportTouched() {
      log.debug("reportTouched")
      let destination = ReportViewController.instantiate(storyboard: "Walk").coverNavigationController()
      if let firstViewController = destination.viewControllers.first {
        let viewController = firstViewController as! ReportViewController
        viewController.reportType = .Report
        viewController.partner_member_idx = self.chatResponse.member_idx ?? ""
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
        viewController.partner_member_idx = self.chatResponse.member_idx ?? ""
      }
      destination.modalPresentationStyle = .fullScreen
      self.present(destination, animated: true, completion: nil)
    }
  
  
}
