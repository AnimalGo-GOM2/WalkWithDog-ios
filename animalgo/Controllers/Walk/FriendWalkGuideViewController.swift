//
//  FriendWalkGuideViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/16.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import Defaults

class FriendWalkGuideViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var guideImageView: UIImageView!
  @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var record_idx = ""
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

  }
  
  override func initRequest() {
    super.initRequest()
    self.recordGuideAPI()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 산책 가이드
  func recordGuideAPI() {
    let recordRequest = RecordModel()
    recordRequest.record_type = "1"
    
    APIRouter.shared.api(path: APIURL.record_guide, method: .post, parameters: recordRequest.toJSON()) { data in
      if let recordResponse = RecordModel(JSON: data), Tools.shared.isSuccessResponse(response: recordResponse) {
        let image = UIImage(urlString: "\(baseURL)\(recordResponse.guide_img ?? "")") ?? UIImage()
        self.imageHeightConstraint.constant = (image.size.height * self.view.frame.size.width) / image.size.width
        self.guideImageView.sd_setImage(with: URL(string: "\(baseURL)\(recordResponse.guide_img ?? "")"), completed: nil)
      }
    } fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }

  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 가이드 닫기
  /// - Parameter sender: UIBarButtonItem
  @IBAction func closeBarButtonItemTouched(sender: UIBarButtonItem) {
    Defaults[.record_idx] = self.record_idx
    Defaults[.record_type] = "1"
    Defaults[.start_date] = Date()
    
    let destination = WalkTrackingViewController.instantiate(storyboard: "Walk")
    destination.recordRequest.record_type = "1"
    destination.modalPresentationStyle = .fullScreen
    self.present(destination, animated: false, completion: nil)
  }
}
