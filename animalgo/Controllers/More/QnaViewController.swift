//
//  QnaViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/03.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import SkeletonView
import DZNEmptyDataSet
import Defaults

class QnaViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var qnaTableView: UITableView!
  @IBOutlet weak var qnaBarButtonItem: UIBarButtonItem!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var qnaList = [QnaModel]()
  var qnaRequest = QnaModel()
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(self.qnaUpdate), name: Notification.Name("qnaUpdate"), object: nil)
    
    self.qnaTableView.registerCell(type: QnaCell.self)
    self.qnaTableView.delegate = self
    self.qnaTableView.dataSource = self
    self.qnaTableView.emptyDataSetSource = self
    
    self.qnaBarButtonItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor(named: "accent")!], for: .normal)
    self.qnaBarButtonItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor(named: "accent")!], for: .selected)
    
    self.qnaTableView.showAnimatedSkeleton()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
  }
  
  override func initRequest() {
    super.initRequest()
    self.qnaListAPI()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// Qna 리스트 API
  func qnaListAPI() {
    
    self.qnaRequest.member_idx = Defaults[.member_idx]
    self.qnaRequest.setNextPage()
    APIRouter.shared.api(path: APIURL.qa_list, method: .post, parameters: self.qnaRequest.toJSON()) { response in
      if let qnaResponse = QnaModel(JSON: response), Tools.shared.isSuccessResponse(response: qnaResponse) {
        self.qnaRequest.total_page = qnaResponse.total_page
        self.isLoadingList = true
        if let data_array = qnaResponse.data_array, data_array.count > 0 {
          self.qnaList = data_array
        }
        self.qnaTableView.hideSkeleton()
        self.qnaTableView.reloadData()
      }
    }fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }
    
  }
  
  /// QnA업데이트
  /// - Parameter notificaiton: notificaiton
  @objc func qnaUpdate(notification: Notification) {
    self.qnaList.removeAll()
    self.qnaRequest.resetPage()
    self.qnaListAPI()
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  
  /// 문의
  /// - Parameter sender: UIBarButtonItem
  @IBAction func registBarButtonItemTouched(sender: UIBarButtonItem) {
    let vc = QnaRegistViewController.instantiate(storyboard: "More")
    let destination = vc.coverNavigationController()
    destination.modalPresentationStyle = .fullScreen
    self.present(destination, animated: true)
  }
}



//-------------------------------------------------------------------------------------------
// MARK: - SkeletonTableViewDataSource
//-------------------------------------------------------------------------------------------
extension QnaViewController: SkeletonTableViewDataSource {
  func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 20
  }
  func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
   return "QnaCell"
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.qnaList.count
    
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "QnaCell", for: indexPath) as! QnaCell
    let qna = self.qnaList[indexPath.row]
    
    let category = QNA_CATEGORY_LIST[Int(qna.qa_category ?? "") ?? 0]
    
    cell.titleLabel.text = "[\(category)] \(qna.qa_title ?? "")"
    cell.dateLabel.text = qna.ins_date ?? ""
    
    if qna.reply_yn == "Y" {
      cell.replyImageView.image = UIImage(named: "i_mark2")!
    } else {
      cell.replyImageView.image = UIImage(named: "i_mark1")!
    }
    
    return cell
  }
}
//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDelegate
//-------------------------------------------------------------------------------------------
extension QnaViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let destination = QnaDetailViewController.instantiate(storyboard: "More")
    destination.qnaData = self.qnaList[indexPath.row]
    self.navigationController?.pushViewController(destination, animated: true)
    
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView == self.qnaTableView {
      let currentOffset = scrollView.contentOffset.y
      let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
      
      if maximumOffset - currentOffset <= 10.0 {
        if self.qnaRequest.isMore() && self.isLoadingList {
          self.isLoadingList = false
          self.qnaListAPI()
        }
      }
    }
  }
}




//-------------------------------------------------------------------------------------------
  // MARK: - DZNEmptyDataSetSource
  //-------------------------------------------------------------------------------------------
extension QnaViewController: DZNEmptyDataSetSource {

  func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
    return -150
  }
  
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    
    let text = "등록된 1:1문의가 없습니다."
    let attributes: [NSAttributedString.Key : Any] = [
      NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14),
      NSAttributedString.Key.foregroundColor : UIColor(named: "999999")!
    ]
    
    
    return NSAttributedString(string: text, attributes: attributes)
  }
  
}
