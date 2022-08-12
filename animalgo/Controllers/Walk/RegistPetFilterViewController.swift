//
//  RegistPetFilterViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/15.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit

class RegistPetFilterViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
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
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var selBreedCollectionView: UICollectionView!
  @IBOutlet weak var noMattherAllButton: UIButton!
  @IBOutlet weak var breedsView: UIView!
  @IBOutlet weak var selBreedHeightConstraint: NSLayoutConstraint!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var recordRequest = RecordModel()
  var breedList = [AnimalModel]()
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    self.selBreedCollectionView.registerCell(type: FilterBreedCell.self)
    self.selBreedCollectionView.delegate = self
    self.selBreedCollectionView.dataSource = self
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
    self.cancelButton.setCornerRadius(radius: 10)
    self.nextButton.setCornerRadius(radius: 10)
    
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
    
    self.genderNoMatterButton.isSelected = true
    self.neutralNoMatterButton.isSelected = true
    self.personalityNoMatterButton.isSelected = true
    
    self.selectedButtonColor(button: genderNoMatterButton)
    self.selectedButtonColor(button: neutralNoMatterButton)
    self.selectedButtonColor(button: personalityNoMatterButton)
    
    self.noMattherAllButton.isSelected = true
//    self.breedsView.isHidden = true
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
  
  // 모두 상관없어요 체크
  func checkNoMattherAllButton() {
    if self.genderNoMatterButton.isSelected && self.neutralNoMatterButton.isSelected && self.personalityNoMatterButton.isSelected {
      self.noMattherAllButton.isSelected = true
    } else {
      self.noMattherAllButton.isSelected = false
    }
  }

  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
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
    
    self.selectedButtonColor(button: self.genderMButton)
    self.selectedButtonColor(button: self.genderFButton)
    self.selectedButtonColor(button: self.genderNoMatterButton)
    self.checkNoMattherAllButton()
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
    
    self.selectedButtonColor(button: self.neutralOButton)
    self.selectedButtonColor(button: self.neutralXButton)
    self.selectedButtonColor(button: self.neutralNoMatterButton)
    self.checkNoMattherAllButton()
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
    
    self.selectedButtonColor(button: self.gentleButton)
    self.selectedButtonColor(button: self.biteButton)
    self.selectedButtonColor(button: self.curiosButton)
    self.selectedButtonColor(button: self.activeButton)
    self.selectedButtonColor(button: self.personalityNoMatterButton)
    self.checkNoMattherAllButton()
  }
  
  /// 견종찾기
  /// - Parameter sender: UIButton
  @IBAction func findBreedButtonTouched(sender: UIButton) {
    let destination = FindBreedViewController.instantiate(storyboard: "Walk")
    destination.selectBreedList = self.breedList
    destination.delegate = self
    self.navigationController?.pushViewController(destination, animated: true)
  }
  
  /// 모두 상관없어요 체크
  /// - Parameter sender: UIButton
  @IBAction func noMatterAllButtonTouched(sender: UIButton) {
    self.noMattherAllButton.isSelected = true
    self.gentleButton.isSelected = false
    self.biteButton.isSelected = false
    self.curiosButton.isSelected = false
    self.activeButton.isSelected = false
    self.personalityNoMatterButton.isSelected = true
    selectedButtonColor(button: self.gentleButton)
    selectedButtonColor(button: self.biteButton)
    selectedButtonColor(button: self.curiosButton)
    selectedButtonColor(button: self.activeButton)
    selectedButtonColor(button: self.personalityNoMatterButton)
    
    self.neutralOButton.isSelected = false
    self.neutralXButton.isSelected = false
    self.neutralNoMatterButton.isSelected = true
    selectedButtonColor(button: self.neutralXButton)
    selectedButtonColor(button: self.neutralOButton)
    selectedButtonColor(button: self.neutralNoMatterButton)
    
    self.genderMButton.isSelected = false
    self.genderFButton.isSelected = false
    self.genderNoMatterButton.isSelected = true
    selectedButtonColor(button: self.genderNoMatterButton)
    selectedButtonColor(button: self.genderMButton)
    selectedButtonColor(button: self.genderFButton)
  }
  
  /// 취소
  /// - Parameter sender: UIButton
  @IBAction func cancelButtonTouched(sender: UIButton) {
    self.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
  }
  /// 다음
  /// - Parameter sender: UIButton
  @IBAction func nextButtonTouched(sender: UIButton) {
//    self.recordRequest
    var categoryArr = [String]()
    for value in self.breedList {
      categoryArr.append(value.category_management_idx ?? "")
    }
    self.recordRequest.second_category_idx = categoryArr.joined(separator: ",")
    if self.genderMButton.isSelected {
      self.recordRequest.animal_gender = "0"
    } else if self.genderFButton.isSelected {
      self.recordRequest.animal_gender = "1"
    } else {
      self.recordRequest.animal_gender = ""
    }
    
    if self.neutralOButton.isSelected {
      self.recordRequest.animal_neuter = "0"
    } else if self.neutralXButton.isSelected {
      self.recordRequest.animal_neuter = "1"
    } else {
      self.recordRequest.animal_neuter = ""
    }
    
    if self.gentleButton.isSelected {
      self.recordRequest.animal_character = "0"
    } else if self.biteButton.isSelected {
      self.recordRequest.animal_character = "1"
    } else if self.curiosButton.isSelected {
      self.recordRequest.animal_character = "2"
    } else if self.activeButton.isSelected {
      self.recordRequest.animal_character = "3"
    } else {
      self.recordRequest.animal_character = ""
    }
    
    let destination = RegistOwnerFilterViewController.instantiate(storyboard: "Walk").coverNavigationController()
    if let firstViewController = destination.viewControllers.first {
      let viewController = firstViewController as! RegistOwnerFilterViewController
      viewController.recordRequest = self.recordRequest
    }
    destination.hero.isEnabled = false
    destination.hero.modalAnimationType = .autoReverse(presenting: .cover(direction: .left))
    destination.modalPresentationStyle = .fullScreen
    self.present(destination, animated: true, completion: nil)
  }
 
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDelegate
//-------------------------------------------------------------------------------------------
extension RegistPetFilterViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
//    let destination = ProductInfoViewController.instantiate(storyboard: "Home")
//    self.navigationController?.pushViewController(destination, animated: true)
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDataSource
//-------------------------------------------------------------------------------------------
extension RegistPetFilterViewController: UICollectionViewDataSource {
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
}


//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDelegateFlowLayout
//-------------------------------------------------------------------------------------------
extension RegistPetFilterViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let sizeCheckLabel = UILabel()
    sizeCheckLabel.text = self.breedList[indexPath.row].category_name ?? ""
    sizeCheckLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    sizeCheckLabel.sizeToFit()
    let width = sizeCheckLabel.frame.size.width
    return CGSize(width: width + 30, height: 28)
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - SelectedBreedDelegate
//-------------------------------------------------------------------------------------------
extension RegistPetFilterViewController: SelectedBreedDelegate {
  func selectedBreedDelegate(breedList: [AnimalModel]) {
    self.breedList = breedList
    self.selBreedCollectionView.reloadData()
    
    self.selBreedCollectionView.performBatchUpdates(nil, completion: {
      (result) in
      self.selBreedHeightConstraint.constant = self.selBreedCollectionView.collectionViewLayout.collectionViewContentSize.height
    })
  }
}

