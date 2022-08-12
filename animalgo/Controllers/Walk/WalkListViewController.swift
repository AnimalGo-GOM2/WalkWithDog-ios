//
//  WalkListViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/05.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import SkeletonView
import Defaults

class WalkListViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var registedFriendTableView: UITableView!
  @IBOutlet weak var appliedFriendTableView: UITableView!
  @IBOutlet weak var topButtonsView: UIView!
  @IBOutlet weak var withMyPetButton: UIButton!
  @IBOutlet weak var withFriendButton: UIButton!
  @IBOutlet weak var registedHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var appliedHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var registedAskView: UIView!
  @IBOutlet weak var appliedFriendView: UIView!
 
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var registedFriends = 0
  var appliedFriends = 0
  
  var registedFriendList = [RecordModel]()
  var appliedFriendList = [RecordModel]()
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(self.registeredRecordListUpdate), name: Notification.Name("RegisteredRecordListUpdate"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.recordApplyListUpdate), name: Notification.Name("RecordApplyListUpdate"), object: nil)
    self.registedFriendTableView.registerCell(type: EmptyWalkCell.self)
    self.registedFriendTableView.registerCell(type: WalkListCell.self)
    self.registedFriendTableView.delegate = self
    self.registedFriendTableView.dataSource = self
    self.appliedFriendTableView.registerCell(type: EmptyWalkCell.self)
    self.appliedFriendTableView.registerCell(type: WalkListCell.self)
    self.appliedFriendTableView.delegate = self
    self.appliedFriendTableView.dataSource = self
  
    
    self.registedFriendTableView.showAnimatedSkeleton()
    self.appliedFriendTableView.showAnimatedSkeleton()
    
    
    // 등록한 산책칙구 요청
    self.registedAskView.addTapGesture { recognizer in
      guard self.registedFriendList.count > 0 else { return }
      let destination = FriendAskListViewController.instantiate(storyboard: "Walk").coverNavigationController()
      destination.hero.isEnabled = true
      destination.hero.modalAnimationType = .autoReverse(presenting: .cover(direction: .left))
      destination.modalPresentationStyle = .fullScreen
      self.present(destination, animated: true, completion: nil)
    }
    // 지원한 산책친구
    self.appliedFriendView.addTapGesture { recognizer in
      guard self.appliedFriendList.count > 0 else { return }
      let vc = AppliedListViewController.instantiate(storyboard: "Walk")
      vc.appliedState = .friendApplied
      let destination = vc.coverNavigationController()
      destination.hero.isEnabled = true
      destination.hero.modalAnimationType = .autoReverse(presenting: .cover(direction: .left))
      destination.modalPresentationStyle = .fullScreen
      self.present(destination, animated: true, completion: nil)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    
    self.topButtonsView.setCornerRadius(radius: 10)
  }
  
  override func initRequest() {
    super.initRequest()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.registedFriendList.removeAll()
    self.appliedFriendList.removeAll()
    self.registeredRecordListAPI()
    self.recordApplyListAPI()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  
  /// 산책친구 등록 리스트
  func registeredRecordListAPI() {
    let recordRequest = RecordModel()
    recordRequest.member_idx = Defaults[.member_idx]
    
    APIRouter.shared.api(path: APIURL.registered_record_list, method: .post, parameters: recordRequest.toJSON()) { data in
      if let recordResponse = RecordModel(JSON: data), Tools.shared.isSuccessResponse(response: recordResponse) {
        if let data_array = recordResponse.data_array {
          self.registedFriendList.removeAll()
          for (index, value) in data_array.enumerated() {
            if index < 2 {
              self.registedFriendList.append(value)
            }
          }
        }
        self.registedHeightConstraint.constant = self.registedFriendList.count > 0 ? CGFloat(104 * self.registedFriendList.count) : 166
        self.registedFriendTableView.hideSkeleton()
        self.registedFriendTableView.reloadData()
      }
    } fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }

  }
  
  /// 산책친구 지원 리스트
  func recordApplyListAPI() {
    let recordRequest = RecordModel()
    recordRequest.member_idx = Defaults[.member_idx]
    recordRequest.type = "1"
    
    APIRouter.shared.api(path: APIURL.record_apply_list, method: .post, parameters: recordRequest.toJSON()) { data in
      if let recordResponse = RecordModel(JSON: data), Tools.shared.isSuccessResponse(response: recordResponse) {
        if let data_array = recordResponse.data_array {
          self.appliedFriendList.removeAll()
          for (index, value) in data_array.enumerated() {
            if index < 2 {
              self.appliedFriendList.append(value)
            }
          }
        }
        self.appliedHeightConstraint.constant = self.appliedFriendList.count > 0 ? CGFloat(104 * self.appliedFriendList.count) : 166
        self.appliedFriendTableView.hideSkeleton()
        self.appliedFriendTableView.reloadData()
      }
    } fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }

  }
  
  // 등록한 산책친구 리스트 업데이트
  @objc func registeredRecordListUpdate() {
    self.registedFriendList.removeAll()
    self.registeredRecordListAPI()
  }
  
  // 지원한 산책친구 리스트 업데이트
  @objc func recordApplyListUpdate() {
    self.appliedFriendList.removeAll()
    self.recordApplyListAPI()
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 나와 반려견만 산책
  /// - Parameter sender: UIButton
  @IBAction func withMyPetButtonTouched(sender: UIButton) {
    let vc = SelMyPetViewController.instantiate(storyboard: "Walk")
    vc.record_type = "0"
    let destination = vc.coverNavigationController()
    destination.hero.isEnabled = true
    destination.hero.modalAnimationType = .autoReverse(presenting: .cover(direction: .left))
    destination.modalPresentationStyle = .fullScreen
    self.present(destination, animated: true, completion: nil)
  }
  
  /// 산책친구와 함께
  /// - Parameter sender: UIButton
  @IBAction func withFriendButtonTouched(sender: UIButton) {
    let destination = WithFriendViewController.instantiate(storyboard: "Walk").coverNavigationController()
    destination.hero.isEnabled = true
    destination.hero.modalAnimationType = .autoReverse(presenting: .cover(direction: .left))
    destination.modalPresentationStyle = .fullScreen
    self.present(destination, animated: true, completion: nil)
  }
}


//-------------------------------------------------------------------------------------------
// MARK: - SkeletonTableViewDataSource
//-------------------------------------------------------------------------------------------
extension WalkListViewController: SkeletonTableViewDataSource {
  func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
   return "WalkListCell"
  }
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tableView == self.registedFriendTableView {
      if self.registedFriendList.count == 0 {
        return 1
      } else {
        return self.registedFriendList.count
      }
    } else {
      if self.appliedFriendList.count == 0 {
        return 1
      } else {
        return self.appliedFriendList.count
      }
    }
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let emptyCell = tableView.dequeueReusableCell(withIdentifier: "EmptyWalkCell", for: indexPath) as! EmptyWalkCell
    if tableView == self.registedFriendTableView && self.registedFriendList.count == 0 {
      emptyCell.emptyCellButton.setTitle("산책친구 등록", for: .normal)
      
      // 산책친구 등록
      emptyCell.emptyCellButton.addTapGesture { recognizer in
        let vc = SelMyPetViewController.instantiate(storyboard: "Walk")
        vc.record_type = "1"
        let destination = vc.coverNavigationController()
        destination.hero.isEnabled = false
        destination.hero.modalAnimationType = .autoReverse(presenting: .cover(direction: .left))
        destination.modalPresentationStyle = .fullScreen
        self.present(destination, animated: true, completion: nil)
      }
      return emptyCell
    } else if tableView == self.registedFriendTableView && self.registedFriendList.count > 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "WalkListCell", for: indexPath) as! WalkListCell
      cell.hideSkeleton()
      guard self.registedFriendList.count > 0 else { return cell }
      cell.setWalkData(recordData: self.registedFriendList[indexPath.row])
      
      
      return cell
    } else if tableView == self.appliedFriendTableView && self.appliedFriendList.count == 0 {
      emptyCell.emptyLabel.text = "산책친구 요청을 하셔서 함께 산책 해보세요."
      emptyCell.emptyCellButton.setTitle("산책친구 지원", for: .normal)
      
      // 산책친구 지원
      emptyCell.emptyCellButton.addTapGesture { recognizer in
        let destination = WithFriendViewController.instantiate(storyboard: "Walk").coverNavigationController()
        destination.hero.isEnabled = true
        destination.hero.modalAnimationType = .autoReverse(presenting: .cover(direction: .left))
        destination.modalPresentationStyle = .fullScreen
        self.present(destination, animated: true, completion: nil)
      }
      return emptyCell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "WalkListCell", for: indexPath) as! WalkListCell
      cell.hideSkeleton()
      guard self.appliedFriendList.count > 0 else { return cell}
      let recordData = self.appliedFriendList[indexPath.row]
      cell.setWalkData(recordData: recordData)
      if let animal_array = recordData.animal_array, animal_array.count > 0 {
        cell.petImageView.sd_setImage(with: URL(string: Tools.shared.thumbnailImageUrl(url: animal_array[0].animal_img_path ?? "")), placeholderImage: UIImage(named: "default_dog1"), options: .lowPriority, context: nil)
        if let member_animal_cnt = recordData.member_animal_cnt, member_animal_cnt > 1 {
          cell.petNameLabel.text = "\(recordData.animal_array?[0].animal_name ?? "") 외 \(member_animal_cnt - 1)마리"
        } else {
          cell.petNameLabel.text = "\(recordData.animal_array?[0].animal_name ?? "")"
        }
//        if let record_date = recordData.record_date {
//          let dateFormatter = DateFormatter()
//          dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
//          let date = dateFormatter.date(from: record_date)
//          
//        }
        cell.timeLabel.text = recordData.record_date ?? ""
        cell.addressLabel.text = recordData.record_addr
      }
     

      return cell
    }
    
    
  }
  
}
//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDelegate
//-------------------------------------------------------------------------------------------
extension WalkListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    log.debug("\(indexPath.section) - \(indexPath.row)")
    
    if tableView == self.registedFriendTableView {
      guard self.registedFriendList.count > 0 else { return }
      let destination = FriendAskDetailViewController.instantiate(storyboard: "Walk").coverNavigationController()
      if let firstViewController = destination.viewControllers.first {
        let viewController = firstViewController as! FriendAskDetailViewController
        viewController.record_idx = self.registedFriendList[indexPath.row].record_idx ?? ""
      }
      destination.hero.isEnabled = true
      destination.hero.modalAnimationType = .autoReverse(presenting: .cover(direction: .left))
      destination.modalPresentationStyle = .fullScreen
      self.present(destination, animated: true, completion: nil)
    } else {
      guard self.appliedFriendList.count > 0 else { return }
      
      let destination = FriendAskDetailViewController.instantiate(storyboard: "Walk").coverNavigationController()
      if let firstViewController = destination.viewControllers.first {
        let viewController = firstViewController as! FriendAskDetailViewController
        viewController.record_idx = self.appliedFriendList[indexPath.row].record_idx ?? ""
      }
      destination.hero.isEnabled = true
      destination.hero.modalAnimationType = .autoReverse(presenting: .cover(direction: .left))
      destination.modalPresentationStyle = .fullScreen
      self.present(destination, animated: true, completion: nil)
    }
    
    
    
  }
  
  
}
