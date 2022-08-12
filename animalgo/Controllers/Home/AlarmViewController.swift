//
//  AlarmViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/02.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import SkeletonView
import DZNEmptyDataSet
import Defaults
import ExpyTableView


class AlarmViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var alarmTableView: ExpyTableView!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
    var alarmList = [AlarmModel]()
    var alarmRequest = AlarmModel()
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.alarmTableView.registerCell(type: NoticeCell.self)
    self.alarmTableView.registerCell(type: NoticeDetailCell.self)
    self.alarmTableView.dataSource = self
    self.alarmTableView.delegate = self
    self.alarmTableView.rowHeight = UITableView.automaticDimension
    self.alarmTableView.expandingAnimation = .fade
    self.alarmTableView.collapsingAnimation = .fade

  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
  }
  
  override func initRequest() {
    super.initRequest()
    self.alarmListAPI()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 알림리스트API
  func alarmListAPI() {
    self.alarmRequest.member_idx = Defaults[.member_idx]
    self.alarmRequest.setNextPage()
    APIRouter.shared.api(path: .alarm_list, parameters: self.alarmRequest.toJSON()) { [self] response in
      if let alarmResponse = AlarmModel(JSON: response), Tools.shared.isSuccessResponse(response: alarmResponse) {
        self.isLoadingList = true
        self.alarmRequest.total_page = alarmResponse.total_page
        if let data_array = alarmResponse.data_array, data_array.count > 0 {
          self.alarmList += data_array
        }
        self.alarmTableView.emptyDataSetSource = self
        self.alarmTableView.hideSkeleton()
        self.alarmTableView.reloadData()
      }
    } fail: { error in
      Tools.shared.showToast(message: "알수 없는 오류가 발생하였습니다.")
    }
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  
}
//-------------------------------------------------------------------------------------------
// MARK: - ExpyTableViewDataSource
//-------------------------------------------------------------------------------------------
extension AlarmViewController: ExpyTableViewDataSource {
  func tableView(_ tableView: ExpyTableView, canExpandSection section: Int) -> Bool {
    return true
  }
  
  func tableView(_ tableView: ExpyTableView, expandableCellForSection section: Int) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeCell") as! NoticeCell
    let alarm = self.alarmList[section]
    
    cell.titleLabel.text = alarm.data?.title ?? ""
    cell.dateLabel.text = alarm.ins_date
    
    cell.layoutMargins = UIEdgeInsets.zero
    return cell
  }
  
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return self.alarmList.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  
  func canExpand(section: Int, inTableView tableView: ExpyTableView) -> Bool {
    return true
  }
  
  // 상위 데이터
  func expandableCell(forSection section: Int, inTableView tableView: ExpyTableView) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeCell") as! NoticeCell
    return cell
  }
  
  // 하위 데이터
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeDetailCell", for: indexPath) as! NoticeDetailCell
    let alarm = self.alarmList[indexPath.section]
    
    cell.contentsLabel.text = alarm.data?.msg ?? ""
    cell.imageHeightConstraint.constant = 0
    
    return cell
  }
  
  
}

//-------------------------------------------------------------------------------------------
// MARK: - ExpyTableViewDelegate
//-------------------------------------------------------------------------------------------
extension AlarmViewController: ExpyTableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: ExpyTableView, expyState state: ExpyState, changeForSection section: Int) {
    
    switch state {
    case .willExpand:
      
      break
    case .willCollapse:
      break
    case .didExpand:
      break
    case .didCollapse:
      break
    }
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
      if scrollView == self.alarmTableView {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if maximumOffset - currentOffset <= 10.0 {
          if self.alarmRequest.isMore() && self.isLoadingList {
            self.isLoadingList = false
            self.alarmListAPI()
          }
        }
      }
    }
  
}

//-------------------------------------------------------------------------------------------
  // MARK: - DZNEmptyDataSetSource
  //-------------------------------------------------------------------------------------------
extension AlarmViewController: DZNEmptyDataSetSource {

  func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
    return -150
  }

  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {

    let text = "받은 알림이 없습니다."
    let attributes: [NSAttributedString.Key : Any] = [
      NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14),
      NSAttributedString.Key.foregroundColor : UIColor(named: "999999")!
    ]


    return NSAttributedString(string: text, attributes: attributes)
  }

}
