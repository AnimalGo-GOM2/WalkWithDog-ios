//
//  WithFriendDetailViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/18.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import NMapsMap
import Cosmos
import UPCarouselFlowLayout
import SkeletonView
import Defaults

class WithFriendDetailViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  
  @IBOutlet weak var walkTimeLabel: UILabel!
  @IBOutlet weak var startAddressLabel: UILabel!
  @IBOutlet weak var totalDistanceLabel: UILabel!
  @IBOutlet weak var totalTimeLabel: UILabel!
  @IBOutlet weak var startLocationMapView: NMFMapView!
  @IBOutlet weak var petImageCollectionView: UICollectionView!
  @IBOutlet weak var diaryContentsLabel: UILabel!
  @IBOutlet weak var diaryPhotoCollectionView: UICollectionView!
  @IBOutlet weak var photoHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var emptyPhotoView: UIView!
  @IBOutlet weak var emptyPhotoBorderView: UIView!
  @IBOutlet weak var friendPetListCollectionView: UICollectionView!
  @IBOutlet weak var friendView: UIView!
  @IBOutlet weak var friendImageView: UIImageView!
  @IBOutlet weak var friendNickNameLabel: UILabel!
  @IBOutlet weak var friendAgeLabel: UILabel!
  @IBOutlet weak var friendGenderLabel: UILabel!
  @IBOutlet weak var readyStarView: CosmosView!
  @IBOutlet weak var mannerStarView: CosmosView!
  @IBOutlet weak var timeStarView: CosmosView!
  @IBOutlet weak var socialityStarView: CosmosView!
  @IBOutlet weak var petListpageControlView: UIView!
  @IBOutlet weak var timeLabel: UILabel!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  let lkPageControl = LKPageControl.init(frame: .zero)
  
  var record_diary_idx = ""
  var record_type = ""
  var recordResponse = RecordModel()
  var petList = [RecordModel]()
  var photoList = [String]()
  var locationList = [RecordModel]()
  
  // 마커
  let startMarker = NMFMarker()
  let endMarker = NMFMarker()
  // 라인
  var poly = NMFPolylineOverlay()
  
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.timeStarView.isUserInteractionEnabled = false
    self.readyStarView.isUserInteractionEnabled = false
    self.mannerStarView.isUserInteractionEnabled = false
    self.socialityStarView.isUserInteractionEnabled = false
    
    self.readyStarView.settings.fillMode = .half
    self.mannerStarView.settings.fillMode = .half
    self.timeStarView.settings.fillMode = .half
    self.socialityStarView.settings.fillMode = .half
    
    
    self.lkPageControl.frame = CGRect(x: 0, y: 0, w: self.view.frame.size.width, h: 50)
    self.lkPageControl.currentPageIndicatorTintColor = UIColor(named: "accent")
    self.lkPageControl.pageIndicatorTintColor = UIColor(named: "EAE8E5")
//    self.lkPageControl.numberOfPages = 3
    self.lkPageControl.currentPage = 0
    
    self.petListpageControlView.addSubview(self.lkPageControl)
    
    self.friendView.setCornerRadius(radius: 20)
    self.friendImageView.setCornerRadius(radius: 20)
    self.friendView.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.friendView.layer.shadowRadius = 3
    self.friendView.layer.shadowOpacity = 0.08
    self.friendView.layer.shadowColor = UIColor(named: "333333")!.cgColor
    self.friendView.layer.shadowOffset = CGSize(width: 0, height: 3)
    self.friendView.layer.masksToBounds = false
    
    self.friendPetListCollectionView.registerCell(type: WalkFriendAskDetailCell.self)
    self.friendPetListCollectionView.delegate = self
    self.friendPetListCollectionView.dataSource = self
  
    self.startLocationMapView.setCornerRadius(radius: 20)
    
    self.diaryPhotoCollectionView.registerCell(type: DiaryPhotoCell.self)
    self.diaryPhotoCollectionView.delegate = self
    self.diaryPhotoCollectionView.dataSource = self
    
    self.petImageCollectionView.registerCell(type: DiaryPetCell.self)
    self.petImageCollectionView.delegate = self
    self.petImageCollectionView.dataSource = self
    
    let overlay = OverlapCollectionViewLayout()
    overlay.preferredSize = CGSize(width: 68, height: 68)
    overlay.centerDiff = 48
    self.petImageCollectionView.collectionViewLayout = overlay
    
    self.setImageCollectionView()
    
    self.emptyPhotoBorderView.setCornerRadius(radius: 20)
    self.emptyPhotoBorderView.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    
    self.navigationController?.isNavigationBarHidden = true
    self.navigationController?.interactivePopGestureRecognizer?.delegate = nil

  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
  }
  
  override func initRequest() {
    super.initRequest()
    self.recordDiaryDetailAPI()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 맵 세팅
  func initMapView() {
    guard self.locationList.count > 0 else { return }

    let start_dong_lat = Double(self.locationList[0].lat ?? "") ?? 0.0
    let start_dong_lng = Double(self.locationList[0].lng ?? "") ?? 0.0
    
    let end_dong_lat = Double(self.locationList[self.locationList.count - 1].lat ?? "") ?? 0.0
    let end_dong_lng = Double(self.locationList[self.locationList.count - 1].lng ?? "") ?? 0.0
    
    let latMin = self.locationList.map { Double($0.lat ?? "") ?? 0.0 }.min() ?? 0.0
    let lngMin = self.locationList.map { Double($0.lng ?? "") ?? 0.0 }.min() ?? 0.0
    let latMax = self.locationList.map { Double($0.lat ?? "") ?? 0.0 }.max() ?? 0.0
    let lngMax = self.locationList.map { Double($0.lng ?? "") ?? 0.0 }.max() ?? 0.0
    
    
    let cameraUpdate = NMFCameraUpdate(fit: NMGLatLngBounds(southWest: NMGLatLng(lat: Double(latMin), lng: Double(lngMin)), northEast:NMGLatLng(lat: Double(latMax), lng: Double(lngMax))), paddingInsets: UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30))
    
    self.startLocationMapView.moveCamera(cameraUpdate)
    self.startMarker.position = NMGLatLng(lat: start_dong_lat, lng: start_dong_lng)
    self.startMarker.iconImage = NMFOverlayImage(name: "i_location_s2")
    self.startMarker.anchor = CGPoint(x: 0.5, y: 0)
    self.startMarker.mapView = self.startLocationMapView
    self.endMarker.position = NMGLatLng(lat: end_dong_lat, lng: end_dong_lng)
    self.endMarker.iconImage = NMFOverlayImage(name: "i_location_s1")
    self.endMarker.anchor = CGPoint(x: 0.5, y: 1)
    self.endMarker.mapView = self.startLocationMapView
    
    // 선 그리기
    var pointsArray = [NMGLatLng]()
    for value in self.locationList {
      pointsArray.append(NMGLatLng(lat: Double(value.lat ?? "") ?? 0.0, lng: Double(value.lng ?? "") ?? 0.0))
    }
    
    if let poly = NMFPolylineOverlay(pointsArray) {
      poly.color = UIColor(named: "accent")!
      poly.width = 3
      poly.mapView = self.startLocationMapView
    }
  }
  
  
  /// 다이어리 이미지
  func setImageCollectionView() {
    let layout = UPCarouselFlowLayout()
  
    let width = self.view.frame.size.width - 40
    self.photoHeightConstraint.constant = width
    
    layout.itemSize = CGSize(width: width, height: width)
    layout.scrollDirection = .horizontal
    layout.sideItemScale = 1
    layout.sideItemAlpha = 1
    layout.spacingMode = .overlap(visibleOffset: 10)
    self.diaryPhotoCollectionView.collectionViewLayout = layout
    self.diaryPhotoCollectionView.reloadData()
  }
  
  /// 산책기록 상세
  func recordDiaryDetailAPI() {
    let recordRequest = RecordModel()
    recordRequest.record_diary_idx = self.record_diary_idx
    recordRequest.member_idx = Defaults[.member_idx]
    recordRequest.record_type = self.record_type
    
    APIRouter.shared.api(path: APIURL.record_diary_detail, method: .post, parameters: recordRequest.toJSON()) { data in
      if let recordResponse = RecordModel(JSON: data), Tools.shared.isSuccessResponse(response: recordResponse) {
        self.recordResponse = recordResponse
        self.walkTimeLabel.text = recordResponse.record_date
        self.timeLabel.text = "산책일시 : \(recordResponse.record_date ?? "")"
        self.startAddressLabel.text = recordResponse.record_addr
        self.totalDistanceLabel.text = "총 거리 \(recordResponse.record_distant ?? "")km"
        self.totalTimeLabel.text = "총 시간 \(recordResponse.record_hour ?? "")분"
        self.lkPageControl.numberOfPages = recordResponse.partner_animal_cnt ?? 0
        self.friendPetListCollectionView.reloadData()
        
        
        self.friendImageView.sd_setImage(with: URL(string: "\(baseURL)\(recordResponse.member_img ?? "")"), placeholderImage: UIImage(named: "default_profile"), options: .lowPriority, completed: nil)
        self.friendNickNameLabel.text = recordResponse.member_nickname
        self.friendAgeLabel.text = "\(recordResponse.member_age ?? "")대"
        self.friendGenderLabel.text = recordResponse.member_gender == "0" ? "남성" : "여성"
        self.readyStarView.rating = Double(recordResponse.review_0 ?? "") ?? 0.0
        self.mannerStarView.rating = Double(recordResponse.review_1 ?? "") ?? 0.0
        self.timeStarView.rating = Double(recordResponse.review_2 ?? "") ?? 0.0
        self.socialityStarView.rating = Double(recordResponse.review_3 ?? "") ?? 0.0
        
        if let memo = recordResponse.memo, memo != "" {
          self.diaryContentsLabel.text = memo
          self.diaryContentsLabel.textColor = .black
        } else {
          self.diaryContentsLabel.text = "등록된 산책일기가 없습니다."
          self.diaryContentsLabel.textColor = UIColor(named: "999999")!
        }
        
        if let record_img_paths = recordResponse.record_img_paths, record_img_paths != "" {
          let recordImgArr = record_img_paths.components(separatedBy: ",")
          for value in recordImgArr {
            self.photoList.append(value)
          }
          self.diaryPhotoCollectionView.isHidden = false
          self.emptyPhotoView.isHidden = true
          self.diaryPhotoCollectionView.reloadData()
        } else {
          self.diaryPhotoCollectionView.isHidden = true
          self.emptyPhotoView.isHidden = false
        }
        
        if let coordinates = recordResponse.coordinates, coordinates != "" {
          let coordinatesArr = coordinates.components(separatedBy: "|")
          for value in coordinatesArr {
            let coordinates = value.components(separatedBy: ",")
            let locationData = RecordModel()
            locationData.lat = coordinates[0]
            locationData.lng = coordinates[1]
            self.locationList.append(locationData)
          }
          self.initMapView()
        }

        if let member_animal_array = recordResponse.member_animal_array {
          self.petList = member_animal_array
        }
        
        self.petImageCollectionView.reloadData()
//        self.scrollView.hideSkeleton()
        self.petImageCollectionView.hideSkeleton()
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
// MARK: - SkeletonCollectionViewDataSource
//-------------------------------------------------------------------------------------------
extension WithFriendDetailViewController: SkeletonCollectionViewDataSource {
  func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 3
  }
  
  func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
    return "DiaryPetCell"
  }
  
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView == self.friendPetListCollectionView {
      return self.recordResponse.partner_animal_array?.count ?? 0
    } else if collectionView == self.diaryPhotoCollectionView {
      return self.photoList.count
    } else {
      return self.petList.count
    }
    
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView == self.friendPetListCollectionView {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WalkFriendAskDetailCell", for: indexPath) as! WalkFriendAskDetailCell
      let height = self.view.frame.width
      cell.imageHeightConstraint.constant = height
      guard self.recordResponse.partner_animal_array?.count ?? 0 > 0 else { return cell }
      cell.setPetData(recordData: self.recordResponse.partner_animal_array?[indexPath.row] ?? RecordModel())
      
      return cell
    } else if collectionView == self.diaryPhotoCollectionView {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryPhotoCell", for: indexPath) as! DiaryPhotoCell
      guard self.photoList.count > 0 else { return cell }
      let photoData = self.photoList[indexPath.row]
      cell.photoImageView.setCornerRadius(radius: 20)
      cell.photoImageView.sd_setImage(with: URL(string: "\(baseURL)\(photoData)"), completed: nil)
      return cell
    } else {
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
extension WithFriendDetailViewController: UICollectionViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView == self.friendPetListCollectionView {
      let pageWidth = self.friendPetListCollectionView.frame.width
      let currentPage = Int(self.friendPetListCollectionView.contentOffset.x / pageWidth)
      
      self.lkPageControl.currentPage = currentPage
    } 
  }
  
  
}


//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDelegateFlowLayout
//-------------------------------------------------------------------------------------------
extension WithFriendDetailViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if collectionView == self.friendPetListCollectionView {
      let width = self.view.frame.width
      return CGSize(width: width, height: 559)
    }else if collectionView == self.diaryPhotoCollectionView {
      let width = self.view.frame.width - 40
      return CGSize(width: width, height: width)
    } else {
      return CGSize(width: 68, height: 68)
    }
    
    
  }
}
