//
//  ReceiveListViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/18.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import SkeletonView
import DZNEmptyDataSet
import Defaults

class ReceiveListViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var readAllButton: UIButton!
  @IBOutlet weak var notReadLabel: UILabel!
  @IBOutlet weak var receiveMsgTableView: UITableView!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------\
  var memoRequest = MemberModel()
  var msgList = [MemberModel]()
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
    self.readAllButton.setCornerRadius(radius: 13.5)
    
    self.receiveMsgTableView.registerCell(type: MessageListCell.self)
    self.receiveMsgTableView.delegate = self
    self.receiveMsgTableView.dataSource = self
    self.receiveMsgTableView.showAnimatedSkeleton()
    
    self.receiveMsgTableView.emptyDataSetSource = self
    
    
  }
  
  override func initRequest() {
    super.initRequest()
    self.memoListAPI()
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.memoRequest.resetPage()
    self.msgList.removeAll()
    self.memoListAPI()
    
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 메시지 리스트 API
  func memoListAPI() {
    self.memoRequest.member_idx = Defaults[.member_idx]
    self.memoRequest.type = "0"
    self.memoRequest.setNextPage()
    
    APIRouter.shared.api(path: .memo_list, parameters: self.memoRequest.toJSON()) { response in
      if let memoResponse = MemberModel(JSON: response), Tools.shared.isSuccessResponse(response: memoResponse) {
        self.notReadLabel.text = "읽지 않은 쪽지 \(memoResponse.unread_cnt ?? 0)"
        if let data_array = memoResponse.data_array, data_array.count > 0 {
          self.msgList = data_array
        }
        self.receiveMsgTableView.hideSkeleton()
        self.receiveMsgTableView.reloadData()
      }
    } fail: { error in
      Tools.shared.showToast(message: "알수 없는 오류가 발생하였습니다.")
    }
  }
  
  /// 모두읽음 API
  func memoReadAllAPI() {
    self.memoRequest.member_idx = Defaults[.member_idx]
    
    APIRouter.shared.api(path: .read_all, parameters: self.memoRequest.toJSON()) { response in
      if let memoResponse = MemberModel(JSON: response), Tools.shared.isSuccessResponse(response: memoResponse) {
        self.isLoadingList = true
        self.memoRequest.total_page = memoResponse.total_page
        for value in self.msgList {
          value.read_yn = "Y"
        }
        self.notReadLabel.text = "읽지 않은 쪽지 0"
        self.receiveMsgTableView.reloadData()
      }
    } fail: { error in
      Tools.shared.showToast(message: "알수 없는 오류가 발생하였습니다.")
    }
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 모두 읽음
    /// - Parameter sender: UIButton
    @IBAction func readAllButtonTouched(sender: UIButton) {
      self.memoReadAllAPI()
    }
}

//-------------------------------------------------------------------------------------------
// MARK: - SkeletonTableViewDataSource
//-------------------------------------------------------------------------------------------
extension ReceiveListViewController: SkeletonTableViewDataSource {
  func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 20
  }
  func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
   return "MessageListCell"
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return self.msgList.count
    
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MessageListCell", for: indexPath) as! MessageListCell
    guard self.msgList.count > 0 else { return cell }
    let msg = self.msgList[indexPath.row]
    cell.setMessageData(msgData: msg)
    return cell
  }
}
//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDelegate
//-------------------------------------------------------------------------------------------
extension ReceiveListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    log.debug("\(indexPath.section) - \(indexPath.row)")
    
    let destination = MessageViewController.instantiate(storyboard: "Home")
    destination.msgType = .recieve
    destination.memo_idx = self.msgList[indexPath.row].memo_idx ?? ""
    self.navigationController?.pushViewController(destination, animated: true)
    
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView == self.receiveMsgTableView {
      let currentOffset = scrollView.contentOffset.y
      let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
      
      if maximumOffset - currentOffset <= 10.0 {
        if self.memoRequest.isMore() && self.isLoadingList {
          self.isLoadingList = false
          self.memoListAPI()
        }
      }
    }
  }
}

//-------------------------------------------------------------------------------------------
  // MARK: - DZNEmptyDataSetSource
  //-------------------------------------------------------------------------------------------
extension ReceiveListViewController: DZNEmptyDataSetSource {

  func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
    return 0
  }
  
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    
    let text = "받은 쪽지가 없습니다."
    let attributes: [NSAttributedString.Key : Any] = [
      NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14),
      NSAttributedString.Key.foregroundColor : UIColor(named: "999999")!
    ]
    
    
    return NSAttributedString(string: text, attributes: attributes)
  }
  
}
