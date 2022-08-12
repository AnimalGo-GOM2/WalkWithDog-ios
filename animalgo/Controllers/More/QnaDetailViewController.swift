//
//  QnaDetailViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/04.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import SkeletonView

class QnaDetailViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var deleteBarButtonItem: UIBarButtonItem!
  @IBOutlet weak var qnaTitleLable: UILabel!
  @IBOutlet weak var qnaDateLabel: UILabel!
  @IBOutlet weak var qnaContentsLabel: UILabel!
  @IBOutlet weak var replyTitleLabel: UILabel!
  @IBOutlet weak var replyDateLabel: UILabel!
  @IBOutlet weak var replyContentsLabel: UILabel!
  @IBOutlet weak var replyView: UIView!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var qnaData = QnaModel()
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.deleteBarButtonItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor(named: "accent")!], for: .normal)
    self.deleteBarButtonItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor(named: "accent")!], for: .selected)
    
    let category = QNA_CATEGORY_LIST[Int(self.qnaData.qa_category ?? "") ?? 0]
    
    self.qnaTitleLable.text = "[\(category)]\(self.qnaData.qa_title ?? "")"
    self.qnaDateLabel.text = self.qnaData.ins_date
    self.qnaContentsLabel.text = self.qnaData.qa_contents
    
    
    if self.qnaData.reply_yn == "Y" {
      self.replyView.isHidden = false
      self.replyContentsLabel.text = self.qnaData.reply_contents
      self.replyDateLabel.text = self.qnaData.reply_date
    } else {
      self.replyView.isHidden = true
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    
    
  }
  
  override func initRequest() {
    super.initRequest()
    self.qnaDetailAPI()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// qna 상세 API
  func qnaDetailAPI() {
    let qnaRequest = QnaModel()
    qnaRequest.qa_idx = self.qnaData.qa_idx
    
    APIRouter.shared.api(path: .qa_detail, parameters: qnaRequest.toJSON()) { response in
      if let qnaResponse = QnaModel(JSON: response), Tools.shared.isSuccessResponse(response: qnaResponse) {
        self.qnaDateLabel.text = qnaResponse.ins_date
        self.qnaContentsLabel.text = qnaResponse.qa_contents
        if qnaResponse.reply_yn == "Y" {
          self.replyView.isHidden = false
          self.replyDateLabel.text = qnaResponse.reply_date ?? ""
          self.replyContentsLabel.text = qnaResponse.reply_contents ?? ""
        } else {
          self.replyView.isHidden = true
        }
      }
    } fail: { error in
      Tools.shared.showToast(message: "알수 없는 오류가 발생하였습니다.")
    }
  }
  
  /// qna 삭제 API
  func qnaDeleteAPI() {
    let qnaRequest = QnaModel()
    qnaRequest.qa_idx = self.qnaData.qa_idx
    
    APIRouter.shared.api(path: .qa_del, parameters: qnaRequest.toJSON()) { response in
      if let qnaResponse = QnaModel(JSON: response), Tools.shared.isSuccessResponse(response: qnaResponse) {
        NotificationCenter.default.post(name: Notification.Name("qnaUpdate"), object: nil)
        self.navigationController?.popViewController(animated: true)
      }
    } fail: { error in
      Tools.shared.showToast(message: "알수 없는 오류가 발생하였습니다.")
    }
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  
  /// 삭제 버튼
  /// - Parameter sender: UIBarButtonItem
  @IBAction func deleteBarButtonItemTouched(sender: UIBarButtonItem) {
    AJAlertController.initialization().showAlert(astrTitle: "", aStrMessage: "삭제 하시겠습니까?", aCancelBtnTitle: "취소", aOtherBtnTitle: "확인") { position, title in
      if position == 1 {
        self.qnaDeleteAPI()
      }
    }
    
  }
}
