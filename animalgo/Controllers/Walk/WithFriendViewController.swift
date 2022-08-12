//
//  WithFriendViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/08.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import SkeletonView
import SwiftUI
import Defaults

class WithFriendViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var walkFriendTableView: UITableView!
  @IBOutlet weak var requestRegistButton: UIButton!
  @IBOutlet weak var addressButton: UIButton!
  @IBOutlet weak var filterBarButtonItem: UIBarButtonItem!
  @IBOutlet weak var setLocationButton: UIButton!
  @IBOutlet weak var emptyView: UIView!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var recordRequest = RecordModel()
  var recordList = [RecordModel]()
  var selectBreedList = [AnimalModel]()
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(self.updateLocation), name: Notification.Name("UpdateLocation"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.recordTogetherListUpdate), name: Notification.Name("RecordTogetherListUpdate"), object: nil)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    
    self.requestRegistButton.setCornerRadius(radius: 10)
    self.walkFriendTableView.registerCell(type: WalkFriendCell.self)
    self.walkFriendTableView.delegate = self
    self.walkFriendTableView.dataSource = self
    
    self.walkFriendTableView.showAnimatedSkeleton()
    
    self.setLocationButton.setCornerRadius(radius: 20)
    
    
    if Defaults[.currentLat] == nil {
      self.emptyView.isHidden = false
      self.walkFriendTableView.isHidden = true
      self.requestRegistButton.isHidden = true
    } else {
      self.emptyView.isHidden = true
      self.walkFriendTableView.isHidden = false
      self.requestRegistButton.isHidden = false
    }
    
  }
  
  override func initRequest() {
    super.initRequest()
    self.startReversegeocodeAPI(lat: "\(Defaults[.currentLat] ?? 37.56638274705945)", lng: "\(Defaults[.currentLng] ?? 126.97794372508841)")
    self.recordRequest.member_lat = "\(Defaults[.currentLat] ?? 37.56638274705945)"
    self.recordRequest.member_lng = "\(Defaults[.currentLng] ?? 126.97794372508841)"
    self.recordTogetherListAPI()
  }
  
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    if isMovingFromParent {
      NotificationCenter.default.removeObserver(self)
    }
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------ㅍ
  /// 주소
  func startReversegeocodeAPI(lat: String, lng: String) {
    APIRouter.shared.geo_api(lat: lat, lng: lng) { response in
      if let geoResponse = GeoModel(JSON: response) {
        if geoResponse.status?.name == "ok" {
          if let result = geoResponse.results {
            var region = GeoModel()
            var name = ""
            if result.count > 1 {
              region = result[1].region ?? GeoModel()
              if let land = result[1].land {
                name = land.name ?? ""
              }
            } else if result.count > 0 {
              region = result[0].region ?? GeoModel()
            }
            self.addressButton.setTitle("\(region.area1?.name ?? "") \(region.area2?.name ?? "") \(region.area3?.name ?? "") \(name)", for: .normal)
          } else {
            self.addressButton.setTitle("", for: .normal)
          }
        } else {
          self.addressButton.setTitle("", for: .normal)
        }
      }
      
    } fail: { error in
      AJAlertController.initialization().showAlertWithOkButton(astrTitle: "", aStrMessage: "\(error?.localizedDescription ?? "")", alertViewHiddenCheck: false) { position, title in
        
      }
    }
  }
  
  
  /// 산책친구와 함께
  func recordTogetherListAPI() {
    self.recordRequest.member_idx = Defaults[.member_idx]
    self.recordRequest.setNextPage()
    
    APIRouter.shared.api(path: APIURL.record_together_list, method: .post, parameters: self.recordRequest.toJSON()) { data in
      if let recordResponse = RecordModel(JSON: data), Tools.shared.isSuccessResponse(response: recordResponse) {
        self.recordRequest.total_page = recordResponse.total_page ?? 0
        self.isLoadingList = true
        if let data_array = recordResponse.data_array {
          self.recordList += data_array
        }
        self.walkFriendTableView.hideSkeleton()
        self.walkFriendTableView.reloadData()
      }
    } fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }

  }
  
  // 위치정보 업데이트
  @objc func updateLocation() {
    self.startReversegeocodeAPI(lat: "\(Defaults[.currentLat] ?? 0.0)", lng: "\(Defaults[.currentLng] ?? 0.0)")
    self.recordRequest.member_lat = "\(Defaults[.currentLat] ?? 0.0)"
    self.recordRequest.member_lng = "\(Defaults[.currentLng] ?? 0.0)"
    
  }
  
  // 산책친구와 함께 리프레시
  @objc func recordTogetherListUpdate() {
    self.recordRequest.resetPage()
    self.recordList.removeAll()
    self.recordTogetherListAPI()
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 산책친구 요청 등록
  /// - Parameter sender: UIButton
  @IBAction func requestRegistButtonTouched(sender: UIButton){
    let vc = SelMyPetViewController.instantiate(storyboard: "Walk")
    vc.record_type = "1"
    let destination = vc.coverNavigationController()
    destination.hero.isEnabled = false
    destination.hero.modalAnimationType = .autoReverse(presenting: .cover(direction: .left))
    destination.modalPresentationStyle = .fullScreen
    self.present(destination, animated: true, completion: nil)
  }
  /// 필터
  /// - Parameter sender: UIButton
  @IBAction func filterBarButtonItemTouched(sender: UIBarButtonItem){
    let destination = FriendFilterViewController.instantiate(storyboard: "Walk")
    destination.filterRequest = self.recordRequest
    destination.breedList = self.selectBreedList
    destination.delegate = self
    self.navigationController?.pushViewController(destination, animated: true)
  }
  /// 내위치 변경
  /// - Parameter sender: UIButton
  @IBAction func addressButtonTouched(sender: UIButton) {
    let destination = MyLocationViewController.instantiate(storyboard: "Walk")
    destination.recordRequest.record_lng = self.recordRequest.member_lng ?? nil
    destination.recordRequest.record_lat = self.recordRequest.member_lat ?? nil
    destination.delegate = self
    destination.fromView = "WithFriendList"
    self.navigationController?.pushViewController(destination, animated: true)
  
  }
  
  /// 산책위치 설정
  /// - Parameter sender: 버튼
  @IBAction func setLocationButtonTouched(sender: UIButton) {
    let destination = MyLocationViewController.instantiate(storyboard: "Walk")
    destination.delegate = self
    destination.fromView = "WithFriendList"
    self.navigationController?.pushViewController(destination, animated: true)
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - SkeletonTableViewDataSource
//-------------------------------------------------------------------------------------------
extension WithFriendViewController: SkeletonTableViewDataSource {
  func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return 4
  }
  func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
   return "WalkFriendCell"
  }
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.recordList.count
    
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "WalkFriendCell", for: indexPath) as! WalkFriendCell
    guard self.recordList.count > 0 else { return cell }
    cell.setRecordData(recordData: self.recordList[indexPath.row])
    cell.isNewImageView.isHidden = true
    
    // 마지막은 구분선 제거
    if indexPath.row == self.recordList.count - 1 {
      cell.underView.isHidden = true
    }
    return cell
  }
  
}
//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDelegate
//-------------------------------------------------------------------------------------------
extension WithFriendViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let destination = FriendAskDetailViewController.instantiate(storyboard: "Walk")
    destination.record_idx = self.recordList[indexPath.row].record_idx ?? ""
    self.navigationController?.pushViewController(destination, animated: true)
  }
  
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView == self.walkFriendTableView {
      let currentOffset = scrollView.contentOffset.y
      let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
      
      if maximumOffset - currentOffset <= 10.0 {
        if self.recordRequest.isMore() && self.isLoadingList {
          self.isLoadingList = false
          self.recordTogetherListAPI()
        }
      }
    }
  }
  
}

//-------------------------------------------------------------------------------------------
// MARK: - FriendFilterDelegate
//-------------------------------------------------------------------------------------------
extension WithFriendViewController: FriendFilterDelegate {
  func friendFilterDelegate(filterModel: RecordModel, selectBreedList: [AnimalModel]) {
    self.recordRequest = filterModel
    self.recordList.removeAll()
    self.recordRequest.resetPage()
    self.recordTogetherListAPI()
    self.selectBreedList = selectBreedList
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - SetMyLocationDelegate
//-------------------------------------------------------------------------------------------
extension WithFriendViewController: SetMyLocationDelegate {
  func setMyLocationDelegate(recordRequest: RecordModel) {
    self.recordRequest.member_lat = recordRequest.record_lat
    self.recordRequest.member_lng = recordRequest.record_lng
    self.addressButton.setTitle(recordRequest.record_addr ?? "", for: .normal)
    
    self.emptyView.isHidden = true
    self.walkFriendTableView.isHidden = false
    self.requestRegistButton.isHidden = false
    
    self.recordList.removeAll()
    self.recordRequest.resetPage()
    self.recordTogetherListAPI()
  }
}
