//
//  SuggestionViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/04.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import Defaults

class SuggestionViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var goodButton: UIButton!
  @IBOutlet weak var needNewButton: UIButton!
  @IBOutlet weak var needImprovementButton: UIButton!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------

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
    
    self.goodButton.setCornerRadius(radius: 10)
    self.needNewButton.setCornerRadius(radius: 10)
    self.needImprovementButton.setCornerRadius(radius: 10)
    self.goodButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.needNewButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.needImprovementButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
  }
  
  override func initRequest() {
    super.initRequest()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 의견 보내기 API
  func suggestionSendAPI() {
    let suggestionRequest = QnaModel()
    suggestionRequest.member_idx = Defaults[.member_idx]
    suggestionRequest.qa_type = "1"
    suggestionRequest.qa_category = "10"
    
    APIRouter.shared.api(path: APIURL.qa_reg_in, parameters: suggestionRequest.toJSON()) { response in
      if let suggestionResponse = QnaModel(JSON: response), Tools.shared.isSuccessResponse(response: suggestionResponse) {
        AJAlertController.initialization().showAlertWithOkButton(astrTitle: "", aStrMessage: "회원님! 참여해주셔서 감사합니다.", alertViewHiddenCheck: false) { (position, title) in
          if position == 0 {
            self.dismiss(animated: true, completion: nil)
          }
        }
      }
    } fail: { error in
      Tools.shared.showToast(message: "알수 없는 오류가 발생하였습니다.")
    }
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 지금도 좋아요
  /// - Parameter sender: UIButton
  @IBAction func goodButtonTouched(sender:UIButton) {
    self.suggestionSendAPI()
  }
  
  ///  새로운 기능이 필요해요.
  /// - Parameter sender: UIButton
  @IBAction func needNewButtonTouched(sender:UIButton) {
    let destination = SuggestionSendViewController.instantiate(storyboard: "More")
    destination.qa_category = "11"
    self.navigationController?.pushViewController(destination, animated: true)
  }
  
  /// 개선이 필요해요.
  /// - Parameter sender: UIButton
  @IBAction func needImprovementButtonTouched(sender:UIButton) {
    let destination = SuggestionSendViewController.instantiate(storyboard: "More")
    destination.qa_category = "12"
    self.navigationController?.pushViewController(destination, animated: true)
  }
}
