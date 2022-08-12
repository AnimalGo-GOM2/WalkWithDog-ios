//
//  QnaRegistViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/03.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import DropDown
import Defaults

class QnaRegistViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var registButton: UIButton!
  @IBOutlet weak var contentsTextView: UITextView!
  @IBOutlet weak var contentsLabel: UILabel!
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var categoryView: UIView!
  @IBOutlet weak var categoryTextField: UITextField!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  let dropDown = DropDown()
  var type = 0
  let categoryList = QNA_CATEGORY_LIST
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.contentsTextView.delegate = self
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    self.registButton.setCornerRadius(radius: 10)
    self.categoryTextField.addBorderBottom(size: 1, color: UIColor(named: "EAE8E5")!)
    self.titleTextField.addBorderBottom(size: 1, color: UIColor(named: "EAE8E5")!)
    
    self.categoryView.addTapGesture { recognizer in
      self.dropDown.show()
      self.dropDown.dataSource = self.categoryList
      self.customizeDropDown(self)
      self.dropDown.reloadAllComponents()
    }
  }
  
  override func initRequest() {
    super.initRequest()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 1:1문의 등록 API
  func qnaRegAPI() {
    let qnaRequest = QnaModel()
    qnaRequest.member_idx = Defaults[.member_idx]
    qnaRequest.qa_title = self.titleTextField.text
    qnaRequest.qa_contents = self.contentsTextView.text
    qnaRequest.qa_type = "0"
    qnaRequest.qa_category = "\(self.type)"
    
    APIRouter.shared.api(path: .qa_reg_in, parameters: qnaRequest.toJSON()) { response in
      if let qnaResponse = QnaModel(JSON: response), Tools.shared.isSuccessResponse(response: qnaResponse) {
        AJAlertController.initialization().showAlertWithOkButton(astrTitle: "", aStrMessage: "문의가 등록되었습니다.", alertViewHiddenCheck: false){
          (position, title) in
          if position == 0 {
            NotificationCenter.default.post(name: Notification.Name("qnaUpdate"), object: nil)
            self.dismiss(animated: true)
          }
        }
      }
    } fail: { error in
      Tools.shared.showToast(message: "알수 없는 오류가 발생하였습니다.")
    }
  }
  
  /// 드롭다운 세팅
  /// - Parameter sender: self
  func customizeDropDown(_ sender: AnyObject) {
    DropDown.appearance().cornerRadius = 4
    DropDown.appearance().direction = .bottom
    DropDown.appearance().shadowColor = UIColor(named: "707070")!
    DropDown.appearance().cellHeight = 44
    dropDown.width = self.categoryTextField.frame.width

    self.dropDown.anchorView = self.categoryView
    self.dropDown.bottomOffset = CGPoint(x: 0, y: 45)
    self.dropDown.shadowOpacity = 1
    self.dropDown.shadowOffset = CGSize(width: 0, height: 0)
    
    self.dropDown.backgroundColor = .white
    self.dropDown.dataSource = self.categoryList
    self.dropDown.cellNib = UINib(nibName: "TextDropDownCell", bundle: nil)
    
    
    self.dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
      guard let cell = cell as? TextDropDownCell else { return }
      cell.titleLabel.text = item
      cell.optionLabel.isHidden = true
    }
    
    self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
      self.categoryTextField.text = self.categoryList[index]
      self.type = index
    }
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 문의하기
  /// - Parameter sender: UIButton
  @IBAction func RegistButtonTouched(sender: UIButton) {
    self.qnaRegAPI()
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UITextViewDelegate
//-------------------------------------------------------------------------------------------
extension QnaRegistViewController: UITextViewDelegate{
  
  func textViewDidChange(_ textView: UITextView) {
    if textView.text?.count ?? 0 > 0{
      self.contentsLabel.isHidden = true
    }else{
      self.contentsLabel.isHidden = false
    }
  }
  
}
