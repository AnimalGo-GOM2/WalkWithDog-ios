//
//  CompanyInfoViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/03.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit

class CompanyInfoViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var companyImageView: UIImageView!
  @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
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
    let height = self.view.frame.width * ( UIImage(named: "sample2")!.size.height / UIImage(named: "sample2")!.size.width )
    
    self.imageHeightConstraint.constant = height
  }
  
  override func initRequest() {
    super.initRequest()
    
    self.companyInfoAPI()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  // 회사소개 API
  func companyInfoAPI() {
    APIRouter.shared.api(path: APIURL.company_info, method: .post, parameters: nil) { response in
      if let companyResponse = MainModel(JSON: response), Tools.shared.isSuccessResponse(response: companyResponse) {
        /// 저장된 이미지 width, height 계산
        if let img_path = companyResponse.company_info {
          let image:UIImage = UIImage(urlString: "\(baseURL)\(img_path)") ?? UIImage()
          self.companyImageView.sd_setImage(with: URL(string: "\(baseURL)\(img_path)"), placeholderImage: UIImage(), options: .lowPriority, context: nil)
          self.imageHeightConstraint.constant = (image.size.height * self.view.frame.size.width) / image.size.width
        } else {
          self.imageHeightConstraint.constant = 0
        }
      }
    } fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  
}
