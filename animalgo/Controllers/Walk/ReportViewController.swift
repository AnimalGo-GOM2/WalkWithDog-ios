//
//  ReportViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/16.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import DKImagePickerController
import DropDown
import Defaults

enum ReportType {
  case Block
  case Report
}

protocol SuccessBlockDelegate {
  func successBlockDelegate()
}

class ReportViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var blockTopLabel: UILabel!
  @IBOutlet weak var reportTopLabel: UILabel!
  @IBOutlet weak var reasonTextField: UITextField!
  @IBOutlet weak var reasonWrapView: UIView!
  @IBOutlet weak var contentsView: UIView!
  @IBOutlet weak var contentsLabel: UILabel!
  @IBOutlet weak var contentsTextView: UITextView!
  @IBOutlet weak var photoCollectionView: UICollectionView!
  @IBOutlet weak var confirmButton: UIButton!
  @IBOutlet weak var picsHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var picCountLabel: UILabel!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var reportType = ReportType.Report
  var partner_member_idx = ""
  var delegate: SuccessBlockDelegate?
  
  var imageModel = [FileModel]() // 이미지
  var imageData = [Data]() // 이미지 데이터 타입
  let reasonList = ["부적절한 대화","불친절한 매너","기타(직접입력)"]
  var type: Int? = nil
  let dropDown = DropDown()
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 이유 선택
    self.reasonWrapView.addTapGesture { recognizer in
      self.dropDown.anchorView = self.reasonWrapView
      self.dropDown.dataSource = self.reasonList
      self.customizeDropDown(self)
      self.dropDown.reloadAllComponents()
      self.dropDown.show()
      self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
        self.type = index
        self.reasonTextField.text = self.reasonList[index]
        if self.reasonList[index] == "기타(직접입력)" {
          self.contentsView.isHidden = false
        }else {
          self.contentsView.isHidden = true
        }
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    
    self.confirmButton.setCornerRadius(radius: 10)
    self.photoCollectionView.registerCell(type: DiaryPictureCell.self)
    self.photoCollectionView.dataSource = self
    self.photoCollectionView.delegate = self
    
    self.contentsTextView.delegate = self
    self.picCountLabel.text = "0"
    

    if self.reportType == .Block {
      self.blockTopLabel.isHidden = false
      self.reportTopLabel.isHidden = true
      self.contentsLabel.text = "차단 사유를 입력 해주세요."
      self.reasonTextField.placeholder = "차단 사유를 선택하세요."
      self.title = "차단하기"
    }else {
      self.blockTopLabel.isHidden = true
      self.reportTopLabel.isHidden = false
      self.contentsLabel.text = "신고 사유를 입력 해주세요."
      self.reasonTextField.placeholder = "신고 사유를 선택하세요."
      self.title = "신고하기"
    }
    
    self.contentsView.isHidden = true
    
  }
  
  override func initRequest() {
    super.initRequest()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
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
        
        self.photoCollectionView.reloadData()
        
        if self.imageData.count > 0 {
          self.imageData.remove(at: 0)
          self.multiImageUpload(imageData: self.imageData)
        }
      }
    } fail: { error in
      Tools.shared.showToast(message: "알수 없는 오류가 발생하였습니다.")
    }
    
  }
  
  /// 드롭다운 세팅
  /// - Parameter sender: self
  func customizeDropDown(_ sender: AnyObject) {
    DropDown.appearance().cornerRadius = 4
    DropDown.appearance().direction = .bottom
    DropDown.appearance().shadowColor = UIColor(named: "707070")!
    DropDown.appearance().cellHeight = 44
    dropDown.width = self.reasonWrapView.frame.width
    self.dropDown.bottomOffset = CGPoint(x: 0, y: 49)
    self.dropDown.shadowOpacity = 0.5
    self.dropDown.shadowOffset = CGSize(width: 0, height: 0)
    
    self.dropDown.backgroundColor = .white
    self.dropDown.cellNib = UINib(nibName: "TextDropDownCell", bundle: nil)
    
    
    self.dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
      guard let cell = cell as? TextDropDownCell else { return }
      cell.titleLabel.text = item
      cell.optionLabel.isHidden = true
    }
    
  }
  
  /// 신고하기
  func reportRegInAPI() {
    let memberRequest = MemberModel()
    memberRequest.member_idx = Defaults[.member_idx]
    memberRequest.partner_member_idx = self.partner_member_idx
    if let type = type {
      memberRequest.report_type = "\(type)"
    }
    memberRequest.report_contents = self.contentsTextView.text

    var imgPaths = [String]()
    for value in self.imageModel {
      imgPaths.append(value.file_path ?? "")
    }
    memberRequest.img_path = imgPaths.joined(separator: ",")
    
    APIRouter.shared.api(path: APIURL.report_reg_in, method: .post, parameters: memberRequest.toJSON()) { data in
      if let data_array = MemberModel(JSON: data), Tools.shared.isSuccessResponse(response: data_array) {
        self.dismiss(animated: true, completion: nil)
      }
    } fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }

  }
  
  /// 차단하기
  func blockRegInAPI() {
    let memberRequest = MemberModel()
    memberRequest.member_idx = Defaults[.member_idx]
    memberRequest.partner_member_idx = self.partner_member_idx
    if let type = type {
      memberRequest.block_type = "\(type)"
    }
    memberRequest.block_contents = self.contentsTextView.text

    var imgPaths = [String]()
    for value in self.imageModel {
      imgPaths.append(value.file_path ?? "")
    }
    memberRequest.img_path = imgPaths.joined(separator: ",")
    
    APIRouter.shared.api(path: APIURL.block_reg_in, method: .post, parameters: memberRequest.toJSON()) { data in
      if let data_array = MemberModel(JSON: data), Tools.shared.isSuccessResponse(response: data_array) {
        self.dismiss(animated: true, completion: nil)
        self.delegate?.successBlockDelegate()
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
    if self.reportType == .Block {
      self.blockRegInAPI()
    } else {
      self.reportRegInAPI()
    }
    
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDataSource
//-------------------------------------------------------------------------------------------
extension ReportViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    let width = (self.view.frame.width - 60) / 3
    if self.imageModel.count < 3 {
      self.picsHeightConstraint.constant = width + 20
    } else {
      self.picsHeightConstraint.constant = width * 2 + 20
    }
    return imageModel.count + 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
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
      self.photoCollectionView.reloadData()
    }
    
    return cell
    
    
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDelegate
//-------------------------------------------------------------------------------------------
extension ReportViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    
    
  }
  
}


//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDelegateFlowLayout
//-------------------------------------------------------------------------------------------
extension ReportViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let width = (self.photoCollectionView.frame.width - 22) / 3
    return CGSize(width: width, height: width)
    
  }
}



//-------------------------------------------------------------------------------------------
// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
//-------------------------------------------------------------------------------------------
extension ReportViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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

//-------------------------------------------------------------------------------------------
// MARK: - UITextViewDelegate
//-------------------------------------------------------------------------------------------
extension ReportViewController: UITextViewDelegate{
  
  func textViewDidChange(_ textView: UITextView) {
    if textView.text?.count ?? 0 > 0{
      self.contentsLabel.isHidden = true
    }else{
      self.contentsLabel.isHidden = false
    }
  }
  
}
