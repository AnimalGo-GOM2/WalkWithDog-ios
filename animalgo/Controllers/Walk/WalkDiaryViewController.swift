//
//  WalkDiaryViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/11.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import DKImagePickerController
import Cosmos
import Defaults
import SwiftLocation
import CoreLocation

class WalkDiaryViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var petImageCollectionView: UICollectionView!
  @IBOutlet weak var walkPicsCollectionVIew: UICollectionView!
  @IBOutlet weak var contentsTextView: UITextView!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var saveButton: UIButton!
  @IBOutlet weak var picsHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var picCountLabel: UILabel!
  @IBOutlet weak var contentsHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var starsView: UIView!
  @IBOutlet weak var readyStarView: CosmosView!
  @IBOutlet weak var mannerStarView: CosmosView!
  @IBOutlet weak var timeStarView: CosmosView!
  @IBOutlet weak var socialityStarView: CosmosView!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var record_type = "0" // 산책구분(0:나와반려건,1:산책친구와함께)
  
  var myPetList = [RecordModel]()
  var imageModel = [FileModel]() // 이미지
  var imageData = [Data]() // 이미지 데이터 타입
  
  var record_idx = ""
  var record_diary_idx = ""
  var distance = ""
  var time = 0
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
    self.contentsTextView.font = UIFont(name: "NotoSansCJKkr-Regular", size: 14)
    self.distanceLabel.text = self.distance
    self.timeLabel.text = "총 \(self.time / 60)분"
    
    self.cancelButton.setCornerRadius(radius: 10)
    self.saveButton.setCornerRadius(radius: 10)
    
    self.walkPicsCollectionVIew.registerCell(type: DiaryPictureCell.self)
    self.walkPicsCollectionVIew.dataSource = self
    self.walkPicsCollectionVIew.delegate = self
    
    self.petImageCollectionView.registerCell(type: DiaryPetCell.self)
    self.petImageCollectionView.dataSource = self
    self.petImageCollectionView.delegate = self
    
    self.contentsHeightConstraint.constant = self.contentsTextView.frame.width / 2

    self.picCountLabel.text = self.imageModel.count.toString
    self.walkPicsCollectionVIew.performBatchUpdates(nil, completion: {
            (result) in
          self.picsHeightConstraint.constant = self.walkPicsCollectionVIew.collectionViewLayout.collectionViewContentSize.height
        })
//    self.petImageCollectionView.collectionViewLayout = OverlapCollectionViewLayout()
    let overlay = OverlapCollectionViewLayout()
    overlay.preferredSize = CGSize(width: 68, height: 68)
    overlay.centerDiff = 48
    self.petImageCollectionView.collectionViewLayout = overlay
    
    if self.record_type == "1" {
      self.starsView.isHidden = false
    } else {
      self.starsView.isHidden = true
    }
    
    self.readyStarView.rating = 5.0
    self.mannerStarView.rating = 5.0
    self.timeStarView.rating = 5.0
    self.socialityStarView.rating = 5.0
    
    self.readyStarView.settings.fillMode = .half
    self.mannerStarView.settings.fillMode = .half
    self.timeStarView.settings.fillMode = .half
    self.socialityStarView.settings.fillMode = .half
  }
  
  override func initRequest() {
    super.initRequest()
    self.diaryRegViewAPI()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 산책 일기 등록 폼
  func diaryRegViewAPI() {
    let recordRequest = RecordModel()
    recordRequest.record_idx = self.record_idx
    recordRequest.member_idx = Defaults[.member_idx]
    
    APIRouter.shared.api(path: APIURL.diary_reg_view, method: .post, parameters: recordRequest.toJSON()) { data in
      if let data = RecordModel(JSON: data), Tools.shared.isSuccessResponse(response: data) {
        if let data_array = data.data_array {
          self.myPetList = data_array
        }
        self.petImageCollectionView.reloadData()
      }
    } fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }
  }
  
  
  
  
  /// 이미지 등록
  func takeAPicture() {
    
    let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
    
    let albumAction = UIAlertAction(title: "앨범에서 선택", style: UIAlertAction.Style.default) { (action) in
      let pickerController = DKImagePickerController()
      pickerController.navigationBar.backgroundColor = .white
      pickerController.assetType = .allPhotos
      pickerController.showsCancelButton = true
      pickerController.allowSwipeToSelect = true
      pickerController.maxSelectableCount = 5 - self.imageModel.count
      
      pickerController.didSelectAssets = { (assets: [DKAsset]) in
        for asset in assets {
          asset.fetchImageData { (data, _) in
            
            if let data = data {
              let image = UIImage(data: data) ?? UIImage()
              let imageData = image.jpegData(compressionQuality: 0.1)
              self.imageData.append(imageData ?? Data())
              
              if assets.count == self.imageData.count {
                self.multiImageUpload(imageData: self.imageData)
              }
            }
          }
        }
        
      }
      self.present(pickerController, animated: true) {}
      
    }
    let cameraAction = UIAlertAction(title: "사진 촬영", style: UIAlertAction.Style.default) { (action) in
      let controller = UIImagePickerController()
      controller.delegate = self
      controller.sourceType = .camera
      controller.mediaTypes = ["public.image"]
      
      self.present(controller, animated: true, completion: nil)
    }
    
    let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
    
    actionSheet.addAction(albumAction)
    actionSheet.addAction(cameraAction)
    actionSheet.addAction(cancelAction)
    
    self.present(actionSheet, animated: true, completion: nil)
    
  }
  
  /// 다중 이미지 업로드 동기식
  /// - Parameter imageData: 이미지 배열
  func multiImageUpload(imageData: [Data]) {
    if imageData.count > 0 {
      self.uploadImages(imageData: imageData[0])
    }
  }
  
  /// 이미지 업로드
  ///
  /// - Parameter imageData: 업로드할 이미지
  func uploadImages(imageData : Data) {
    
    APIRouter.shared.api(path: .fileUpload_action, file: imageData) { response in
      if let fileResponse = FileModel(JSON: response), Tools.shared.isSuccessResponse(response: fileResponse) {
        self.imageModel.append(fileResponse)
        self.picCountLabel.text = self.imageModel.count.toString
        
        self.walkPicsCollectionVIew.reloadData()
        
        if self.imageData.count > 0 {
          self.imageData.remove(at: 0)
          self.multiImageUpload(imageData: self.imageData)
        }
      }
    } fail: { error in
      Tools.shared.showToast(message: "알수 없는 오류가 발생하였습니다.")
    }
    
  }
  
  /// 산책 일기 등록
  func diaryRegInAPI() {
    let recordRequest = RecordModel()
    recordRequest.record_diary_idx = self.record_diary_idx
    recordRequest.record_idx = self.record_idx
    recordRequest.member_idx = Defaults[.member_idx]
    var imgPaths = [String]()
    for value in self.imageModel {
      imgPaths.append(value.file_path ?? "")
    }
    recordRequest.record_img_paths = imgPaths.joined(separator: ",")
    recordRequest.memo = self.contentsTextView.text
    recordRequest.record_type = self.record_type
    
    if self.record_type == "1" {
      recordRequest.review_0 = "\(self.readyStarView.rating)"
      recordRequest.review_1 = "\(self.mannerStarView.rating)"
      recordRequest.review_2 = "\(self.timeStarView.rating)"
      recordRequest.review_3 = "\(self.socialityStarView.rating)"
    }
    
    APIRouter.shared.api(path: APIURL.diary_reg_in, method: .post, parameters: recordRequest.toJSON()) { data in
      if let data_array = RecordModel(JSON: data), Tools.shared.isSuccessResponse(response: data_array) {
        NotificationCenter.default.post(name: Notification.Name("RecordListUpdate"), object: nil)
        if let viewController = self.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController {
          viewController.dismiss(animated: false, completion: nil)
        } else {
          self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
        }
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
    AJAlertController.initialization().showAlert(astrTitle: "", aStrMessage: "산책 일기를 저장하지 않습니다.", aCancelBtnTitle: "아니오", aOtherBtnTitle: "예") { position, title in
      if position == 1 {
        if let viewController = self.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController {
          viewController.dismiss(animated: false, completion: nil)
        } else {
          self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
        }
      }
    }
  }
  /// 저장하기
  /// - Parameter sender: UIButton
  @IBAction func saveButtonTouched(sender: UIButton) {
    AJAlertController.initialization().showAlert(astrTitle: "", aStrMessage: "산책 일기를 저장하시곘습니까?", aCancelBtnTitle: "아니오", aOtherBtnTitle: "예") { position, title in
      if position == 1 {
        self.diaryRegInAPI()
      }
    }
  }
}




//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDataSource
//-------------------------------------------------------------------------------------------
extension WalkDiaryViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    if collectionView == self.walkPicsCollectionVIew {
      let width = (self.view.frame.width - 60) / 3
      if self.imageModel.count < 3 {
        self.picsHeightConstraint.constant = width + 20
      } else {
        self.picsHeightConstraint.constant = width * 2 + 20
      }
      return imageModel.count + 1
    }else {
      return self.myPetList.count
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView == self.walkPicsCollectionVIew {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryPictureCell", for: indexPath) as! DiaryPictureCell
      
      
      if indexPath.row > 0 {
        cell.walkPictureImageView.isHidden = false
        cell.removeButton.isHidden = false
        cell.plusButton.isHidden = true
        cell.walkPictureImageView.sd_setImage(with: URL(string: "\(baseURL)\(self.imageModel[indexPath.row - 1].file_path ?? "")"), completed: nil)
      } else {
        cell.walkPictureImageView.isHidden = true
        cell.removeButton.isHidden = true
        cell.plusButton.isHidden = false
      }
      
      cell.plusButton.addTapGesture { recognizer in
        if self.imageModel.count < 5 {
          self.takeAPicture()
        }
      }
      
      cell.removeButton.addTapGesture { recognizer in
        self.imageModel.remove(at: indexPath.row - 1)
        self.picCountLabel.text = self.imageModel.count.toString
        self.walkPicsCollectionVIew.reloadData()
      }
      
      return cell
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryPetCell", for: indexPath) as! DiaryPetCell
      guard self.myPetList.count > 0 else { return cell }
      let petData = self.myPetList[indexPath.row]
      cell.petImageView.sd_setImage(with: URL(string: Tools.shared.thumbnailImageUrl(url: petData.animal_img_path ?? "")), placeholderImage: UIImage(named: "default_dog1"), options: .lowPriority, context: nil)
      return cell
    }
    
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDelegate
//-------------------------------------------------------------------------------------------
extension WalkDiaryViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
      
    
  }
  
}


//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDelegateFlowLayout
//-------------------------------------------------------------------------------------------
extension WalkDiaryViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    if collectionView == self.walkPicsCollectionVIew {
      let width = (self.walkPicsCollectionVIew.frame.width - 22) / 3
      return CGSize(width: width, height: width)
    }else {
      return CGSize(width: 68, height: 68)
    }
  }
}



//-------------------------------------------------------------------------------------------
// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
//-------------------------------------------------------------------------------------------
extension WalkDiaryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      imagePickerController(picker, pickedImage: image)
    }
  }
  
  @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
    picker.dismiss(animated: false) {
      let resizeImage = pickedImage!.resized(toWidth: 1000, isOpaque: true)
      let data = resizeImage?.jpegData(compressionQuality: 0.6) ?? Data()
      
      self.uploadImages(imageData: data)
    }
  }
}
