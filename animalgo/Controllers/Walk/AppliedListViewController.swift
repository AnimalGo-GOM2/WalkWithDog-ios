//
//  AppliedListViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/10.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import SkeletonView
import Defaults

enum AppliedState {
  case myApplied // 내가 지원한 산책친구
  case friendApplied // 내 산책에 지원한 산책친구
}

class AppliedListViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var appliedListTableView: UITableView!
  @IBOutlet weak var moreBarButtonItem: UIBarButtonItem!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  let recordRequest = RecordModel()
  var recordList = [RecordModel]()
  var appliedState = AppliedState.myApplied
  var record_idx = ""
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.appliedListTableView.registerCell(type: WalkFriendCell.self)
    self.appliedListTableView.delegate = self
    self.appliedListTableView.dataSource = self
    self.appliedListTableView.showAnimatedSkeleton()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    if self.appliedState == .myApplied { // 내산책에 지원한 산책친구
      self.navigationItem.title = "지원한 산책친구들"
      self.moreBarButtonItem.isEnabled = true
      self.moreBarButtonItem.tintColor = .black
    } else { // 지원한 산책친구
      self.navigationItem.title = "지원한 산책친구"
      self.moreBarButtonItem.isEnabled = false
      self.moreBarButtonItem.tintColor = .clear
    }
  }
  
  override func initRequest() {
    super.initRequest()
    if self.appliedState == .myApplied { // 내산책에 지원한 산책친구
      self.recordApplyMemberListAPI()
    } else {
      self.recordApplyListAPI()
    }
    
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 산책친구 지원 리스트
  func recordApplyListAPI() {
    self.recordRequest.member_idx = Defaults[.member_idx]
    self.recordRequest.type = "1"
    self.recordRequest.setNextPage()
    
    APIRouter.shared.api(path: APIURL.record_apply_list, method: .post, parameters: self.recordRequest.toJSON()) { data in
      if let recordResponse = RecordModel(JSON: data), Tools.shared.isSuccessResponse(response: recordResponse) {
        self.recordRequest.setTotalPage(total_page: recordResponse.total_page ?? 0)
        if let data_array = recordResponse.data_array {
          self.recordList += data_array
        }
        self.appliedListTableView.hideSkeleton()
        self.appliedListTableView.reloadData()
      }
    } fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }
    
  }
  
  /// 지원한 산책친구들
  func recordApplyMemberListAPI() {
    self.recordRequest.record_idx = self.record_idx
    self.recordRequest.setNextPage()
    
    APIRouter.shared.api(path: APIURL.record_apply_member_list, method: .post, parameters: self.recordRequest.toJSON()) { data in
      if let recordResponse = RecordModel(JSON: data), Tools.shared.isSuccessResponse(response: recordResponse) {
        self.recordRequest.setTotalPage(total_page: recordResponse.total_page ?? 0)
        if let data_array = recordResponse.data_array {
          self.recordList += data_array
        }
        self.appliedListTableView.hideSkeleton()
        self.appliedListTableView.reloadData()
      }
    } fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }
    
  }
  
  
  /// 산책 친구 등록 취소
  func registeredRecordCancelAPI() {
    let recordRequest = RecordModel()
    recordRequest.record_idx = self.record_idx
    
    APIRouter.shared.api(path: APIURL.registered_record_cancel, method: .post, parameters: recordRequest.toJSON()) { response in
      if let recordResponse = RecordModel(JSON: response), Tools.shared.isSuccessResponse(response: recordResponse) {
        NotificationCenter.default.post(name: Notification.Name("RegisteredRecordListUpdate"), object: nil)
        self.dismiss(animated: true, completion: nil)
      }
    } fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 상단 더보기 버튼
  /// - Parameter sender: UIBarButtonItem
  @IBAction func moreBarButtonItemTouched(sender: UIBarButtonItem) {
    
    let destination = CardPopupViewController.instantiate(storyboard: "Walk")
    destination.fromView = "registedFriendAsk"
    destination.delegate = self
    destination.modalTransitionStyle = .crossDissolve
    destination.modalPresentationStyle = .overCurrentContext
    self.present(destination, animated: false, completion: nil)
  }
}


//-------------------------------------------------------------------------------------------
// MARK: - SkeletonTableViewDataSource
//-------------------------------------------------------------------------------------------
extension AppliedListViewController: SkeletonTableViewDataSource {
  func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
    return "WalkFriendCell"
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.recordList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "WalkFriendCell", for: indexPath) as! WalkFriendCell
    guard self.recordList.count > 0 else { return cell }
    
    let recordData = self.recordList[indexPath.row]
    cell.setRecordData(recordData: recordData)
    
    if indexPath.row == self.recordList.count - 1 {
      cell.underView.isHidden = true
    }
//    cell.isNewImageView.isHidden = false
    return cell
  }
  
}
//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDelegate
//-------------------------------------------------------------------------------------------
extension AppliedListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if self.appliedState == .myApplied { // 내산책에 지원한 산책친구
      let destination = ChatViewController.instantiate(storyboard: "Walk")
      destination.chatting_room_idx = self.recordList[indexPath.row].chatting_room_idx ?? ""
      self.navigationController?.pushViewController(destination, animated: true)
    } else { // 지원한 산책친구
      let destination = FriendAskDetailViewController.instantiate(storyboard: "Walk")
      destination.record_idx = self.recordList[indexPath.row].record_idx ?? ""
      self.navigationController?.pushViewController(destination, animated: true)
    }
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView == self.appliedListTableView {
      let currentOffset = scrollView.contentOffset.y
      let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
      
      if maximumOffset - currentOffset <= 10.0 {
        if self.recordRequest.isMore() && self.isLoadingList {
          self.isLoadingList = false
          if self.appliedState == .myApplied { // 내산책에 지원한 산책친구
            self.recordApplyMemberListAPI()
          } else {
            self.recordApplyListAPI()
          }
        }
      }
    }
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - SelectedCardPopupDelegate
//-------------------------------------------------------------------------------------------
extension AppliedListViewController: SelectedCardPopupDelegate {
  func cancelTouched() { // 산책 취소
      self.registeredRecordCancelAPI()
    }
  
  func denyTouched() {
    
  }
  
  func reportTouched() {
    
  }
  
  func blockTouched() {
    
  }
  
  
}
