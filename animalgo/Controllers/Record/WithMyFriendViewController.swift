//
//  WithMyFriendViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/17.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import SkeletonView
import DZNEmptyDataSet
import Defaults

class WithMyFriendViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var walkListTableView: UITableView!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var recordRequest = RecordModel()
  var recordList = [RecordModel]()
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(self.recordListUpdate), name: Notification.Name("RecordListUpdate"), object: nil)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    self.walkListTableView.registerCell(type: RecordListCell.self)
    self.walkListTableView.dataSource = self
    self.walkListTableView.delegate  = self
    
    self.walkListTableView.showAnimatedSkeleton()

  }
  
  override func initRequest() {
    super.initRequest()
    self.recordDiaryListAPI()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  
  /// 산책 기록 리스트
  func recordDiaryListAPI() {
    self.recordRequest.member_idx = Defaults[.member_idx]
    self.recordRequest.record_type = "1"
    self.recordRequest.setNextPage()
    
    APIRouter.shared.api(path: APIURL.record_diary_list, method: .post, parameters: self.recordRequest.toJSON()) { response in
      if let recordResponse = RecordModel(JSON: response), Tools.shared.isSuccessResponse(response: recordResponse) {
        self.isLoadingList = true
        self.recordRequest.setTotalPage(total_page: recordResponse.total_page ?? 0)
        if let data_array = recordResponse.data_array {
          self.recordList += data_array
        }
        self.walkListTableView.hideSkeleton()
        self.walkListTableView.emptyDataSetSource = self
        self.walkListTableView.reloadData()
      }
    } fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }
    
  }
  
  @objc func recordListUpdate() {
    self.recordList.removeAll()
    self.recordRequest.resetPage()
    self.recordDiaryListAPI()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  
}

//-------------------------------------------------------------------------------------------
// MARK: - SkeletonTableViewDataSource
//-------------------------------------------------------------------------------------------
extension WithMyFriendViewController: SkeletonTableViewDataSource {
  func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 20
  }
  func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
  
   return "RecordListCell"
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.recordList.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "RecordListCell", for: indexPath) as! RecordListCell
    guard self.recordList.count > 0 else { return cell }
    let recordData = self.recordList[indexPath.row]
    cell.friendView.isHidden = false
    cell.setRecordData(recordData: recordData)
    
    cell.friendNickNameLabel.text = recordData.member_nickname
    cell.friendAgeLabel.text = "\(recordData.member_age ?? "")대"
    cell.friendGenderLabel.text = recordData.member_gender == "0" ? "남성" : "여성"
    if let partner_animal_cnt = recordData.partner_animal_cnt, partner_animal_cnt > 1 {
      cell.friendPetNameLabel.text = "\(recordData.partner_animal_array?[0].animal_name ?? "") 외 \(partner_animal_cnt - 1)마리"
    } else {
      cell.friendPetNameLabel.text = "\(recordData.partner_animal_array?[0].animal_name ?? "")"
    }
    if let partner_animal_array = recordData.partner_animal_array, partner_animal_array.count > 0 {
      cell.friendPetBreedLabel.text = partner_animal_array[0].category_name
      cell.friendPetGenderLabel.text = partner_animal_array[0].animal_gender == "0" ? "남아" : "여아"
      cell.friendPetAgeLabel.text = partner_animal_array[0].animal_year
      cell.friendImageView.sd_setImage(with: URL(string: Tools.shared.thumbnailImageUrl(url: recordData.member_img ?? "")), completed: nil)
      cell.friendImageView.sd_setImage(with: URL(string:  Tools.shared.thumbnailImageUrl(url: recordData.member_img ?? "")), placeholderImage: UIImage(named: "default_profile")!, options: .lowPriority, completed: nil)
      cell.friendPetImageView.sd_setImage(with: URL(string:  Tools.shared.thumbnailImageUrl(url: partner_animal_array[0].animal_img_path ?? "")), placeholderImage: UIImage(named: "default_dog4")!, options: .lowPriority, completed: nil)
    }
    
    return cell
  }
}
//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDelegate
//-------------------------------------------------------------------------------------------
extension WithMyFriendViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let destination = WithFriendDetailViewController.instantiate(storyboard: "Record").coverNavigationController()
    if let firstViewController = destination.viewControllers.first {
      let viewController = firstViewController as! WithFriendDetailViewController
      viewController.record_diary_idx = self.recordList[indexPath.row].record_diary_idx ?? ""
      viewController.record_type = "1"
    }
    destination.hero.isEnabled = true
    destination.hero.modalAnimationType = .autoReverse(presenting: .cover(direction: .left))
    destination.modalPresentationStyle = .fullScreen
    self.present(destination, animated: true, completion: nil)
    
  }
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView == self.walkListTableView {
      let currentOffset = scrollView.contentOffset.y
      let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
      
      if maximumOffset - currentOffset <= 10.0 {
        if self.recordRequest.isMore() && self.isLoadingList {
          self.isLoadingList = false
          self.recordDiaryListAPI()
        }
      }
    }
  }
}

//-------------------------------------------------------------------------------------------
  // MARK: - DZNEmptyDataSetSource
  //-------------------------------------------------------------------------------------------
extension WithMyFriendViewController: DZNEmptyDataSetSource {

  func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
    return -200
  }
  
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    
    let text = "산책기록이 없습니다."
    let attributes: [NSAttributedString.Key : Any] = [
      NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .regular),
      NSAttributedString.Key.foregroundColor : UIColor(named: "999999")!
    ]
    
    
    return NSAttributedString(string: text, attributes: attributes)
  }
  
}
