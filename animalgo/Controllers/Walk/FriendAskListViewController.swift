//
//  FriendAskListViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/09.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import SkeletonView
import Defaults

class FriendAskListViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var friendAskTableView: UITableView!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  let recordRequest = RecordModel()
  var recordList = [RecordModel]()
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
    
    self.friendAskTableView.registerCell(type: WalkListCell.self)
    self.friendAskTableView.delegate = self
    self.friendAskTableView.dataSource = self
    
    self.friendAskTableView.showAnimatedSkeleton()
    
  }
  
  override func initRequest() {
    super.initRequest()
    self.registeredRecordListAPI()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 산책친구 등록 리스트
  func registeredRecordListAPI() {
    self.recordRequest.member_idx = Defaults[.member_idx]
    self.recordRequest.setNextPage()
    
    APIRouter.shared.api(path: APIURL.registered_record_list, method: .post, parameters: recordRequest.toJSON()) { data in
      if let recordResponse = RecordModel(JSON: data), Tools.shared.isSuccessResponse(response: recordResponse) {
        self.isLoadingList = true
        self.recordRequest.setTotalPage(total_page: recordResponse.total_page ?? 0)
        if let data_array = recordResponse.data_array {
          self.recordList += data_array
        }
        self.friendAskTableView.hideSkeleton()
        self.friendAskTableView.reloadData()
      }
    } fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }
    
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  
}
//-------------------------------------------------------------------------------------------
// MARK: - SkeletonTableViewDataSource
//-------------------------------------------------------------------------------------------
extension FriendAskListViewController: SkeletonTableViewDataSource {
  func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
   return "WalkListCell"
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.recordList.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "WalkListCell", for: indexPath) as! WalkListCell //WalkFriendAskCell
    guard self.recordList.count > 0 else { return cell }
    let recordData = self.recordList[indexPath.row]
    cell.setWalkData(recordData: recordData)
    return cell
  }
  
}
//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDelegate
//-------------------------------------------------------------------------------------------
extension FriendAskListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    log.debug("\(indexPath.section) - \(indexPath.row)")
    
    let destination = FriendAskDetailViewController.instantiate(storyboard: "Walk")
    destination.record_idx = self.recordList[indexPath.row].record_idx ?? ""
    self.navigationController?.pushViewController(destination, animated: true)
    
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView == self.friendAskTableView {
      let currentOffset = scrollView.contentOffset.y
      let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
      
      if maximumOffset - currentOffset <= 10.0 {
        if self.recordRequest.isMore() && self.isLoadingList {
          self.isLoadingList = false
          self.registeredRecordListAPI()
        }
      }
    }
  }
  
  
  
}
