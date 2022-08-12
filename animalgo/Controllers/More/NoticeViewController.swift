//
//  NoticeViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/03.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import ExpyTableView
import DZNEmptyDataSet
import StringStylizer

class NoticeViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var noticeTableView: ExpyTableView!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var notices = [NoticeModel]()
  var noticeRequest = NoticeModel()
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.noticeTableView.registerCell(type: NoticeCell.self)
    self.noticeTableView.registerCell(type: NoticeDetailCell.self)
    self.noticeTableView.delegate = self
    self.noticeTableView.dataSource = self
    self.noticeTableView.emptyDataSetSource = self
    
    self.noticeTableView.rowHeight = UITableView.automaticDimension
    self.noticeTableView.expandingAnimation = .fade
    self.noticeTableView.collapsingAnimation = .fade
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
  }
  
  override func initRequest() {
    super.initRequest()
    self.noticeListAPI()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 공지사항 리스트 API
  func noticeListAPI() {
    self.noticeRequest.setNextPage()
    
    APIRouter.shared.api(path: .notice_list, parameters: noticeRequest.toJSON()) { response in
      if let noticeResponse = NoticeModel(JSON: response), Tools.shared.isSuccessResponse(response: noticeResponse) {
        self.noticeRequest.total_page = noticeResponse.total_page
        if let data_array = noticeResponse.data_array, data_array.count > 0 {
          self.notices += data_array
        }
        self.noticeTableView.reloadData()
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
extension NoticeViewController: ExpyTableViewDataSource {
  func tableView(_ tableView: ExpyTableView, canExpandSection section: Int) -> Bool {
    return true
  }
  
  func tableView(_ tableView: ExpyTableView, expandableCellForSection section: Int) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeCell") as! NoticeCell
    cell.setNoticeData(noticeData: self.notices[section])
    cell.layoutMargins = UIEdgeInsets.zero
    return cell
  }
  
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return self.notices.count
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
    cell.contentsLabel.text = self.notices[indexPath.section].contents
    if self.notices[indexPath.section].img_path.isNil {
      cell.imageHeightConstraint.constant = 0
    } else {
      if let image:UIImage = UIImage(urlString: "\(baseURL)\(self.notices[indexPath.section].img_path ?? "")") {
        cell.noticeImageView.sd_setImage(with: URL(string: "\(baseURL)\(self.notices[indexPath.section].img_path ?? "")"), placeholderImage: UIImage(), options: .lowPriority, context: nil)
        cell.imageHeightConstraint.constant = (image.size.height * self.view.frame.size.width) / image.size.width
      } else {
        cell.imageHeightConstraint.constant = 0
      }
      
    }
    
//    let height = self.view.frame.width * ( UIImage(named: "sample")!.size.height / UIImage(named: "sample")!.size.width )
//    cell.imageHeightConstraint.constant = height
    
    return cell
  }
  
  
}


//-------------------------------------------------------------------------------------------
// MARK: - ExpyTableViewDelegate
//-------------------------------------------------------------------------------------------
extension NoticeViewController: ExpyTableViewDelegate {
  
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

  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if scrollView == self.noticeTableView {
      let currentOffset = scrollView.contentOffset.y
      let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
      
      if maximumOffset - currentOffset <= 10.0 {
        if self.noticeRequest.isMore() {
          self.isLoadingList = false
          self.noticeListAPI()
        }
      }
    }
  }
  
}



//-------------------------------------------------------------------------------------------
// MARK: - DZNEmptyDataSetSource
//-------------------------------------------------------------------------------------------
extension NoticeViewController: DZNEmptyDataSetSource {
  func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
    return -150
  }
  
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    let title = "\n등록된 공지사항이 없습니다.".stylize().font(UIFont.systemFont(ofSize: 16)).color(UIColor(named: "999999")!).attr
    return title
  }
  
  
}
