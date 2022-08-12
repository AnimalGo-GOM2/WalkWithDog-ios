//
//  SelMyPetViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/08.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import SkeletonView
import Defaults

class SelMyPetViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var petListTableView: UITableView!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var startWalkButton: UIButton!
  @IBOutlet weak var backBarButtonItem: UIBarButtonItem!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var record_type = "0" // 산책구분(0:나와반려건,1:산책친구와함께)
  var myPetList = [AnimalModel]()
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
    
    self.cancelButton.setCornerRadius(radius: 10)
    self.startWalkButton.setCornerRadius(radius: 10)
    
    self.petListTableView.registerCell(type: MyPetButtonCell.self)
    self.petListTableView.delegate = self
    self.petListTableView.dataSource = self
    
    if self.record_type == "1" {
      self.startWalkButton.titleLabel?.text = "다음"
      self.navigationItem.title = "산책친구 등록"
      self.backBarButtonItem.tintColor = .clear
      self.backBarButtonItem.isEnabled = false
    } else {
      self.startWalkButton.setTitle("산책 시작", for: .normal)
    }
    
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
        }
        self.petListTableView.reloadData()
      }
    } fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }
    
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 취소
  /// - Parameter sender: UIButton
  @IBAction func cancelButtonTouched(sender: UIButton) {
    if self.record_type == "1" {
      self.dismiss(animated: true, completion: nil)
    } else {
      AJAlertController.initialization().showAlert(astrTitle: "", aStrMessage: "정말 산책을 취소하시겠습니까?", aCancelBtnTitle: "아니오", aOtherBtnTitle: "예") { position, title in
        if position == 1 {
          self.dismiss(animated: true, completion: nil)
        }
      }
    }
  }
  /// 산책시작 / 다음
  /// - Parameter sender: UIButton
  @IBAction func startWalkButtonTouched(sender: UIButton) {
    let recordRequest = RecordModel()
    var member_animal_idxs = [String]()
    for value in self.myPetList {
      if value.isSelected ?? false {
        member_animal_idxs.append(value.animal_idx ?? "")
      }
    }
    recordRequest.member_animal_idxs = member_animal_idxs.joined(separator: ",")
    recordRequest.record_type = self.record_type
     
    
    guard (member_animal_idxs.count) > 0 else {
      AJAlertController.initialization().showAlertWithOkButton(astrTitle: "", aStrMessage: "함께 산책 할 반려견을 선택하여 주세요.", alertViewHiddenCheck: false) { position, title in
        
      }
      return
    }
    
    Defaults[.start_date] = Date()
    if self.record_type == "1" {
      let destination = WalkTimeSelectViewController.instantiate(storyboard: "Walk").coverNavigationController()
      if let firstViewController = destination.viewControllers.first {
        let viewController = firstViewController as! WalkTimeSelectViewController
        viewController.recordRequest = recordRequest
      }
      destination.hero.isEnabled = false
      destination.hero.modalAnimationType = .autoReverse(presenting: .cover(direction: .left))
      destination.modalPresentationStyle = .fullScreen
      self.present(destination, animated: true, completion: nil)
    } else {
      let destination = WalkGuideViewController.instantiate(storyboard: "Walk").coverNavigationController()
      destination.modalPresentationStyle = .fullScreen
      if let firstViewController = destination.viewControllers.first {
        let viewController = firstViewController as! WalkGuideViewController
        viewController.recordRequest = recordRequest
      }
      self.present(destination, animated: true, completion: nil)
    }
    
  }
}



//-------------------------------------------------------------------------------------------
// MARK: - SkeletonTableViewDataSource
//-------------------------------------------------------------------------------------------
extension SelMyPetViewController: SkeletonTableViewDataSource {
  func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 20
  }
  func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
   return "MyPetButtonCell"
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.myPetList.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MyPetButtonCell", for: indexPath) as! MyPetButtonCell
    guard self.myPetList.count > 0 else { return cell }
    let petData = self.myPetList[indexPath.row]
    cell.setPetData(petData: petData)
    
    // 반려견 선택
    cell.petButton.addTapGesture { recognizer in
      petData.isSelected = !(petData.isSelected ?? false)
      self.petListTableView.reloadRows(at: [indexPath], with: .none)
    }

    return cell
  }
}
//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDelegate
//-------------------------------------------------------------------------------------------
extension SelMyPetViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
}
