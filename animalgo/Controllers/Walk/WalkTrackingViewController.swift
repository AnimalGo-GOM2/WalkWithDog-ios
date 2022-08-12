//
//  WalkTrackingViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/10.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import NMapsMap
import Defaults
import SwiftLocation
import HCKalmanFilter
import CoreLocation

class WalkTrackingViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var writeDiaryButton: UIButton!
  @IBOutlet weak var mapView: NMFMapView!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var dotButton: UIButton!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var underView: UIView!
  @IBOutlet weak var topView: UIView!
  @IBOutlet weak var friendPetListButton: UIButton!
  @IBOutlet weak var memberImageView: UIImageView!
  @IBOutlet weak var nicknameLabel: UILabel!
  @IBOutlet weak var ageLabel: UILabel!
  @IBOutlet weak var genderLabel: UILabel!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var recordRequest = RecordModel()
  var recordResponse = RecordModel()
  var petList = [RecordModel]()
  
  var locationManager = CLLocationManager()
  var locationRequest: GPSLocationRequest?
  
  var locationList: [CLLocation] = []
  var oldLocationList: [CLLocation] = []
  var noAccuracyLocationList: [CLLocation] = []
  var inaccurateLocationList: [CLLocation] = []
  var kalmanNGLocationList: [CLLocation] = []
  var isCameraUpdate = true
  
  let filteredPath = NMFPath()
  
  var kalmanFilter = KalmanLatLong(Q_metres_per_second: 3)
  let marker = NMFMarker() // 현재 위치 마커
  var currentSpeed: Float = 0.0
  var runStartTimeInMillis: Double = 0.0
  var timer: Timer?
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    self.memberImageView.setCornerRadius(radius: 15)
    self.writeDiaryButton.setCornerRadius(radius: 14.5)
    
    self.underView.layer.shadowRadius = 3
    self.underView.layer.shadowOpacity = 0.29
    self.underView.layer.shadowColor = UIColor(named: "000000")!.cgColor
    self.underView.layer.shadowOffset = CGSize(width: 0, height: 1)
    self.underView.layer.masksToBounds = false
    
    self.topView.layer.shadowRadius = 3
    self.topView.layer.shadowOpacity = 0.29
    self.topView.layer.shadowColor = UIColor(named: "000000")!.cgColor
    self.topView.layer.shadowOffset = CGSize(width: 0, height: -1)
    self.topView.layer.masksToBounds = false
    
    self.initMapView()
  }
  
  override func initRequest() {
    super.initRequest()
    if Defaults[.record_idx] == nil {
      Defaults[.record_type] = self.recordRequest.record_type ?? ""
      self.recordRegInAPI()
    } else {
      
      self.partnerAnimalListAPI()
      self.recordRequest.record_type = Defaults[.record_type]
      self.recordRequest.member_animal_idxs = Defaults[.member_animal_idxs]
      self.locationTrack()
      self.linePathDraw()
      if self.appDelegate.timer == nil {
        self.appDelegate.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self.appDelegate, selector: #selector(self.appDelegate.timerAction), userInfo: nil, repeats: true)
      }
      
      if self.timer == nil {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
      }
    }
    
    if self.recordRequest.record_type == "1" {
      self.dotButton.setImage(UIImage(named: "head_btn_dot"), for: .normal)
      self.topView.isHidden = false
    } else {
      self.topView.isHidden = true
    }
    
    
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 맵 세팅
  func initMapView() {
    let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: Defaults[.currentLat] ?? 0.0, lng: Defaults[.currentLng] ?? 0.0), zoomTo: 17)
    self.mapView.moveCamera(cameraUpdate)
    
    // 현재 위치 마커
    self.setCurrentPositionMarker(lat: Defaults[.currentLat] ?? 0.0, lng: Defaults[.currentLng] ?? 0.0)
    
    self.startReversegeocodeAPI(lat: "\(Defaults[.currentLat] ?? 0.0)", lng: "\(Defaults[.currentLng] ?? 0.0)")
  }
  
  // 상대 반려견 리스트
  func partnerAnimalListAPI() {
    let recordRequest = RecordModel()
    recordRequest.member_idx = Defaults[.member_idx]
    recordRequest.record_idx = Defaults[.record_idx]
    
    APIRouter.shared.api(path: APIURL.partner_animal_list, method: .post, parameters: recordRequest.toJSON()) { data in
      if let recordResponse = RecordModel(JSON: data), Tools.shared.isSuccessResponse(response: recordResponse) {
        self.recordResponse = recordResponse
        
        self.memberImageView.sd_setImage(with: URL(string: Tools.shared.thumbnailImageUrl(url: recordResponse.member_img ?? "")), placeholderImage: UIImage(named: "default_profile"), options: .lowPriority, context: nil)
        self.nicknameLabel.text = recordResponse.member_nickname
        self.ageLabel.text = "\(recordResponse.member_age ?? "")대"
        self.genderLabel.text = recordResponse.member_gender == "0" ? "남성" : "여성"
        
        if let data_array = recordResponse.data_array {
          self.petList = data_array
        }
      }
    } fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }

  }
  
  /// 산책 등록
  func recordRegInAPI() {
    let recordRequest = RecordModel()
    recordRequest.member_idx = Defaults[.member_idx]
    recordRequest.record_type = self.recordRequest.record_type
    recordRequest.member_animal_idxs = self.recordRequest.member_animal_idxs
    
    APIRouter.shared.api(path: APIURL.record_reg_in, method: .post, parameters: recordRequest.toJSON()) { response in
      if let recordResponse = RecordModel(JSON: response), Tools.shared.isSuccessResponse(response: recordResponse) {
        Defaults[.record_idx] = recordResponse.record_idx ?? ""
        Defaults[.start_date] = Date()
        self.locationTrack()
        
        if self.appDelegate.timer == nil {
          self.appDelegate.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self.appDelegate, selector: #selector(self.appDelegate.timerAction), userInfo: nil, repeats: true)
        }
        if self.timer == nil {
          self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
        }
      }
    } fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }
    
  }
  
  
  
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
            self.addressLabel.text = "\(region.area1?.name ?? "") \(region.area2?.name ?? "") \(region.area3?.name ?? "") \(name)"
            // 산책 출발지 저장
            if Defaults[.recording_address] == nil {
              Defaults[.recording_address] = "\(region.area1?.name ?? "") \(region.area2?.name ?? "") \(region.area3?.name ?? "") \(name)"
            }
          } else {
            self.addressLabel.text = ""
          }
        } else {
          self.addressLabel.text = ""
        }
      }
      
    } fail: { error in
      log.error("\(error?.localizedDescription ?? "")")
    }
    
  }
  
  /// 위치 측정 시작
  func locationTrack() {
    SwiftLocation.allowsBackgroundLocationUpdates = true
    
    let serviceOptions = GPSLocationOptions()
    serviceOptions.avoidRequestAuthorization = true
    serviceOptions.precise = .fullAccuracy
    serviceOptions.accuracy = .house
    serviceOptions.activityType = .fitness
    serviceOptions.subscription = .continous
    
    self.locationRequest = SwiftLocation.gpsLocationWith(serviceOptions)
    
    
    self.locationRequest?.then(queue: .main) { result in
      NotificationCenter.default.post(name: NOTIFICATION_GPS_DATA, object: result, userInfo: nil)
      switch result {
      case .success(let location):
        log.debug("GPS 성공 ============== ")
        log.debug("위도 = \(location.coordinate.latitude)")
        log.debug("경도 = \(location.coordinate.longitude)")
        log.debug("시간 = \(Date())")
        
        // 칼만 필터 적용
        let speed = self.getSpeed(newLocation: location)
        
        
        if speed < 0 {
          return
        }
        
        let age = self.getLocationAge(newLocation: location)
        
        if age > 5 * 1000 {
          log.error("Location is old")
          self.oldLocationList.append(location)
          return
        }
        
        let distance = hypot(0 - location.horizontalAccuracy, 0 - location.verticalAccuracy)
        
        if distance <= 0 {
          log.error("Latitidue and longitude values are invalid.")
          self.noAccuracyLocationList.append(location)
          return
        }
        
        if location.horizontalAccuracy > 20 || location.verticalAccuracy > 20 { // 100 meter filter IOS는 정확도 때문에 100m 로 잡힌다.
          log.error("Accuracy is too low.")
          if Defaults[.totalLocationList].count == 0 {
            Defaults[.totalLocationList].append("\(Date().toString(format: "yyyy-MM-dd HH:mm:ss")),\(location.coordinate.latitude),\(location.coordinate.longitude)")
          }
          
          self.inaccurateLocationList.append(location)
          return
        }
        
        Defaults[.totalLocationList].append("\(Date().toString(format: "yyyy-MM-dd HH:mm:ss")),\(location.coordinate.latitude),\(location.coordinate.longitude)")
        
        
        var Qvalue: Float = 0.0
        
        let locationTimeInMillis = location.timestamp.timeIntervalSince1970
        let elapsedTimeInMillis = locationTimeInMillis - self.runStartTimeInMillis
        
        if (self.currentSpeed == 0.0) {
          Qvalue = 3.0 // 3 m/s
        } else {
          Qvalue = self.currentSpeed // Speed m/s
        }
        
        
        self.kalmanFilter.Process(lat_measurement: location.coordinate.latitude, lng_measurement: location.coordinate.longitude, accuracy: Float(distance), TimeStamp_milliseconds: elapsedTimeInMillis, Q_metres_per_second: Qvalue)
        let predictedLat = self.kalmanFilter.get_lat()
        let predictedLng = self.kalmanFilter.get_lng()
        let predictedLocation = CLLocation(latitude: predictedLat, longitude: predictedLng)
        let predictedDeltaInMeters = predictedLocation.distance(from: location)
        
        if predictedDeltaInMeters > 60 {
          log.debug("Kalman Filter detects mal GPS, we should probably remove this from track")
          self.kalmanFilter.consecutiveRejectCount += 1
          
          if self.kalmanFilter.consecutiveRejectCount > 3 {
            self.kalmanFilter = KalmanLatLong(Q_metres_per_second: 3)  //reset Kalman Filter if it rejects more than 3 times in raw.
          }
          self.kalmanNGLocationList.append(location)
          return
        } else {
          self.kalmanFilter.consecutiveRejectCount = 0
        }
        
        
        self.currentSpeed = Float(speed)
        
        
        // 위도 = location.coordinate.latitude
        // 경도 = location.coordinate.longitude
        self.locationList.append(location)
        // 산책 기록 정보를 로컬에 저장
//        self.appDelegate.totalLocationList.append(location)
        
        
        
        // 정상 라인 그리기
        self.linePathDraw()
        
      case .failure(let error):
        log.error(error.localizedDescription)
      }
    }
    
  }
  
  
  /// 속도
  /// - Parameter newLocation: 새로운 위치
  /// - Returns: 속도
  private func getSpeed(newLocation: CLLocation) -> Double {
    var speed = 0.0
    
    if let lastLocation = self.locationList.last {
      let time = newLocation.timestamp.timeIntervalSince(lastLocation.timestamp)
      if (time <= 0) {
        return 0.0
      }
      
      let distanceFromLast = lastLocation.distance(from: newLocation)
      speed = Double(distanceFromLast / time) // meter / second
    }
    
    return speed
  }
  
  
  // 위치 시간 책정
  private func getLocationAge(newLocation: CLLocation) -> Double {
    var locationAge = 0.0
    locationAge = Date().timeIntervalSince1970 - newLocation.timestamp.timeIntervalSince1970
    return locationAge
  }
  
  // 실제 라인
  private func linePathDraw() {
    if (self.locationList.count > 2) {
      
      var locationList: [NMGLatLng] = []
      for value in self.locationList {
        locationList.append(NMGLatLng(lat: value.coordinate.latitude, lng: value.coordinate.longitude))
      }
      
      self.filteredPath.mapView = nil
      self.filteredPath.color = UIColor(named: "accent")!
      self.filteredPath.width = 6
      self.filteredPath.path = NMGLineString(points: locationList)
      self.filteredPath.mapView = self.mapView
      
      
      // 현재 위치 마커
      let lastLocationData = self.locationList[self.locationList.count - 1]
      self.setCurrentPositionMarker(lat: lastLocationData.coordinate.latitude, lng: lastLocationData.coordinate.longitude)
      
      if self.isCameraUpdate {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lastLocationData.coordinate.latitude, lng: lastLocationData.coordinate.longitude), zoomTo: 17)
        self.mapView.moveCamera(cameraUpdate)
      }
    }
  }
  
  /// 현재 위치 마커
  func setCurrentPositionMarker(lat: Double, lng: Double) {
    self.marker.mapView = nil
    self.marker.iconImage = NMFOverlayImage(name: "i_location")
    self.marker.anchor = CGPoint(x: 0.5, y: 1)
    self.marker.position = NMGLatLng(lat: lat, lng: lng)
    self.marker.mapView = self.mapView
  }
  
  /// 타이머
  @objc func timerAction() {
    let time = Defaults[.recording_time] ?? 0
    
    let hour = time / 3600
    let minutes = (time % 3600) / 60
    let seconds = (time % 3600) % 60
    
    log.debug("recording_time : \(Defaults[.recording_time] ?? 0) \(String(format:"%02i:%02i:%02i", hour, minutes, seconds))")
  
    self.timeLabel.text = String(format:"%02i:%02i:%02i", hour, minutes, seconds)
    
    
    var totalDistance = 0.0 // 단위 : m
    for (index, value) in Defaults[.totalLocationList].enumerated() {
      if (index > 0) {
        let location1 = value.components(separatedBy: ",")
        let cllocation1 = CLLocation(latitude: Double(location1[1]) ?? 0.0, longitude: Double(location1[2]) ?? 0.0)
        let location2 = Defaults[.totalLocationList][index - 1].components(separatedBy: ",")
        let cllocation2 = CLLocation(latitude: Double(location2[1]) ?? 0.0, longitude: Double(location2[2]) ?? 0.0)
        totalDistance += floor(cllocation1.distance(from: cllocation2) * 10) / 10
      }
    }
  
    if let startData = Defaults[.start_date] {
      self.dateLabel.text = startData.toString(format: "yyyy-MM-dd HH:mm ~")
      log.debug("timerAction : recording_time \(time), start_date \(startData.toString(format: "yyyy-MM-dd HH:mm:ss"))")
    }
    
    Defaults[.totalDistance] = floor(totalDistance / 100) / 10
    self.distanceLabel.text = "\(Defaults[.totalDistance] ?? 0.0)km"
    
    // 최대 산책 시간 90분
    guard time < 5400 else { //5400
      Defaults[.recording_time] = 5400
      
      let time = Defaults[.recording_time] ?? 0
      let hour = time / 3600
      let minutes = (time % 3600) / 60
      let seconds = (time % 3600) % 60
      
      self.timeLabel.text = String(format:"%02i:%02i:%02i", hour, minutes, seconds)
      
      self.locationRequest?.cancelRequest()
      self.appDelegate.timer?.invalidate()
      self.appDelegate.timer = nil
      self.timer?.invalidate()
      self.timer = nil
      
      AJAlertController.initialization().showAlert(astrTitle: "", aStrMessage: "최대 산책기록 시간을 초과하여 산책일기 쓰기 화면으로 이동합니다.", aCancelBtnTitle: "취소", aOtherBtnTitle: "확인") { position, title in
        if position == 0 {
          Defaults[.record_idx] = nil
          Defaults[.record_type] = nil
          Defaults[.start_date] = nil
          Defaults[.recording_time] = nil
          Defaults[.totalDistance] = nil
          Defaults[.totalLocationList] = [String]()
          Defaults[.recording_address] = nil
          
          if let viewController = self.presentingViewController?.presentingViewController?.presentingViewController {
            viewController.dismiss(animated: false, completion: nil)
          } else {
            let destination = MainTabBarViewController.instantiate(storyboard: "Main")
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            window?.rootViewController = destination
          }
        } else if position == 1 {
          self.trackingRegInAPI(isCanceled: false)
        }
      }
      return
    }
    
    
  }
 
  /// 트래킹정보 저장
  func trackingRegInAPI(isCanceled: Bool) {
    let recordRequest = RecordModel()
    recordRequest.record_idx = Defaults[.record_idx]
    recordRequest.member_idx = Defaults[.member_idx]
    recordRequest.record_distant = "\(Defaults[.totalDistance] ?? 0.0)"
    recordRequest.record_hour = "\((Defaults[.recording_time] ?? 0) / 60)"
    recordRequest.record_start_date = Defaults[.start_date]?.toString(format: "yyyy-MM-dd HH:mm")
    if Defaults[.record_type] == "0" {
      recordRequest.record_addr = Defaults[.recording_address]
    }
    
    
    var locationArr = [RecordModel]()
    
    for value in Defaults[.totalLocationList]  {
      let recordModel = RecordModel()
      let location = value.components(separatedBy: ",")
      recordModel.lat = location[1]
      recordModel.lng = location[2]
      locationArr.append(recordModel)
    }
    
    recordRequest.location = locationArr.toJSONString() ?? ""
    
    APIRouter.shared.api(path: APIURL.tracking_reg_in, method: .post, parameters: recordRequest.toJSON()) { data in
      if let data = RecordModel(JSON: data), Tools.shared.isSuccessResponse(response: data) {
        self.locationRequest?.cancelRequest()
        self.appDelegate.timer?.invalidate()
        self.appDelegate.timer = nil
        self.timer?.invalidate()
        self.timer = nil
        if isCanceled {
          if let viewController = self.presentingViewController?.presentingViewController?.presentingViewController {
            viewController.dismiss(animated: false, completion: nil)
          } else {
            let destination = MainTabBarViewController.instantiate(storyboard: "Main")
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            window?.rootViewController = destination
          }
        } else {
          let destination = WalkDiaryViewController.instantiate(storyboard: "Walk")
          destination.modalPresentationStyle = .fullScreen
          destination.record_type = self.recordRequest.record_type ?? ""
          destination.record_idx = Defaults[.record_idx] ?? ""
          destination.record_diary_idx = data.record_diary_idx ?? ""
          destination.distance = self.distanceLabel.text ?? ""
          destination.time = Defaults[.recording_time] ?? 0
          self.present(destination, animated: false, completion: nil)
        }
        
        
        Defaults[.record_idx] = nil
        Defaults[.record_type] = nil
        Defaults[.start_date] = nil
        Defaults[.recording_time] = nil
        Defaults[.totalDistance] = nil
        Defaults[.totalLocationList] = [String]()
        Defaults[.recording_address] = nil
        
      }
    } fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }
  }
  
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 산책일기 쓰기
  /// - Parameter sender: UIButton
  @IBAction func writeDiaryButtonTouched(sender: UIButton) {
//    guard (Defaults[.totalLocationList].count) > 0 else {
//      AJAlertController.initialization().showAlertWithOkButton(astrTitle: "", aStrMessage: "저장할 산책 기록이 없습니다.", alertViewHiddenCheck: false) { position, title in
//
//      }
//      return
//    }

    AJAlertController.initialization().showAlert(astrTitle: "", aStrMessage: "산책을 완료하고 일기를 작성하시겠습니까?", aCancelBtnTitle: "취소", aOtherBtnTitle: "확인") { position, title in
      if position == 1 {
        self.trackingRegInAPI(isCanceled: false)
      }
    }
    
    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
  }
  /// 더보기 / 산책취소여부 선택
  /// - Parameter sender: UIButton
  @IBAction func dotButtonTouched(sender: UIButton) {
    let destination = CardPopupViewController.instantiate(storyboard: "Walk")
    destination.fromView = "walkTracking"
    destination.delegate = self
    destination.modalTransitionStyle = .crossDissolve
    destination.modalPresentationStyle = .overCurrentContext
    self.present(destination, animated: false, completion: nil)
  }
  
  /// 산책친구
  /// - Parameter sender:
  @IBAction func friendPetListButtonTouched(sender: UIButton) {
    guard self.petList.count > 0 else { return }
    let destination = FriendPetPopupViewController.instantiate(storyboard: "Walk")
  
    destination.petList = self.petList
    destination.modalTransitionStyle = .crossDissolve
    destination.modalPresentationStyle = .overCurrentContext
    self.present(destination, animated: false, completion: nil)
  }
}




//-------------------------------------------------------------------------------------------
// MARK: - SelectedCardPopupDelegate
//-------------------------------------------------------------------------------------------
extension WalkTrackingViewController: SelectedCardPopupDelegate {
  func denyTouched() {
    log.debug("denyTouched")
  }
  
  func cancelTouched() {
    log.debug("cancelTouched")
    self.trackingRegInAPI(isCanceled: true)
  }
  
  func reportTouched() {
    log.debug("reportTouched")
  }
  
  func blockTouched() {
    log.debug("blockTouched")
  }
  
  
}
