//
//  CustomerCenterViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/03.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit

class CustomerCenterViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var noticeView: UIView!
  @IBOutlet weak var faqVIew: UIView!
  @IBOutlet weak var qnaView: UIView!
  
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
    //공지사항
    self.noticeView.addTapGesture { recognizer in
      let destination = NoticeViewController.instantiate(storyboard: "More")
      self.navigationController?.pushViewController(destination, animated: true)
    }
    
    //자주 묻는 질문
    self.faqVIew.addTapGesture { recognizer in
      let destination = FaqViewController.instantiate(storyboard: "More")
      self.navigationController?.pushViewController(destination, animated: true)
    }
    
    //1:1 문의
    self.qnaView.addTapGesture { recognizer in
      let destination = QnaViewController.instantiate(storyboard: "More")
      self.navigationController?.pushViewController(destination, animated: true)
    }
  }
  
  override func initRequest() {
    super.initRequest()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  
}
