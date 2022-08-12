//
//  AlarmViewController.swift
//  animalgo
//
//  Created by rocateer on 2020/03/03.
//  Copyright © 2020 rocateer. All rights reserved.
//

import UIKit
import Defaults

class AlarmViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var alarmTableView: UITableView!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var alarmRequest = AlarmModel()
  var alarmList = [AlarmModel]()
  
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.alarmTableView.delegate = self
    self.alarmTableView.dataSource = self
    self.alarmTableView.tableFooterView = UIView(frame: CGRect.zero)
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
  /// 알림 리스트
  func alarmListAPI() {
    self.alarmRequest.setNextPage()
    self.alarmRequest.member_idx = Defaults[.member_idx]
    
    APIRouter.shared.api(path: .alarm_list, parameters: self.alarmRequest.toJSON()) { response in
      if let alarmResponse = AlarmModel(JSON: response), Tools.shared.isSuccessResponse(response: alarmResponse) {
        if let data_array = alarmResponse.data_array {
          self.isLoadingList = true
          self.alarmRequest.setTotalPage(total_page: alarmResponse.total_page ?? 0)
          self.alarmList += data_array
          self.alarmTableView.reloadData()
        }
      }
    } fail: { error in
      Tools.shared.showToast(message: "알수 없는 오류가 발생하였습니다.")
    }
  }
  
  
  /// 알림 삭제
  /// - Parameter alarm_idx: 알림 인덱스
  func alarmDel(alarm_idx: String) {
    let alarmRequest = AlarmModel()
    alarmRequest.alarm_idx = alarm_idx
    
    APIRouter.shared.api(path: .alarm_del, parameters: alarmRequest.toJSON()) { response in
      if let alarmResponse = AlarmModel(JSON: response), Tools.shared.isSuccessResponse(response: alarmResponse) {
        self.alarmRequest.resetPage()
        self.alarmList.removeAll()
        self.alarmListAPI()
      }
    } fail: { error in
      Tools.shared.showToast(message: "알수 없는 오류가 발생하였습니다.")
    }
  }
  
  /// 알림 삭제
  func alarmAllDelAPI() {
    let alarmParam = AlarmModel()
    alarmParam.member_idx = Defaults[.member_idx]
    
    APIRouter.shared.api(path: .alarm_all_del, parameters: alarmParam.toJSON()) { response in
      if let alarmResponse = AlarmModel(JSON: response), Tools.shared.isSuccessResponse(response: alarmResponse) {
        self.alarmRequest.resetPage()
        self.alarmList.removeAll()
        self.alarmListAPI()
      }
    } fail: { error in
      Tools.shared.showToast(message: "알수 없는 오류가 발생하였습니다.")
    }
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 전체삭제
  /// - Parameter sender: 바 버튼
  @IBAction func allDeleteBarButtonTouched(sender: UIBarButtonItem) {
    self.alarmAllDelAPI()
  }
  
}

//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDelegate
//-------------------------------------------------------------------------------------------
extension AlarmViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let alarmData = self.alarmList[indexPath.row]
    
  }
  
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let contextItem = UIContextualAction(style: .normal, title: "") {  (contextualAction, view, boolValue) in
      self.alarmDel(alarm_idx: self.alarmList[indexPath.row].alarm_idx ?? "")
    }
//    contextItem.image = UIImage(named: "btn_delete")
    contextItem.backgroundColor = UIColor(named: "DDDDDD")
    
    let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
    
    return swipeActions
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
// MARK: - UITableViewDataSource
//-------------------------------------------------------------------------------------------
extension AlarmViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.alarmList.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as! AlarmCell
    let alarmData = self.alarmList[indexPath.row]
    cell.contentsLabel.text = alarmData.msg ?? ""
    cell.dateLabel.text = alarmData.ins_date ?? ""
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
}
