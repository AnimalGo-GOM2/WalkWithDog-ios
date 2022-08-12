//
//  FindMessageViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/18.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import SkeletonView
import DZNEmptyDataSet
import Defaults

enum MsgType: String {
  case send
  case recieve
}

class FindMessageViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var findTextField: UITextField!
  @IBOutlet weak var findButton: UIButton!
  @IBOutlet weak var deleteTextButton: UIButton!
  @IBOutlet weak var resultTableView: UITableView!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var msgType = MsgType.send
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
    
    self.resultTableView.registerCell(type: MessageListCell.self)
    self.resultTableView.delegate = self
    self.resultTableView.dataSource = self
    self.resultTableView.emptyDataSetSource = self
    
    self.findTextField.delegate = self
    
    switch self.msgType {
    case .send:
      self.title = "보낸 쪽지 검색"
      self.memoRequest.type = "1"
    case .recieve:
      self.title = "받은 쪽지 검색"
      self.memoRequest.type = "0"
    }
  }
  
  override func initRequest() {
    super.initRequest()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 메시지 리스트 API
  func memoListAPI() {
    self.memoRequest.member_idx = Defaults[.member_idx]
    
    self.memoRequest.search = self.findTextField.text
    self.memoRequest.setNextPage()
    
    APIRouter.shared.api(path: .memo_list, parameters: self.memoRequest.toJSON()) { response in
      if let memoResponse = MemberModel(JSON: response), Tools.shared.isSuccessResponse(response: memoResponse) {
        self.isLoadingList = true
        if let data_array = memoResponse.data_array, data_array.count > 0 {
          self.msgList += data_array
        }
        self.resultTableView.hideSkeleton()
        self.resultTableView.reloadData()
      }
    } fail: { error in
      Tools.shared.showToast(message: "알수 없는 오류가 발생하였습니다.")
    }
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 검색
  /// - Parameter sender: UIButton
  @IBAction func findButtonTouched(sender: UIButton) {
    self.resultTableView.showAnimatedSkeleton()
    self.memoRequest.resetPage()
    self.msgList.removeAll()
    self.memoListAPI()
  }
  
  @IBAction func deleteTextButtonTouched(sender: UIButton) {
    self.memoRequest.resetPage()
    self.msgList.removeAll()
    self.findTextField.text = ""
    self.deleteTextButton.isHidden = true
    self.memoListAPI()
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - SkeletonTableViewDataSource
//-------------------------------------------------------------------------------------------
extension FindMessageViewController: SkeletonTableViewDataSource {
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
    
    let msg = msgList[indexPath.row]
    cell.setMessageData(msgData: msg)
    
    return cell
  }
}
//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDelegate
//-------------------------------------------------------------------------------------------
extension FindMessageViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    log.debug("\(indexPath.section) - \(indexPath.row)")
    
//    let destination = NoticeDetailViewController.instantiate(storyboard: "More")
////    destination.noticeResponse = self.noticeList[indexPath.row]
//    self.navigationController?.pushViewController(destination, animated: true)
    
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView == self.resultTableView {
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
extension FindMessageViewController: DZNEmptyDataSetSource {

  func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
    return -170
  }
  
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    
    let text = "검색결과가 없습니다."
    let attributes: [NSAttributedString.Key : Any] = [
      NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14),
      NSAttributedString.Key.foregroundColor : UIColor(named: "999999")!
    ]
    
    
    return NSAttributedString(string: text, attributes: attributes)
  }
  
}
//-------------------------------------------------------------------------------------------
// MARK: - UITextFieldDelegate
//-------------------------------------------------------------------------------------------
extension FindMessageViewController : UITextFieldDelegate {
  func textFieldDidChangeSelection(_ textField: UITextField) {
    
    if textField.text?.count ?? 0 > 0 {
      self.deleteTextButton.isHidden = false
    } else {
      self.deleteTextButton.isHidden = true
    }
  }
  
}
