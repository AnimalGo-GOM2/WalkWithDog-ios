//
//  WalkGuideViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/08.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit

class WalkGuideViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var guideImageView: UIImageView!
  @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var previousButton: UIButton!
  @IBOutlet weak var startWalkButton: UIButton!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var recordRequest = RecordModel()
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
    self.previousButton.setCornerRadius(radius: 10)
    self.startWalkButton.setCornerRadius(radius: 10)
    self.recordRequest.record_type = "0"
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
    
    APIRouter.shared.api(path: APIURL.record_guide, method: .post, parameters: self.recordRequest.toJSON()) { data in
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
  /// 이전
  /// - Parameter sender: UIButton
  @IBAction func previousButtonTouched(sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
  /// 산책시작
  /// - Parameter sender: UIButton
  @IBAction func startWalkButtonTouched(sender: UIButton) {
    let destination = WalkTrackingViewController.instantiate(storyboard: "Walk")
    destination.recordRequest = self.recordRequest
    destination.modalPresentationStyle = .fullScreen
    self.present(destination, animated: false, completion: nil)
  }
}

