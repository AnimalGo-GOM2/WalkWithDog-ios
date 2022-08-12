//
//  ReceiverListViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/19.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import SkeletonView
import DZNEmptyDataSet
import Defaults

class ReceiverListViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var nickNameTextField: UITextField!
  @IBOutlet weak var textDeleteButton: UIButton!
  @IBOutlet weak var findButton: UIButton!
  @IBOutlet weak var receiverListTableView: UITableView!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var memberRequest = MemberModel()
  var memberList = [MemberModel]()
  var nickname = ""
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
    
    self.receiverListTableView.registerCell(type: ReceiverCell.self)
    self.receiverListTableView.delegate = self
    self.receiverListTableView.dataSource = self
    
    self.receiverListTableView.showAnimatedSkeleton()
    
    self.receiverListTableView.emptyDataSetSource = self
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      self.receiverListTableView.hideSkeleton()
    }
    
    self.nickNameTextField.delegate = self
  }
  
  override func initRequest() {
    super.initRequest()
    self.nickNameTextField.text = self.nickname
    self.memberListAPI()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 회원 리스트 API
    func memberListAPI() {
      self.memberRequest.member_idx = Defaults[.member_idx]
      self.memberRequest.member_nickname = self.nickNameTextField.text
      self.memberRequest.setNextPage()
      

      APIRouter.shared.api(path: .member_list, parameters: self.memberRequest.toJSON()) { response in
        if let memberResponse = MemberModel(JSON: response), Tools.shared.isSuccessResponse(response: memberResponse) {
          self.isLoadingList = true
          self.memberRequest.total_page = memberResponse.total_page
          if let data_array = memberResponse.data_array, data_array.count > 0 {
            self.memberList += data_array
          }
          self.receiverListTableView.hideSkeleton()
          self.receiverListTableView.reloadData()
        }
      } fail: { error in
        Tools.shared.showToast(message: "알수 없는 오류가 발생하였습니다.")
      }
    }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  @IBAction func searchButtonTouched(sender: UIButton) {
    self.memberRequest.resetPage()
    self.memberList.removeAll()
    self.memberListAPI()
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - SkeletonTableViewDataSource
//-------------------------------------------------------------------------------------------
extension ReceiverListViewController: SkeletonTableViewDataSource {
  func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 20
  }
  func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
   return "ReceiverCell"
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return self.memberList.count
    
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell", for: indexPath) as! ReceiverCell
    
    let member = memberList[indexPath.row]
    
    cell.setReceiverData(member: member)
    return cell
  }
}
//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDelegate
//-------------------------------------------------------------------------------------------
extension ReceiverListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    log.debug("\(indexPath.section) - \(indexPath.row)")
    let destination = SendMessageViewController.instantiate(storyboard: "Home")
    destination.member_idx = self.memberList[indexPath.row].partner_member_idx ?? ""
    self.navigationController?.pushViewController(destination, animated: true)
    
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
      if scrollView == self.receiverListTableView {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if maximumOffset - currentOffset <= 10.0 {
          if self.memberRequest.isMore() && self.isLoadingList {
            self.isLoadingList = false
            self.memberListAPI()
          }
        }
      }
    }
}

//-------------------------------------------------------------------------------------------
  // MARK: - DZNEmptyDataSetSource
  //-------------------------------------------------------------------------------------------
extension ReceiverListViewController: DZNEmptyDataSetSource {

  func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
    return -170
  }
  
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    
    let text = ""
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
extension ReceiverListViewController : UITextFieldDelegate {
  func textFieldDidChangeSelection(_ textField: UITextField) {
    
    if textField.text?.count ?? 0 > 0 {
      self.textDeleteButton.isHidden = false
    } else {
      self.textDeleteButton.isHidden = true
    }
  }
  
}
