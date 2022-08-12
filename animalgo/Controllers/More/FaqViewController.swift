//
//  FaqViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/03.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import ExpyTableView

class FaqViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var faqTableView: ExpyTableView!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var faqList = [FaqModel]()
  var faqRequest = FaqModel()
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.faqTableView.registerCell(type: FaqCell.self)
    self.faqTableView.registerCell(type: FaqDetailCell.self)
    self.faqTableView.dataSource = self
    self.faqTableView.delegate = self
    self.faqTableView.rowHeight = UITableView.automaticDimension
    self.faqTableView.expandingAnimation = .fade
    self.faqTableView.collapsingAnimation = .fade

  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
  }
  
  override func initRequest() {
    super.initRequest()
    self.faqListAPI()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// Faq 리스트 API
   func faqListAPI() {
     self.faqRequest.setNextPage()
     APIRouter.shared.api(path: APIURL.faq_list, method: .post, parameters: self.faqRequest.toJSON()) { response in
       if let faqResponse = FaqModel(JSON: response), Tools.shared.isSuccessResponse(response: faqResponse) {
         self.faqRequest.total_page = faqResponse.total_page
         self.isLoadingList = true
         if let data_array = faqResponse.data_array, data_array.count > 0 {
           self.faqList = data_array
         }
         
         self.faqTableView.reloadData()
       }
     }fail: { error in
       Tools.shared.showToast(message: error?.localizedDescription ?? "")
     }
     
   }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  
}

extension FaqViewController: ExpyTableViewDataSource {
  func tableView(_ tableView: ExpyTableView, canExpandSection section: Int) -> Bool {
    return true
  }
  
  func tableView(_ tableView: ExpyTableView, expandableCellForSection section: Int) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FaqCell") as! FaqCell
    let faqData = self.faqList[section]
    
    var type = ""
    
    if faqData.faq_type == "0" {
      type = "[회원서비스]"
    } else if faqData.faq_type == "1" {
      type = "[산책하기]"
    } else if faqData.faq_type == "2" {
      type = "[산책기록]"
    } else if faqData.faq_type == "3" {
      type = "[앱사용]"
    } else if faqData.faq_type == "4" {
      type = "[기타]"
    }
      
    cell.titleLabel.text = "\(type) \(faqData.title ?? "")"
    
    cell.layoutMargins = UIEdgeInsets.zero
    return cell
  }
  
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return self.faqList.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  
  
  func canExpand(section: Int, inTableView tableView: ExpyTableView) -> Bool {
    return true
  }
  
  // 상위 데이터
  func expandableCell(forSection section: Int, inTableView tableView: ExpyTableView) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FaqCell") as! FaqCell
    return cell
  }
  
  // 하위 데이터
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FaqDetailCell", for: indexPath) as! FaqDetailCell
    let faqData = self.faqList[indexPath.section]
    cell.contentsLabel.text = faqData.contents
    if faqData.img.isNil {
      cell.imageHeightConstraint.constant = 0
    } else {
      let image:UIImage = UIImage(urlString: "\(baseURL)\(faqData.img ?? "")") ?? UIImage()
      cell.faqImageView.sd_setImage(with: URL(string: "\(baseURL)\(faqData.img ?? "")"), placeholderImage: UIImage(), options: .lowPriority, context: nil)
      cell.imageHeightConstraint.constant = (image.size.height * self.view.frame.size.width) / image.size.width
    }
    
    return cell
  }
  
  
}

//-------------------------------------------------------------------------------------------
// MARK: - ExpyTableViewDelegate
//-------------------------------------------------------------------------------------------
extension FaqViewController: ExpyTableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: ExpyTableView, expyState state: ExpyState, changeForSection section: Int) {
    
    switch state {
    case .willExpand:
      
      break
    case .willCollapse:
      break
    case .didExpand:
      break
    case .didCollapse:
      break
    }
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
      if scrollView == self.faqTableView {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if maximumOffset - currentOffset <= 10.0 {
          if self.faqRequest.isMore() && self.isLoadingList {
            self.isLoadingList = false
            self.faqListAPI()
          }
        }
      }
    }
  
}


