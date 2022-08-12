//
//  SuggestionSendViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/04.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import Defaults

class SuggestionSendViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subLabel: UILabel!
  @IBOutlet weak var contentsLabel: UILabel!
  @IBOutlet weak var contentsTextView: UITextView!
  @IBOutlet weak var sendButton: UIButton!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var qa_category = ""
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
    
    self.sendButton.setCornerRadius(radius: 10)
    
    self.contentsTextView.delegate = self
    self.contentsTextView.textContainerInset = UIEdgeInsets(top: 16 , left: 0, bottom: 0, right: 0)
    
    if self.qa_category == "11" {
      self.titleLabel.text = "어떤 기능이 필요한지 알려주세요."
      self.subLabel.text = "회원님의 의견을 적극 반영 하겠습니다."
    } else {
      self.titleLabel.text = "진심으로 사과드립니다."
      self.subLabel.text = "불쾌한 점, 고쳐야 할 점을 알려주시면 개선해 나가겠습니다."
    }
    
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
    suggestionRequest.qa_category = self.qa_category
    suggestionRequest.qa_contents = self.contentsTextView.text
    
    APIRouter.shared.api(path: APIURL.qa_reg_in, parameters: suggestionRequest.toJSON()) { response in
      if let suggestionResponse = QnaModel(JSON: response), Tools.shared.isSuccessResponse(response: suggestionResponse) {
        AJAlertController.initialization().showAlertWithOkButton(astrTitle: "", aStrMessage: "회원님의 소중한 의견을 애니멀고 산책 개선에 적극적으로 반영하겠습니다. 감사합니다.", alertViewHiddenCheck: false) { (position, title) in
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
  /// 보내기
  /// - Parameter sender: UIButton
  @IBAction func sendButtonTouched(sender: UIButton!) {
    self.suggestionSendAPI()
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UITextViewDelegate
//-------------------------------------------------------------------------------------------
extension SuggestionSendViewController: UITextViewDelegate{
  
  func textViewDidChange(_ textView: UITextView) {
    if textView.text?.count ?? 0 > 0{
      self.contentsLabel.isHidden = true
    }else{
      self.contentsLabel.isHidden = false
    }
  }
  
}
