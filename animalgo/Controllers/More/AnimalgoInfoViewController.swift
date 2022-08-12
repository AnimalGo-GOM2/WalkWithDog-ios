//
//  AnimalgoInfoViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/03.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit

class AnimalgoInfoViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var aboutCompanyView: UIView!
  @IBOutlet weak var termsOfUseView: UIView!
  @IBOutlet weak var personalInfoView: UIView!
  @IBOutlet weak var locationInfoView: UIView!
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
    
    // 회사소개
    self.aboutCompanyView.addTapGesture { recognizer in
      let destination = CompanyInfoViewController.instantiate(storyboard: "More")
      self.navigationController?.pushViewController(destination, animated: true)
    }
    
    // 이용약관
    self.termsOfUseView.addTapGesture { recognizer in
      let destination = WebViewController.instantiate(storyboard: "Commons")
      destination.webType = .Terms0
      self.navigationController?.pushViewController(destination, animated: true)
    }
    
    // 개인정보 처리방식
    self.personalInfoView.addTapGesture { recognizer in
      let destination = WebViewController.instantiate(storyboard: "Commons")
      destination.webType = .Terms1
      self.navigationController?.pushViewController(destination, animated: true)
    }
    
    // 위치정보 이용약관
    self.locationInfoView.addTapGesture { recognizer in
      let destination = WebViewController.instantiate(storyboard: "Commons")
      destination.webType = .Terms2
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
