//
//  FindBreedViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/08.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit

protocol SelectedBreedDelegate {
  func selectedBreedDelegate(breedList: [AnimalModel])
}

class FindBreedViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var groupTableView: UITableView!
  @IBOutlet weak var breedTableView: UITableView!
  
  @IBOutlet weak var selBreedCollectionView: UICollectionView!
  @IBOutlet weak var confirmButton: UIButton!
  @IBOutlet weak var selBreedHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var selBreedView: UIView!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var petGroupList = [AnimalModel]()
  var petBreedList = [AnimalModel]()
  var selectBreedList = [AnimalModel]()
  var delegate: SelectedBreedDelegate?
  
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if self.selectBreedList.count > 0 {
      self.selBreedCollectionView.reloadData()
      self.selBreedCollectionView.performBatchUpdates(nil, completion: {
        (result) in
        self.selBreedHeightConstraint.constant = self.selBreedCollectionView.collectionViewLayout.collectionViewContentSize.height
      })
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    self.confirmButton.setCornerRadius(radius: 10)
    self.groupTableView.registerCell(type: SelGroupCell.self)
    self.groupTableView.delegate = self
    self.groupTableView.dataSource = self
    
    self.breedTableView.registerCell(type: SelBreedCell.self)
    self.breedTableView.delegate = self
    self.breedTableView.dataSource = self
    
    self.selBreedCollectionView.registerCell(type: FilterBreedCell.self)
    self.selBreedCollectionView.delegate = self
    self.selBreedCollectionView.dataSource = self
    self.selBreedCollectionView.collectionViewLayout = CollectionViewLeftAlignFlowLayout()
    if let flowLayout = self.selBreedCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }

    self.selBreedView.layer.shadowRadius = 3
    self.selBreedView.layer.shadowOpacity = 1
    self.selBreedView.layer.shadowColor = UIColor(named: "F6F6F6")!.cgColor
    self.selBreedView.layer.shadowOffset = CGSize(width: 0, height: 0)
    self.selBreedView.layer.masksToBounds = false
  }
  
  override func initRequest() {
    super.initRequest()
    self.animalListAPI()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  // 견분류 리스트
  func animalListAPI() {
    APIRouter.shared.api(path: APIURL.animal_list_type, method: .post, parameters: nil) { data in
      if let animalResponse = AnimalModel(JSON: data), Tools.shared.isSuccessResponse(response: animalResponse) {
        if let data_array = animalResponse.data_array {
          self.petGroupList = data_array
        }
        
        if self.petGroupList.count > 0 {
          self.petGroupList[0].isSelected = true
          self.animalListKind(parent_category_management_idx: self.petGroupList[0].category_management_idx ?? "")
        }
        
        self.groupTableView.reloadData()
      }
    } fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }

  }
  
  
  /// 견종 분류 리스트
  /// - Parameter parent_category_management_idx: 부모 카테고리 키
  func animalListKind(parent_category_management_idx: String) {
    let animalRequest = AnimalModel()
    animalRequest.parent_category_management_idx = parent_category_management_idx
    
    
    APIRouter.shared.api(path: APIURL.animal_list_kind, method: .post, parameters: animalRequest.toJSON()) { data in
      if let animalResponse = AnimalModel(JSON: data), Tools.shared.isSuccessResponse(response: animalResponse) {
        if let data_array = animalResponse.data_array {
          self.petBreedList = data_array
        }
        
        for value in self.petBreedList {
          if self.selectBreedList.contains(where: {$0.category_management_idx == value.category_management_idx}) {
            value.isSelected = true
          }
        }
        self.breedTableView.reloadData()
      }
    } fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 확인
  /// - Parameter sender: UIButton
  @IBAction func confirmButtonTouched(sender: UIButton) {
    self.delegate?.selectedBreedDelegate(breedList: self.selectBreedList)
    self.navigationController?.popViewController(animated: true)
  }
 
}



//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDelegate
//-------------------------------------------------------------------------------------------
extension FindBreedViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
    // 선택한 견종 제거
    let category_management_idx = self.selectBreedList[indexPath.row].category_management_idx ?? ""
    if let filter = self.petBreedList.filter({$0.category_management_idx == category_management_idx }).first {
      filter.isSelected = !(filter.isSelected ?? false)
      self.breedTableView.reloadData()
    }
    
    
    self.selectBreedList.remove(at: indexPath.row)
    self.selBreedCollectionView.reloadData()
    
    self.selBreedCollectionView.performBatchUpdates(nil, completion: {
      (result) in
      self.selBreedHeightConstraint.constant = self.selBreedCollectionView.collectionViewLayout.collectionViewContentSize.height
    })
      
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDataSource
//-------------------------------------------------------------------------------------------
extension FindBreedViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.selectBreedList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterBreedCell", for: indexPath) as! FilterBreedCell
    cell.breedLabel.text = self.selectBreedList[indexPath.row].category_name ?? ""
    
    
    
    return cell
  }
  
}


//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDelegateFlowLayout
//-------------------------------------------------------------------------------------------
extension FindBreedViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let sizeCheckLabel = UILabel()
    sizeCheckLabel.text = self.selectBreedList[indexPath.row].category_name ?? ""
    sizeCheckLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    sizeCheckLabel.sizeToFit()
    let width = sizeCheckLabel.frame.size.width
    return CGSize(width: width + 30, height: 28)
  }
}



//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDataSource
//-------------------------------------------------------------------------------------------
extension FindBreedViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tableView == self.groupTableView {
      return self.petGroupList.count
    } else {
      return self.petBreedList.count
    }
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if tableView == self.groupTableView {
      let cell = tableView.dequeueReusableCell(withIdentifier: "SelGroupCell", for: indexPath) as! SelGroupCell
      let groupData = self.petGroupList[indexPath.row]
      cell.groupLabel.text = groupData.category_name ?? ""
      cell.groupButton.isSelected = groupData.isSelected ?? false
      cell.groupButtonSelected()

      // 견분류 선택
      cell.groupButton.addTapGesture { recognizer in
        for value in self.petGroupList {
          value.isSelected = false
        }
        
        groupData.isSelected = true
        self.animalListKind(parent_category_management_idx: groupData.category_management_idx ?? "")
        self.groupTableView.reloadData()
      }
      
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "SelBreedCell", for: indexPath) as! SelBreedCell
      let breedData = self.petBreedList[indexPath.row]
      cell.breedLabel.text = breedData.category_name ?? ""
      cell.breedButton.isSelected = breedData.isSelected ?? false
      cell.breedButtonSelected()
      
      // 견종 선택
      cell.breedButton.addTapGesture { recognizer in
        if breedData.isSelected ?? false {
          let filterIndex = self.selectBreedList.firstIndex(where: {$0.category_management_idx == breedData.category_management_idx}) ?? Int(0)
          self.selectBreedList.remove(at: Int(filterIndex))
        } else {
          self.selectBreedList.append(breedData)
        }
        self.selBreedCollectionView.reloadData()
        
        self.selBreedCollectionView.performBatchUpdates(nil, completion: {
          (result) in
          self.selBreedHeightConstraint.constant = self.selBreedCollectionView.collectionViewLayout.collectionViewContentSize.height
        })
        
        breedData.isSelected = !(breedData.isSelected ?? false)
        self.breedTableView.reloadData()
      }
      
      return cell
    }
    
  }
}
//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDelegate
//-------------------------------------------------------------------------------------------
extension FindBreedViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    
  }
}
