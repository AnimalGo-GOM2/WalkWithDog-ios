//
//  MyPetViewController.swift
//  animalgo
//
//  Created by rocateer on 2021/10/29.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import SkeletonView
import DZNEmptyDataSet
import Defaults

class MyPetViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var myPetTableView: UITableView!
  @IBOutlet weak var registButton: UIButton!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var myPetList = [AnimalModel]()
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(self.myPetListUpdate), name: Notification.Name("MyPetListUpdate"), object: nil)
    self.myPetTableView.registerCell(type: MyPetCell.self)
    self.myPetTableView.delegate = self
    self.myPetTableView.dataSource = self
    
    self.myPetTableView.showAnimatedSkeleton()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    self.registButton.isHidden = true
    
  }
  
  override func initRequest() {
    super.initRequest()
    self.myAnimalListAPI()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 내 반려견 리스트
  func myAnimalListAPI() {
    let animalRequest = AnimalModel()
    animalRequest.member_idx = Defaults[.member_idx]
    
    APIRouter.shared.api(path: APIURL.my_animal_list, method: .post, parameters: animalRequest.toJSON()) { data in
      if let animalResponse = AnimalModel(JSON: data), Tools.shared.isSuccessResponse(response: animalResponse) {
        if let data_array = animalResponse.data_array, data_array.count > 0 {
          self.myPetList = data_array
          self.appDelegate.myAnimalList = self.myPetList
          self.registButton.isHidden = false
        } else {
          self.registButton.isHidden = true
        }
        self.myPetTableView.emptyDataSetSource = self
        self.myPetTableView.emptyDataSetDelegate = self
        self.myPetTableView.hideSkeleton()
        self.myPetTableView.reloadData()
      }
    } fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }

  }
  
  // 내 반려견 리스트 업데이트
  @objc func myPetListUpdate() {
    self.myAnimalListAPI()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 등록하기
  /// - Parameter sender: UIButton
  @IBAction func registButtonTouched(sender: UIButton) {
    let destination = RegistPetViewController.instantiate(storyboard: "MyPet")
    destination.hidesBottomBarWhenPushed = true
    self.navigationController?.pushViewController(destination, animated: true)
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - SkeletonTableViewDataSource
//-------------------------------------------------------------------------------------------
extension MyPetViewController: SkeletonTableViewDataSource {
  func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
   return "MyPetCell"
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.myPetList.count
    
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MyPetCell", for: indexPath) as! MyPetCell
    let petData = self.myPetList[indexPath.row]
    cell.setPetData(petData: petData)

    return cell
  }
}
//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDelegate
//-------------------------------------------------------------------------------------------
extension MyPetViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let destination = RegistPetViewController.instantiate(storyboard: "MyPet")
    destination.animal_idx = self.myPetList[indexPath.row].animal_idx ?? ""
    destination.hidesBottomBarWhenPushed = true
    self.navigationController?.pushViewController(destination, animated: true)
  }
}

//-------------------------------------------------------------------------------------------
  // MARK: - DZNEmptyDataSetSource
  //-------------------------------------------------------------------------------------------
extension MyPetViewController: DZNEmptyDataSetSource {
  
  func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
    UIImage(named: "img_empty3")
  }
  
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    
    let text = "\n반려견과의 즐거운 시간을\n남기기 위해서\n먼저 반려견 정보를 등록 해주세요."
    let attributes: [NSAttributedString.Key : Any] = [
      NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18),
      NSAttributedString.Key.foregroundColor : UIColor(named: "222222")!
    ]
    
    return NSAttributedString(string: text, attributes: attributes)
  }
  
  func buttonImage(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> UIImage! {
    return UIImage(named: "btn1")!
  }
}

//-------------------------------------------------------------------------------------------
  // MARK: - DZNEmptyDataSetDelegate
  //-------------------------------------------------------------------------------------------
extension MyPetViewController: DZNEmptyDataSetDelegate {
  func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
    return false
  }
  
  func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
    let destination = RegistPetViewController.instantiate(storyboard: "MyPet")
    destination.hidesBottomBarWhenPushed = true
    self.navigationController?.pushViewController(destination, animated: true)
  }
}
