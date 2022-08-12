//
//  BlockViewController.swift
//  animalgo
//
//  Created by rocateer on 2022/03/22.
//  Copyright © 2022 rocateer. All rights reserved.
//


import UIKit
import SkeletonView
import DZNEmptyDataSet
import Defaults

class BlockViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var blockTableView: UITableView!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var memberList = [MemberModel]()
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.blockTableView.registerCell(type: BlockListCell.self)
    self.blockTableView.delegate = self
    self.blockTableView.dataSource = self
    self.blockTableView.emptyDataSetSource = self
    
    self.blockTableView.showAnimatedSkeleton()
 
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
  }
  
  override func initRequest() {
    super.initRequest()
    self.blockListAPI()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 차단 리스트 API
  func blockListAPI() {
    
    let memberRequest = MemberModel()
    memberRequest.member_idx = Defaults[.member_idx]
    
//    APIRouter.shared.api(path: APIURL.block_list, method: .post, parameters: memberRequest.toJSON()) { response in
//      if let memberResponse = MemberModel(JSON: response), Tools.shared.isSuccessResponse(response: memberResponse) {
//        self.isLoadingList = true
//        if let data_array = memberResponse.data_array, data_array.count > 0 {
//          self.memberList = data_array
//        }
//        self.blockTableView.hideSkeleton()
//        self.blockTableView.reloadData()
//      }
//    }fail: { error in
//      Tools.shared.showToast(message: error?.localizedDescription ?? "")
//    }
    
    APIRouter.shared.api(path: APIURL.block_list, method: .post, parameters: memberRequest.toJSON()) { response in
      if let memberResponse = MemberModel(JSON: response) {
        if memberResponse.code == "1000" {
          self.isLoadingList = true
          if let data_array = memberResponse.data_array, data_array.count > 0 {
            self.memberList = data_array
          }
        } else if memberResponse.code == "-2" {
          self.memberList.removeAll()
        }
        self.blockTableView.hideSkeleton()
        self.blockTableView.reloadData()
      }
    }fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }
    
  }
  
  /// 차단하기
  func blockRegInAPI(partner_member_idx: String) {
    let memberRequest = MemberModel()
    memberRequest.member_idx = Defaults[.member_idx]
    memberRequest.partner_member_idx = partner_member_idx
    memberRequest.block_type = "0"
    memberRequest.block_contents = "내용 없음"

    APIRouter.shared.api(path: APIURL.block_reg_in, method: .post, parameters: memberRequest.toJSON()) { data in
      if let data_array = MemberModel(JSON: data), Tools.shared.isSuccessResponse(response: data_array) {
        self.blockListAPI()
        NotificationCenter.default.post(name: Notification.Name("RecordTogetherListUpdate"), object: nil)
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
extension BlockViewController: SkeletonTableViewDataSource {
  func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 20
  }
  func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
   return "BlockListCell"
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.memberList.count
    
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "BlockListCell", for: indexPath) as! BlockListCell
    let memberData = self.memberList[indexPath.row]
    cell.setBlockData(member: memberData)
    
    // 차단 해제
    cell.blockButton.addTapGesture { recognizer in
      AJAlertController.initialization().showAlert(astrTitle: "", aStrMessage: "차단을 해제하시겠습니까?", aCancelBtnTitle: "취소", aOtherBtnTitle: "확인") { position, title in
        if position == 1 {
          self.blockRegInAPI(partner_member_idx: memberData.member_idx ?? "")
        }
      }
    }
    return cell
  }
}
//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDelegate
//-------------------------------------------------------------------------------------------
extension BlockViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

  }

}


//-------------------------------------------------------------------------------------------
  // MARK: - DZNEmptyDataSetSource
  //-------------------------------------------------------------------------------------------
extension BlockViewController: DZNEmptyDataSetSource {

  func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
    return -150
  }
  
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    
    let text = "차단한 친구가 없습니다."
    let attributes: [NSAttributedString.Key : Any] = [
      NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14),
      NSAttributedString.Key.foregroundColor : UIColor(named: "999999")!
    ]
    
    
    return NSAttributedString(string: text, attributes: attributes)
  }
  
}
