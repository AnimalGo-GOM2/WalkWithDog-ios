//
//  FriendAskDetailViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/09.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import NMapsMap
import Defaults

enum FriendAskType {
  case regist
  case find
  case applied
}

class FriendAskDetailViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var petListCollectionView: UICollectionView!
  @IBOutlet weak var listHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var chatButton: UIButton!
  @IBOutlet weak var petListpageControlView: UIView!
  @IBOutlet weak var startLocationMapView: NMFMapView!
  @IBOutlet weak var walkDateLabel: UILabel!
  @IBOutlet weak var startAddressLabel: UILabel!
  @IBOutlet weak var moreBarButtonItem: UIBarButtonItem!
  @IBOutlet weak var ownerImageView: UIImageView!
  @IBOutlet weak var ownerView: UIView!
  @IBOutlet weak var ownerNicknameLabel: UILabel!
  @IBOutlet weak var ownerAgeLabel: UILabel!
  @IBOutlet weak var ownerGenderLabel: UILabel!
  @IBOutlet weak var dotButton: UIButton!
  @IBOutlet weak var dotBarButtonItem: UIBarButtonItem!
  @IBOutlet weak var registButton: UIButton!
  @IBOutlet weak var petImageCollectionView: UICollectionView!
  @IBOutlet weak var myPetsView: UIView!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  let lkPageControl = LKPageControl.init(frame: .zero)
  
  var friendAskType = FriendAskType.regist
  var record_idx = ""
  var recordResponse = RecordModel()
  var petList = [RecordModel]()
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    self.listHeightConstraint.constant = self.view.frame.size.width + 161
    self.lkPageControl.frame = CGRect(x: 0, y: 0, w: self.view.frame.size.width, h: 50)
    self.lkPageControl.currentPageIndicatorTintColor = UIColor(named: "accent")
    self.lkPageControl.pageIndicatorTintColor = UIColor(named: "EAE8E5")
    
    
    self.petListpageControlView.addSubview(self.lkPageControl)
    
    self.petListCollectionView.registerCell(type: WalkFriendAskDetailCell.self)
    self.petListCollectionView.delegate = self
    self.petListCollectionView.dataSource = self
    
    self.petImageCollectionView.registerCell(type: DiaryPetCell.self)
    self.petImageCollectionView.dataSource = self
    self.petImageCollectionView.delegate = self
    let overlay = OverlapCollectionViewLayout()
    overlay.preferredSize = CGSize(width: 68, height: 68)
    overlay.centerDiff = 48
    self.petImageCollectionView.collectionViewLayout = overlay
//    self.petImageCollectionView.collectionViewLayout = OverlapCollectionViewLayout()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    
    self.ownerView.setCornerRadius(radius: 20)
    self.ownerImageView.setCornerRadius(radius: 20)
    self.ownerView.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.ownerView.layer.shadowRadius = 3
    self.ownerView.layer.shadowOpacity = 0.08
    self.ownerView.layer.shadowColor = UIColor(named: "333333")!.cgColor
    self.ownerView.layer.shadowOffset = CGSize(width: 0, height: 3)

    self.ownerView.layer.masksToBounds = false
 
    self.chatButton.setBackgroundColor(UIColor(named: "EAE8E5")!, forState: .disabled)
    self.chatButton.setCornerRadius(radius: 10)
    self.registButton.setCornerRadius(radius: 10)
    self.startLocationMapView.setCornerRadius(radius: 20)
  
  }
  
  override func initRequest() {
    super.initRequest()
    self.registeredRecordDetailAPI()
    self.myAnimalListAPI()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  
  /// 산책친구 등록 상세
  func registeredRecordDetailAPI() {
    let recordRequest = RecordModel()
    recordRequest.record_idx = self.record_idx
    recordRequest.member_idx = Defaults[.member_idx]
    
    APIRouter.shared.api(path: APIURL.registered_record_detail, method: .post, parameters: recordRequest.toJSON()) { response in
      if let recordResponse = RecordModel(JSON: response), Tools.shared.isSuccessResponse(response: recordResponse) {
        self.recordResponse = recordResponse
        
        if recordResponse.member_idx == Defaults[.member_idx] {
          self.navigationItem.title = "등록한 산책친구 요청"
          self.ownerView.isHidden = true
          self.registButton.isHidden = true
          self.chatButton.isHidden = false
          self.dotBarButtonItem.image = UIImage(named: "head_btn_dot")
          self.dotBarButtonItem.isEnabled = true
          self.myPetsView.isHidden = true
          
          self.friendAskType = .regist

          if recordResponse.chat_active_yn == "Y" {
            self.chatButton.isEnabled = true
            if let new_chat_cnt = recordResponse.new_chat_cnt {
              if (Int(new_chat_cnt) ?? 0) > 0 {
                self.chatButton.setImage(UIImage(named: "i_new"), for: .normal)
              } else {
                self.chatButton.setImage(nil, for: .normal)
              }
            }
          } else {
            self.chatButton.isEnabled = false
            self.chatButton.setImage(nil, for: .normal)
          }
          
        } else  {
          self.ownerImageView.sd_setImage(with: URL(string: Tools.shared.thumbnailImageUrl(url: recordResponse.member_img ?? "")), placeholderImage: UIImage(named: "default_profile"), options: .lowPriority, context: nil)
          self.ownerNicknameLabel.text = recordResponse.member_nickname
          self.ownerAgeLabel.text = "\(recordResponse.member_age ?? "")대"
          self.ownerGenderLabel.text = recordResponse.member_gender == "0" ? "남성" : "여성"
          
          if recordResponse.apply_yn == "Y" { // 지원 후
            self.navigationItem.title = "지원한 산책친구"
            self.ownerView.isHidden = false
            self.registButton.isHidden = true
            self.chatButton.isHidden = false
            self.dotBarButtonItem.image = UIImage(named: "head_btn_dot")
            self.dotBarButtonItem.isEnabled = true
            self.myPetsView.isHidden = false
            self.friendAskType = .applied
            self.chatButton.isEnabled = true
            
            if let new_chat_cnt = recordResponse.new_chat_cnt {
              if (Int(new_chat_cnt) ?? 0) > 0 {
                self.chatButton.setImage(UIImage(named: "i_new"), for: .normal)
              } else {
                self.chatButton.setImage(nil, for: .normal)
              }
            }
            
            
            if let my_animal_array = recordResponse.my_animal_array {
              self.petList = my_animal_array
            }
            self.petImageCollectionView.reloadData()
            
          } else {
            self.navigationItem.title = "산책친구 찾기"
            self.ownerView.isHidden = false
            self.registButton.isHidden = false
            self.chatButton.isHidden = true
            self.dotBarButtonItem.image = UIImage()
            self.dotBarButtonItem.isEnabled = false
            self.myPetsView.isHidden = true
            self.chatButton.isEnabled = false
            self.friendAskType = .find
          }
        }
         
        
        self.walkDateLabel.text = self.recordResponse.record_date
        self.startAddressLabel.text = self.recordResponse.record_addr
        self.initMapView(lat: Double(self.recordResponse.record_lat ?? "") ?? 0.0, lng: Double(self.recordResponse.record_lng ?? "") ?? 0.0)

        // 상단 반려견 리스트
        self.lkPageControl.numberOfPages = self.recordResponse.record_animal_array?.count ?? 0
        self.lkPageControl.currentPage = 0
        self.petListCollectionView.reloadData()
      }
    } fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }

  }
  
  
  
  /// 맵 세팅
  func initMapView(lat: Double, lng: Double) {
    log.debug(NMGLatLng(lat: lat, lng: lng))
    let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng), zoomTo: 15)
//    let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: 37, lng: 127), zoomTo: 15)

    self.startLocationMapView.moveCamera(cameraUpdate)
    
    let marker = NMFMarker()
    marker.position = NMGLatLng(lat: lat, lng: lng)
    marker.iconImage = NMFOverlayImage(name: "i_location_s2")
    marker.mapView = self.startLocationMapView
  }
  
  
  /// 산책 친구 등록 취소
  func registeredRecordCancelAPI() {
    let recordRequest = RecordModel()
    recordRequest.record_idx = self.record_idx
    
    APIRouter.shared.api(path: APIURL.registered_record_cancel, method: .post, parameters: recordRequest.toJSON()) { response in
      if let recordResponse = RecordModel(JSON: response), Tools.shared.isSuccessResponse(response: recordResponse) {
        NotificationCenter.default.post(name: Notification.Name("RegisteredRecordListUpdate"), object: nil)
        
        self.dismiss(animated: true, completion: nil)
      }
    } fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }
  }
  
  /// 내 반려견 리스트
  func myAnimalListAPI() {
    let animalRequest = AnimalModel()
    animalRequest.member_idx = Defaults[.member_idx]
    
    APIRouter.shared.api(path: APIURL.my_animal_list, method: .post, parameters: animalRequest.toJSON()) { data in
      if let animalResponse = AnimalModel(JSON: data), Tools.shared.isSuccessResponse(response: animalResponse) {
        if let data_array = animalResponse.data_array, data_array.count > 0 {
          self.appDelegate.myAnimalList = data_array
        }
      }
    } fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }
  }
  
  
  /// 산책친구 지원
  /// - Parameters:
  ///   - animal_idx: 반려견키
  ///   - comment: 첫 대화 메세지
  func recordApplyRegInAPI(animal_idx: String, comment: String) {
    let recordRequest = RecordModel()
    recordRequest.member_idx = Defaults[.member_idx]
    recordRequest.record_idx = self.record_idx
    recordRequest.animal_idx = animal_idx
    recordRequest.comment = comment
    
    APIRouter.shared.api(path: APIURL.record_apply_reg_in, method: .post, parameters: recordRequest.toJSON()) { response in
      if let recordResponse = RecordModel(JSON: response), Tools.shared.isSuccessResponse(response: recordResponse) {
        self.registeredRecordDetailAPI()
      }
    } fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }

  }
  
  // 지원 취소
  func recordApplyCancelAPI() {
    let recordRequest = RecordModel()
    recordRequest.record_idx = self.record_idx
    recordRequest.member_idx = Defaults[.member_idx]
    
    APIRouter.shared.api(path: APIURL.record_apply_cancel, method: .post, parameters: recordRequest.toJSON()) { data in
      if let recordResponse = RecordModel(JSON: data), Tools.shared.isSuccessResponse(response: recordResponse) {
        NotificationCenter.default.post(name: Notification.Name("RecordApplyListUpdate"), object: nil)
        self.dismiss(animated: true, completion: nil)
      }
    } fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }

  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 대화
  /// - Parameter sender: UIButton
  @IBAction func chatButtonTouched(sender: UIButton) {
    if self.recordResponse.member_idx == Defaults[.member_idx] && self.recordResponse.apply_yn == "Y" {
      let destination = AppliedListViewController.instantiate(storyboard: "Walk")
      destination.appliedState = .myApplied
      destination.record_idx = self.record_idx
      self.navigationController?.pushViewController(destination, animated: true)
    }  else {
      let destination = ChatViewController.instantiate(storyboard: "Walk")
      destination.chatting_room_idx = self.recordResponse.chatting_room_idx ?? ""
      self.navigationController?.pushViewController(destination, animated: true)
    }
  }
  
  /// 상단 더보기 버튼
  /// - Parameter sender: UIBarButtonItem
  @IBAction func moreBarButtonItemTouched(sender: UIBarButtonItem) {
    
    let destination = CardPopupViewController.instantiate(storyboard: "Walk")
    if self.friendAskType == .regist {
      destination.fromView = "registedFriendAsk"
    } else if self.friendAskType == .applied {
      destination.fromView = "appliedFriendAsk"
    }
    
    destination.delegate = self
    destination.modalTransitionStyle = .crossDissolve
    destination.modalPresentationStyle = .overCurrentContext
    self.present(destination, animated: false, completion: nil)
  }
  /// 주인 차단/신고 버튼
  /// - Parameter sender: UIBarButtonItem
  @IBAction func dotButtonTouched(sender: UIBarButtonItem) {
    let destination = CardPopupViewController.instantiate(storyboard: "Walk")
    destination.fromView = "findAsk"
    destination.delegate = self
    destination.modalTransitionStyle = .crossDissolve
    destination.modalPresentationStyle = .overCurrentContext
    self.present(destination, animated: false, completion: nil)
  }
  
  /// 산책친구 지원
  /// - Parameter sender: UIButton
  @IBAction func registButtonTouched(sender: UIButton) {
    let destination = RegistPopupViewController.instantiate(storyboard: "Walk")
    destination.record_idx = self.record_idx
    destination.delegate = self
    destination.modalTransitionStyle = .crossDissolve
    destination.modalPresentationStyle = .overCurrentContext
    self.present(destination, animated: false, completion: nil)
  }
}



//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDataSource
//-------------------------------------------------------------------------------------------
extension FriendAskDetailViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView == self.petListCollectionView {
      return self.recordResponse.record_animal_array?.count ?? 0
    } else {
      return self.petList.count
    }
    
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView == self.petListCollectionView {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WalkFriendAskDetailCell", for: indexPath) as! WalkFriendAskDetailCell
      let height = self.view.frame.width
      cell.imageHeightConstraint.constant = height
      cell.setPetData(recordData: self.recordResponse.record_animal_array?[indexPath.row] ?? RecordModel())
      return cell
    }else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryPetCell", for: indexPath) as! DiaryPetCell
      guard self.petList.count > 0 else { return cell }
      let petData = self.petList[indexPath.row]
      cell.petImageView.sd_setImage(with: URL(string: Tools.shared.thumbnailImageUrl(url: petData.animal_img_path ?? "")), placeholderImage: UIImage(named: "default_dog1"), options: .lowPriority, context: nil)
      
      return cell
    }
    
    
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDelegate
//-------------------------------------------------------------------------------------------
extension FriendAskDetailViewController: UICollectionViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let pageWidth = self.petListCollectionView.frame.width
    let currentPage = Int(self.petListCollectionView.contentOffset.x / pageWidth)
    
    self.lkPageControl.currentPage = currentPage
    
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if collectionView == self.petImageCollectionView {
      log.debug("petImage : \(indexPath.row)")
    }
  }
}


//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDelegateFlowLayout
//-------------------------------------------------------------------------------------------
extension FriendAskDetailViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if collectionView == self.petListCollectionView {
      let width = self.view.frame.width
      return CGSize(width: width, height: 559)
    } else {
      return CGSize(width: 68, height: 68)
    }
    
    
  }
}
//-------------------------------------------------------------------------------------------
  // MARK: - SelectedCardPopupDelegate
  //-------------------------------------------------------------------------------------------
extension FriendAskDetailViewController: SelectedCardPopupDelegate {
  func denyTouched() { // 지원 취소
    self.recordApplyCancelAPI()
  }
  
  func cancelTouched() { // 산책 취소
    self.registeredRecordCancelAPI()
  }
  
  func reportTouched() {
    log.debug("reportTouched")
    let destination = ReportViewController.instantiate(storyboard: "Walk").coverNavigationController()
    if let firstViewController = destination.viewControllers.first {
      let viewController = firstViewController as! ReportViewController
      viewController.reportType = .Report
      viewController.partner_member_idx = self.recordResponse.member_idx ?? ""
    }
    destination.modalPresentationStyle = .fullScreen
    self.present(destination, animated: true, completion: nil)
  }
  
  func blockTouched() {
    log.debug("blockTouched")
    let destination = ReportViewController.instantiate(storyboard: "Walk").coverNavigationController()
    if let firstViewController = destination.viewControllers.first {
      let viewController = firstViewController as! ReportViewController
      viewController.reportType = .Block
      viewController.partner_member_idx = self.recordResponse.member_idx ?? ""
      viewController.delegate = self
    }
    destination.modalPresentationStyle = .fullScreen
    self.present(destination, animated: true, completion: nil)
  }
  
  
}


//-------------------------------------------------------------------------------------------
  // MARK: - PetSelectPopupDelegate
  //-------------------------------------------------------------------------------------------
extension FriendAskDetailViewController: PetSelectPopupDelegate {
  func cancelButtonTouched() {
    log.debug("cancelTouched")
  }
  
  func registButtonTouched(animal_idx: String, comment: String) {
    log.debug("registButtonTouched")
//    let destination = AppliedListViewController.instantiate(storyboard: "Walk")
//    destination.state = "applied"
//    self.navigationController?.pushViewController(destination, animated: true)
    self.recordApplyRegInAPI(animal_idx: animal_idx, comment: comment)
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - SuccessBlockDelegate
//-------------------------------------------------------------------------------------------
extension FriendAskDetailViewController: SuccessBlockDelegate {
  func successBlockDelegate() {
    NotificationCenter.default.post(name: Notification.Name("RecordTogetherListUpdate"), object: nil)
    self.navigationController?.popViewController(animated: true)
  }
}
