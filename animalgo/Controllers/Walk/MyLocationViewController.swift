//
//  MyLocationViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/09.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import NMapsMap
import Defaults

protocol SetMyLocationDelegate {
  func setMyLocationDelegate(recordRequest: RecordModel)
}

class MyLocationViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var mapView: NMFMapView!
  @IBOutlet weak var topView: UIView!
  @IBOutlet weak var underView: UIView!
  @IBOutlet weak var myLocationButton: UIButton!
  @IBOutlet weak var confirmButton: UIButton!
  @IBOutlet weak var topLabel: UILabel!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var backBarButtonItem: UIBarButtonItem!
  @IBOutlet weak var addressLabel: UILabel!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var fromView = ""
  var recordRequest = RecordModel()
  let marker = NMFMarker()
  var delegate: SetMyLocationDelegate?
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
    if self.fromView == "WalkTimeSelect" {
      self.cancelButton.isHidden = false
      self.confirmButton.setTitle("다음", for: .normal)
      self.topLabel.text = "산책 시작위치를 설정하세요."
      self.navigationItem.title = "산책친구 등록"
      self.backBarButtonItem.image = UIImage()
    } else if self.fromView == "WithFriendList" {
      self.cancelButton.isHidden = true
      DispatchQueue.main.async {
        self.confirmButton.setTitle("이 위치로 설정", for: .normal)
      }
      
      self.topLabel.text = "산책 시작위치를 설정하세요."
      self.navigationItem.title = "산책 시작위치 설정"
      self.backBarButtonItem.image = UIImage(named: "head_btn_back")
    }
    
    self.topView.backgroundColor = UIColor(white: 0, alpha: 0.34)
    
    self.underView.layer.shadowRadius = 3
    self.underView.layer.shadowOpacity = 0.29
    self.underView.layer.shadowColor = UIColor(named: "000000")!.cgColor
    self.underView.layer.shadowOffset = CGSize(width: 0, height: 1)
    
    self.underView.layer.masksToBounds = false
    self.cancelButton.setCornerRadius(radius: 10)
    self.confirmButton.setCornerRadius(radius: 10)
    self.setLocationToSettedLocation()
  }
  
  override func initRequest() {
    super.initRequest()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 맵 세팅
  func setLocation() {
    let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: Defaults[.currentLat] ?? 37.56638274705945, lng: Defaults[.currentLng] ?? 126.97794372508841), zoomTo: 17)
    self.mapView.moveCamera(cameraUpdate)
    self.mapView.addCameraDelegate(delegate: self)
    self.startReversegeocodeAPI(lat: "\(self.mapView.cameraPosition.target.lat)", lng: "\(self.mapView.cameraPosition.target.lng)")
  }
  
  func setLocationToSettedLocation() {
    let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: self.recordRequest.record_lat?.toDouble() ?? Defaults[.currentLat] ?? 37.56638274705945, lng: self.recordRequest.record_lng?.toDouble() ?? Defaults[.currentLng] ?? 126.97794372508841), zoomTo: 17)
    self.mapView.moveCamera(cameraUpdate)
    self.mapView.addCameraDelegate(delegate: self)
    self.startReversegeocodeAPI(lat: "\(self.mapView.cameraPosition.target.lat)", lng: "\(self.mapView.cameraPosition.target.lng)")
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
          } else {
            self.addressLabel.text = ""
          }
        } else {
          self.addressLabel.text = ""
        }
      }
      
    } fail: { error in
      AJAlertController.initialization().showAlertWithOkButton(astrTitle: "", aStrMessage: "\(error?.localizedDescription ?? "")", alertViewHiddenCheck: false) { position, title in
        
      }
      
    }

  }
  
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 완료버튼
  /// - Parameter sender: UIButton
  @IBAction func confimButtonTouched(sender: UIButton) {
    self.recordRequest.record_addr = self.addressLabel.text
    self.recordRequest.record_lat = "\(self.mapView.cameraPosition.target.lat)"
    self.recordRequest.record_lng = "\(self.mapView.cameraPosition.target.lng)"
//    Defaults[.currentLat] = self.mapView.cameraPosition.target.lat
//    Defaults[.currentLng] = self.mapView.cameraPosition.target.lng
    
    if self.fromView == "WithFriendList" {
      
      self.navigationController?.popViewController(animated: true)
      self.delegate?.setMyLocationDelegate(recordRequest: self.recordRequest)
    } else {
      let vc = RegistPetFilterViewController.instantiate(storyboard: "Walk")
      vc.recordRequest = self.recordRequest
      let destination = vc.coverNavigationController()
      destination.hero.isEnabled = false
      destination.hero.modalAnimationType = .autoReverse(presenting: .cover(direction: .left))
      destination.modalPresentationStyle = .fullScreen
      self.present(destination, animated: true, completion: nil)
    }
    
  }
  /// 취소
  /// - Parameter sender: UIButton
  @IBAction func cancelButton(sender: UIButton) {
    self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
  }
  /// 내위치 버튼
  /// - Parameter sender: UIButton
  @IBAction func myLocationButtonTouched(sender: UIButton) {
    self.setLocation()
  }
}


//-------------------------------------------------------------------------------------------
// MARK: - NMFMapViewCameraDelegate
//-------------------------------------------------------------------------------------------
extension MyLocationViewController: NMFMapViewCameraDelegate {
  func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
    if animated {
      self.startReversegeocodeAPI(lat: "\(mapView.cameraPosition.target.lat)", lng: "\(mapView.cameraPosition.target.lng)")
    }
  }
}
