//
//  FriendFilterViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/08.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit

protocol FriendFilterDelegate {
  func friendFilterDelegate(filterModel: RecordModel, selectBreedList: [AnimalModel])
}

class FriendFilterViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  
  @IBOutlet weak var allBreedButton: UIButton!
  @IBOutlet weak var findBreedButton: UIButton!
  @IBOutlet weak var genderMButton: UIButton!
  @IBOutlet weak var genderFButton: UIButton!
  @IBOutlet weak var genderNoMatterButton: UIButton!
  @IBOutlet weak var neutralOButton: UIButton!
  @IBOutlet weak var neutralXButton: UIButton!
  @IBOutlet weak var neutralNoMatterButton: UIButton!
  @IBOutlet weak var gentleButton: UIButton!
  @IBOutlet weak var biteButton: UIButton!
  @IBOutlet weak var curiosButton: UIButton!
  @IBOutlet weak var activeButton: UIButton!
  @IBOutlet weak var personalityNoMatterButton: UIButton!
  @IBOutlet weak var ownerGenderMButton: UIButton!
  @IBOutlet weak var ownerGenderFButton: UIButton!
  @IBOutlet weak var ownerGenderNoMatterButton: UIButton!
  @IBOutlet weak var age20thButton: UIButton!
  @IBOutlet weak var age30thButton: UIButton!
  @IBOutlet weak var age40thButton: UIButton!
  @IBOutlet weak var age50thButton: UIButton!
  @IBOutlet weak var ageNoMatterButton: UIButton!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var saveButton: UIButton!
  @IBOutlet weak var selBreedCollectionView: UICollectionView!
  @IBOutlet weak var selBreedView: UIView!
  @IBOutlet weak var selBreedHeightConstraint: NSLayoutConstraint!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var breedList = [AnimalModel]() // 선택한 견종 리스트

  
  var filterRequest = RecordModel()
  var delegate: FriendFilterDelegate?
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    self.selBreedCollectionView.registerCell(type: FilterBreedCell.self)
    self.selBreedCollectionView.delegate = self
    self.selBreedCollectionView.dataSource = self
    
    self.selBreedCollectionView.collectionViewLayout = CollectionViewLeftAlignFlowLayout()
    if let flowLayout = self.selBreedCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
    
    if self.filterRequest.second_category_idx == "" || self.filterRequest.second_category_idx == nil {
      self.allBreedButton.isSelected = true
      self.selBreedView.isHidden = true
    } else {
      self.allBreedButton.isSelected = false
      self.selBreedView.isHidden = false
      
      self.selBreedCollectionView.reloadData()
      
      self.selBreedCollectionView.performBatchUpdates(nil, completion: {
        (result) in
        self.selBreedHeightConstraint.constant = self.selBreedCollectionView.collectionViewLayout.collectionViewContentSize.height
      })
    }
    
    self.genderNoMatterButton.isSelected = true
    self.neutralNoMatterButton.isSelected = true
    self.personalityNoMatterButton.isSelected = true
    self.ownerGenderNoMatterButton.isSelected = true
    self.ageNoMatterButton.isSelected = true
    
    
    self.genderMButton.isSelected = self.filterRequest.animal_gender == "0"
    self.genderFButton.isSelected = self.filterRequest.animal_gender == "1"
    self.genderNoMatterButton.isSelected = self.filterRequest.animal_gender == "" || self.filterRequest.animal_gender == nil
    
    self.neutralOButton.isSelected = self.filterRequest.animal_neuter == "0"
    self.neutralXButton.isSelected = self.filterRequest.animal_neuter == "1"
    self.neutralNoMatterButton.isSelected = self.filterRequest.animal_neuter == "" || self.filterRequest.animal_neuter == nil
    
    self.gentleButton.isSelected = self.filterRequest.animal_character == "0"
    self.biteButton.isSelected = self.filterRequest.animal_character == "1"
    self.curiosButton.isSelected = self.filterRequest.animal_character == "2"
    self.activeButton.isSelected = self.filterRequest.animal_character == "3"
    self.personalityNoMatterButton.isSelected = self.filterRequest.animal_character == "" || self.filterRequest.animal_character == nil

    self.ownerGenderMButton.isSelected = self.filterRequest.guardian_gender == "0"
    self.ownerGenderFButton.isSelected = self.filterRequest.guardian_gender == "1"
    self.ownerGenderNoMatterButton.isSelected = self.filterRequest.guardian_gender == "" || self.filterRequest.guardian_gender == nil
    
    self.age20thButton.isSelected = self.filterRequest.guardian_age == "20"
    self.age30thButton.isSelected = self.filterRequest.guardian_age == "30"
    self.age40thButton.isSelected = self.filterRequest.guardian_age == "40"
    self.age50thButton.isSelected = self.filterRequest.guardian_age == "50"
    self.ageNoMatterButton.isSelected = self.filterRequest.guardian_age == "" || self.filterRequest.guardian_age == nil
    self.setButtonUI()
   
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    self.genderFButton.setCornerRadius(radius: 10)
    self.genderMButton.setCornerRadius(radius: 10)
    self.genderNoMatterButton.setCornerRadius(radius: 10)
    self.neutralOButton.setCornerRadius(radius: 10)
    self.neutralXButton.setCornerRadius(radius: 10)
    self.neutralNoMatterButton.setCornerRadius(radius: 10)
    self.gentleButton.setCornerRadius(radius: 10)
    self.biteButton.setCornerRadius(radius: 10)
    self.curiosButton.setCornerRadius(radius: 10)
    self.activeButton.setCornerRadius(radius: 10)
    self.personalityNoMatterButton.setCornerRadius(radius: 10)
    self.ownerGenderFButton.setCornerRadius(radius: 10)
    self.ownerGenderMButton.setCornerRadius(radius: 10)
    self.ownerGenderNoMatterButton.setCornerRadius(radius: 10)
    self.age20thButton.setCornerRadius(radius: 10)
    self.age30thButton.setCornerRadius(radius: 10)
    self.age40thButton.setCornerRadius(radius: 10)
    self.age50thButton.setCornerRadius(radius: 10)
    self.ageNoMatterButton.setCornerRadius(radius: 10)
    self.cancelButton.setCornerRadius(radius: 10)
    self.saveButton.setCornerRadius(radius: 10)
    
    self.genderFButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.genderMButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.genderNoMatterButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.neutralOButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.neutralXButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.neutralNoMatterButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.gentleButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.biteButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.curiosButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.activeButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.personalityNoMatterButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.ownerGenderFButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.ownerGenderMButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.ownerGenderNoMatterButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.age20thButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.age30thButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.age40thButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.age50thButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.ageNoMatterButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    
    
  }
  
  override func initRequest() {
    super.initRequest()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  // 선택된 버튼 색변경
  func selectedButtonColor(button: UIButton){
    if button.isSelected {
      button.addBorder(width: 2, color: UIColor(named: "accent")!)
      button.backgroundColor = UIColor(named: "F7FEFC")!
    } else {
      button.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
      button.backgroundColor = UIColor.white
    }
  }
  
  // 버튼 선택 여부에 따라 세팅
  func setButtonUI() {
    self.selectedButtonColor(button: self.genderMButton)
    self.selectedButtonColor(button: self.genderFButton)
    self.selectedButtonColor(button: self.genderNoMatterButton)
    self.selectedButtonColor(button: self.neutralOButton)
    self.selectedButtonColor(button: self.neutralXButton)
    self.selectedButtonColor(button: self.neutralNoMatterButton)
    self.selectedButtonColor(button: self.gentleButton)
    self.selectedButtonColor(button: self.biteButton)
    self.selectedButtonColor(button: self.curiosButton)
    self.selectedButtonColor(button: self.activeButton)
    self.selectedButtonColor(button: self.personalityNoMatterButton)
    self.selectedButtonColor(button: self.ownerGenderMButton)
    self.selectedButtonColor(button: self.ownerGenderNoMatterButton)
    self.selectedButtonColor(button: self.ownerGenderFButton)
    self.selectedButtonColor(button: self.age20thButton)
    self.selectedButtonColor(button: self.age30thButton)
    self.selectedButtonColor(button: self.age40thButton)
    self.selectedButtonColor(button: self.age50thButton)
    self.selectedButtonColor(button: self.ageNoMatterButton)
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 모든견종
  /// - Parameter sender: UIButton
  @IBAction func allBreedButtonTouched(sender: UIButton) {
    sender.isSelected = !sender.isSelected
    
    if sender.isSelected {
      self.breedList = [AnimalModel]()
      self.selBreedView.isHidden = true
      
      
      self.selBreedCollectionView.reloadData()
      
      self.selBreedCollectionView.performBatchUpdates(nil, completion: {
        (result) in
        self.selBreedHeightConstraint.constant = self.selBreedCollectionView.collectionViewLayout.collectionViewContentSize.height
      })
      
    } else {
      self.selBreedView.isHidden = false
    }
    
  }
   /// 성별 선택
  /// - Parameter sender: UIButton
  @IBAction func genderButtonTouched(sender:UIButton) {
    self.genderMButton.isSelected = false
    self.genderFButton.isSelected = false
    self.genderNoMatterButton.isSelected = false
    
    if sender == self.genderMButton {
      self.genderMButton.isSelected = true
    } else if sender == self.genderFButton {
      self.genderFButton.isSelected = true
    } else {
      self.genderNoMatterButton.isSelected = true
    }
    self.setButtonUI()
  }
  
  /// 중성화 여부 선택
  /// - Parameter sender: UIButton
  @IBAction func neutralButtonTouched(sender:UIButton) {
    self.neutralOButton.isSelected = false
    self.neutralXButton.isSelected = false
    self.neutralNoMatterButton.isSelected = false
    
    if sender == self.neutralOButton {
      self.neutralOButton.isSelected = true
    } else if sender == self.neutralXButton {
      self.neutralXButton.isSelected = true
    } else {
      self.neutralNoMatterButton.isSelected = true
    }
    self.setButtonUI()
  }
  
  /// 성격선택
  /// - Parameter sender: UIButton
  @IBAction func personalityButtonTouched(sender: UIButton) {
    self.gentleButton.isSelected = false
    self.biteButton.isSelected = false
    self.curiosButton.isSelected = false
    self.activeButton.isSelected = false
    self.personalityNoMatterButton.isSelected = false
    
    if sender == self.gentleButton {
      self.gentleButton.isSelected = true
    } else if sender == self.biteButton {
      self.biteButton.isSelected = true
    } else if sender == self.curiosButton {
      self.curiosButton.isSelected = true
    } else if sender == self.activeButton {
      self.activeButton.isSelected = true
    } else {
      self.personalityNoMatterButton.isSelected = true
      
    }
    self.setButtonUI()
  }
  
  /// 보호자 성별 선택
  /// - Parameter sender: UIButton
  @IBAction func ownerGenderButtonTouched(sender:UIButton) {
    self.ownerGenderMButton.isSelected = false
    self.ownerGenderFButton.isSelected = false
    self.ownerGenderNoMatterButton.isSelected = false
    
    if sender == self.ownerGenderMButton {
      self.ownerGenderMButton.isSelected = true
    } else if sender == self.ownerGenderFButton {
      self.ownerGenderFButton.isSelected = true
    } else {
      self.ownerGenderNoMatterButton.isSelected = true
    }
    self.setButtonUI()
  }
  
  /// 보호자 나이
  /// - Parameter sender: UIButton
  @IBAction func ageButtonTouched(sender: UIButton) {
    self.age20thButton.isSelected = false
    self.age30thButton.isSelected = false
    self.age40thButton.isSelected = false
    self.age50thButton.isSelected = false
    self.ageNoMatterButton.isSelected = false
    
    if sender == self.age20thButton {
      self.age20thButton.isSelected = true
    } else if sender == self.age30thButton {
      self.age30thButton.isSelected = true
    } else if sender == self.age40thButton {
      self.age40thButton.isSelected = true
    } else if sender == self.age50thButton {
      self.age50thButton.isSelected = true
    } else {
      self.ageNoMatterButton.isSelected = true
    }
    
    self.setButtonUI()
  }
  
  /// 견종찾기
  /// - Parameter sender: UIButton
  @IBAction func findBreedButtonTouched(sender: UIButton) {
    let destination = FindBreedViewController.instantiate(storyboard: "Walk")
    destination.selectBreedList = self.breedList
    destination.delegate = self
    self.navigationController?.pushViewController(destination, animated: true)
  }
  
  
  /// 초기화
  /// - Parameter sender: 버튼
  @IBAction func resetBarButtonTouched(sender: UIBarButtonItem) {
    self.genderMButton.isSelected = false
    self.genderFButton.isSelected = false
    self.genderNoMatterButton.isSelected = true
    self.neutralOButton.isSelected = false
    self.neutralXButton.isSelected = false
    self.neutralNoMatterButton.isSelected = true
    self.gentleButton.isSelected = false
    self.biteButton.isSelected = false
    self.curiosButton.isSelected = false
    self.activeButton.isSelected = false
    self.personalityNoMatterButton.isSelected = true
    self.ownerGenderMButton.isSelected = false
    self.ownerGenderFButton.isSelected = false
    self.ownerGenderNoMatterButton.isSelected = true
    self.age20thButton.isSelected = false
    self.age30thButton.isSelected = false
    self.age40thButton.isSelected = false
    self.age50thButton.isSelected = false
    self.ageNoMatterButton.isSelected = true
    
    self.selBreedView.isHidden = true
    
    self.breedList = [AnimalModel]()
    self.selBreedCollectionView.reloadData()
    
    self.selBreedCollectionView.performBatchUpdates(nil, completion: {
      (result) in
      self.selBreedHeightConstraint.constant = self.selBreedCollectionView.collectionViewLayout.collectionViewContentSize.height
    })
    
    self.setButtonUI()
  }
  
  /// 취소
  /// - Parameter sender: UIButton
  @IBAction func cancelButtonTouched(sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  /// 저장
  /// - Parameter sender: UIButton
  @IBAction func saveButtonTouched(sender: UIButton) {
    var categoryArr = [String]()
    for value in self.breedList {
      categoryArr.append(value.category_management_idx ?? "")
    }
    self.filterRequest.second_category_idx = categoryArr.joined(separator: ",")
//    self.filterRequest.breedList = self.breedList
    
    if self.genderMButton.isSelected {
      self.filterRequest.animal_gender = "0"
    } else if self.genderFButton.isSelected {
      self.filterRequest.animal_gender = "1"
    } else {
      self.filterRequest.animal_gender = ""
    }
    
    if self.neutralOButton.isSelected {
      self.filterRequest.animal_neuter = "0"
    } else if self.neutralXButton.isSelected {
      self.filterRequest.animal_neuter = "1"
    } else {
      self.filterRequest.animal_neuter = ""
    }
    
    if self.gentleButton.isSelected {
      self.filterRequest.animal_character = "0"
    } else if self.biteButton.isSelected {
      self.filterRequest.animal_character = "1"
    } else if self.curiosButton.isSelected {
      self.filterRequest.animal_character = "2"
    } else if self.activeButton.isSelected {
      self.filterRequest.animal_character = "3"
    } else {
      self.filterRequest.animal_character = ""
    }
    
    if self.ownerGenderMButton.isSelected {
      self.filterRequest.guardian_gender = "0"
    } else if self.ownerGenderFButton.isSelected {
      self.filterRequest.guardian_gender = "1"
    } else {
      self.filterRequest.guardian_gender = ""
    }
    
    if self.age20thButton.isSelected {
      self.filterRequest.guardian_age = "20"
    } else if self.age30thButton.isSelected {
      self.filterRequest.guardian_age = "30"
    } else if self.age40thButton.isSelected {
      self.filterRequest.guardian_age = "40"
    } else if self.age50thButton.isSelected {
      self.filterRequest.guardian_age = "50"
    } else {
      self.filterRequest.guardian_age = ""
    }
    
    self.delegate?.friendFilterDelegate(filterModel: self.filterRequest, selectBreedList: self.breedList)
    self.navigationController?.popViewController(animated: true)
  }
}



//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDelegate
//-------------------------------------------------------------------------------------------
extension FriendFilterViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){

  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDataSource
//-------------------------------------------------------------------------------------------
extension FriendFilterViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.breedList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterBreedCell", for: indexPath) as! FilterBreedCell
    cell.breedLabel.text = self.breedList[indexPath.row].category_name ?? ""
    
    // 견종 삭제
    cell.deleteButton.addTapGesture { recognizer in
      self.breedList.remove(at: indexPath.row)
      
      self.selBreedCollectionView.reloadData()
      
      self.selBreedCollectionView.performBatchUpdates(nil, completion: {
        (result) in
        self.selBreedHeightConstraint.constant = self.selBreedCollectionView.collectionViewLayout.collectionViewContentSize.height
      })
    }
    
    return cell
  }
//
//  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//    log.debug("width : \(self.view.frame.size.width)")
//    return CGSize(width: self.view.frame.size.width / 4, height: 54)
//  }
  
    
    // 초기화
//    headerView.resetButton.addTapGesture { [self] recognizer in
//      self.filterArray = Array(repeating: false, count: self.FILTER_CATEGORY.count)
//      self.filterArray[0] = true
//      self.filterCollectionView.reloadData()
//    }
}


//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDelegateFlowLayout
//-------------------------------------------------------------------------------------------
extension FriendFilterViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (collectionView.w - 40) / 3
    return CGSize(width: width, height: 28)
  }
}


//-------------------------------------------------------------------------------------------
// MARK: - SelectedBreedDelegate
//-------------------------------------------------------------------------------------------
extension FriendFilterViewController: SelectedBreedDelegate {
  func selectedBreedDelegate(breedList: [AnimalModel]) {
    self.allBreedButton.isSelected = false
    self.selBreedView.isHidden = false
    self.breedList = breedList
    self.selBreedCollectionView.reloadData()
    
    self.selBreedCollectionView.performBatchUpdates(nil, completion: {
      (result) in
      self.selBreedHeightConstraint.constant = self.selBreedCollectionView.collectionViewLayout.collectionViewContentSize.height
    })
  }
}

