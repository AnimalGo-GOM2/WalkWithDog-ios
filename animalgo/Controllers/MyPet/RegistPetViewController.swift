//
//  RegistPetViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/04.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import DropDown
import CropViewController
import Defaults

class RegistPetViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var petImageView: UIImageView!
  @IBOutlet weak var petNameTextField: UITextField!
  @IBOutlet weak var groupTextField: UITextField!
  @IBOutlet weak var groupWrapView: UIView!
  @IBOutlet weak var breedTextField: UITextField!
  @IBOutlet weak var breedWrapView: UIView!
  @IBOutlet weak var genderMButton: UIButton!
  @IBOutlet weak var genderFButton: UIButton!
  @IBOutlet weak var neutralOButton: UIButton!
  @IBOutlet weak var neutralXButton: UIButton!
  @IBOutlet weak var birthYearTextField: UITextField!
  @IBOutlet weak var birthYearWrapView: UIView!
  @IBOutlet weak var birthMonthTextField: UITextField!
  @IBOutlet weak var birthMonthWrapView: UIView!
  @IBOutlet weak var trainedButton: UIButton!
  @IBOutlet weak var notTrainedButton: UIButton!
  @IBOutlet weak var gentleButton: UIButton!
  @IBOutlet weak var biteButton: UIButton!
  @IBOutlet weak var curiosButton: UIButton!
  @IBOutlet weak var activeButton: UIButton!
  @IBOutlet weak var healthyButton: UIButton!
  @IBOutlet weak var normalHealthButton: UIButton!
  @IBOutlet weak var needCautionButton: UIButton!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var saveButton: UIButton!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  let dropDown = DropDown()
  var type = 0
  var yearList = [String]()
  var monthList = ["1","2","3","4","5","6","7","8","9","10","11","12"]
  var petImageUrl = ""
  var petGroupList = [AnimalModel]() // 견분류
  var petList = [AnimalModel]() // 전체 견종
  var petBreedList = [AnimalModel]() // 견종분류

  var animalRequest = AnimalModel()
  var animal_idx = ""
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
    let year = Date()
    let date = DateFormatter()
    date.locale = Locale(identifier: "ko_kr")
    date.dateFormat = "yyyy"
    let nowYear = date.string(from: year).toInt()
    for i in nowYear!-21..<nowYear!+1 {
      self.yearList.append(i.toString)
    }
    self.petNameTextField.addBorderBottom(size: 1, color: UIColor(named: "EAE8E5")!)
    self.groupWrapView.addBorderBottom(size: 1, color: UIColor(named: "EAE8E5")!)
    self.breedWrapView.addBorderBottom(size: 1, color: UIColor(named: "EAE8E5")!)
    self.birthYearWrapView.addBorderBottom(size: 1, color: UIColor(named: "EAE8E5")!)
    self.birthMonthWrapView.addBorderBottom(size: 1, color: UIColor(named: "EAE8E5")!)
    self.petImageView.setCornerRadius(radius: 75)
    self.genderFButton.setCornerRadius(radius: 10)
    self.genderMButton.setCornerRadius(radius: 10)
    self.neutralOButton.setCornerRadius(radius: 10)
    self.neutralXButton.setCornerRadius(radius: 10)
    self.trainedButton.setCornerRadius(radius: 10)
    self.notTrainedButton.setCornerRadius(radius: 10)
    self.gentleButton.setCornerRadius(radius: 10)
    self.biteButton.setCornerRadius(radius: 10)
    self.curiosButton.setCornerRadius(radius: 10)
    self.activeButton.setCornerRadius(radius: 10)
    self.healthyButton.setCornerRadius(radius: 10)
    self.normalHealthButton.setCornerRadius(radius: 10)
    self.needCautionButton.setCornerRadius(radius: 10)
    self.cancelButton.setCornerRadius(radius: 10)
    self.saveButton.setCornerRadius(radius: 10)
    self.genderFButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.genderMButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.neutralOButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.neutralXButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.trainedButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.notTrainedButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.gentleButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.biteButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.curiosButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.activeButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.healthyButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.normalHealthButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.needCautionButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    // 사진 등록
    self.petImageView.addTapGesture { recognizer in
      self.takeAPicture()
    }
    
    // 생년 드랍다운
    self.birthYearWrapView.addTapGesture { recognizer in
      self.dropDown.anchorView = self.birthYearWrapView
      self.dropDown.dataSource = self.yearList
      self.customizeDropDown(self)
      self.dropDown.reloadAllComponents()
      self.dropDown.show()
      self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
        self.birthYearTextField.text = self.yearList[index]
      }
    }
    
    
    // 생월 드랍다운
    self.birthMonthWrapView.addTapGesture { recognizer in
      self.dropDown.anchorView = self.birthMonthWrapView
      self.dropDown.dataSource = self.monthList
      self.customizeDropDown(self)
      self.dropDown.reloadAllComponents()
      self.dropDown.show()
      self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
        self.birthMonthTextField.text = self.monthList[index]
      }
    }
    
    // 견분류 선택 드롭다운
    self.groupWrapView.addTapGesture { recognizer in
      guard self.petGroupList.count > 0 else { return }
      self.dropDown.anchorView = self.groupWrapView
      self.dropDown.dataSource = [String]()
      for value in self.petGroupList {
        self.dropDown.dataSource.append(value.category_name ?? "")
      }
      self.customizeDropDown(self)
      self.dropDown.reloadAllComponents()
      self.dropDown.show()
      self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
        self.groupTextField.text = self.petGroupList[index].category_name ?? ""
        self.animalRequest.first_category_idx = self.petGroupList[index].category_management_idx ?? ""
        
        self.petBreedList.removeAll()
        self.animalListKind(parent_category_management_idx: self.petGroupList[index].category_management_idx ?? "")
//        for value in self.petList {
//          if value.parent_category_management_idx == self.animalRequest.first_category_idx {
//            self.petBreedList.append(value)
//          }
//        }
        self.breedTextField.text = ""
        self.animalRequest.second_category_idx = ""
      }
    
    }
    
    // 견종 선택
    self.breedWrapView.addTapGesture { recognizer in
      guard self.petBreedList.count > 0 else { return }
      self.dropDown.anchorView = self.breedWrapView
      self.dropDown.dataSource = [String]()
      for value in self.petBreedList {
        self.dropDown.dataSource.append(value.category_name ?? "")
      }
      self.customizeDropDown(self)
      self.dropDown.reloadAllComponents()
      self.dropDown.show()
      self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
        self.breedTextField.text = self.petBreedList[index].category_name ?? ""
        self.animalRequest.second_category_idx = self.petBreedList[index].category_management_idx ?? ""
      }
    }
    
  }
  
  override func initRequest() {
    super.initRequest()
    self.animalListAPI()
    if self.animal_idx != "" {
      self.animalDetailAPI()
    }
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
  
  // 모든 버튼 UI
  func setButtonUI() {
    self.selectedButtonColor(button: self.genderMButton)
    self.selectedButtonColor(button: self.genderFButton)
    self.selectedButtonColor(button: self.neutralOButton)
    self.selectedButtonColor(button: self.neutralXButton)
    self.selectedButtonColor(button: self.trainedButton)
    self.selectedButtonColor(button: self.notTrainedButton)
    self.selectedButtonColor(button: self.gentleButton)
    self.selectedButtonColor(button: self.biteButton)
    self.selectedButtonColor(button: self.curiosButton)
    self.selectedButtonColor(button: self.activeButton)
    self.selectedButtonColor(button: self.healthyButton)
    self.selectedButtonColor(button: self.normalHealthButton)
    self.selectedButtonColor(button: self.needCautionButton)
  }
  
  /// 드롭다운 세팅
  /// - Parameter sender: self
  func customizeDropDown(_ sender: AnyObject) {
    DropDown.appearance().cornerRadius = 4
    DropDown.appearance().direction = .bottom
    DropDown.appearance().shadowColor = UIColor(named: "707070")!
    DropDown.appearance().cellHeight = 44
    dropDown.width = self.groupWrapView.frame.width
    self.dropDown.bottomOffset = CGPoint(x: 0, y: 45)
    self.dropDown.shadowOpacity = 1
    self.dropDown.shadowOffset = CGSize(width: 0, height: 0)
    self.dropDown.backgroundColor = .white
    self.dropDown.cellNib = UINib(nibName: "TextDropDownCell", bundle: nil)
    self.view.endEditing(true)
    
    self.dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
      guard let cell = cell as? TextDropDownCell else { return }
      cell.titleLabel.text = item
      cell.optionLabel.isHidden = true
    }
    
  }
  
  /// 사진 추가
  func takeAPicture() {
    let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
    let cameraAction = UIAlertAction(title: "사진촬영", style: UIAlertAction.Style.default) { (action) in
    
      let controller = UIImagePickerController()
      controller.delegate = self
      controller.sourceType = .camera
      self.present(controller, animated: true, completion: nil)
    }
    
    
    let albumAction = UIAlertAction(title: "앨범에서 선택", style: UIAlertAction.Style.default) { (action) in
      let controller = UIImagePickerController()
      controller.delegate = self
      self.present(controller, animated: true, completion: nil)
    }
    
    let deleteAction = UIAlertAction(title: "프로필 사진 삭제", style: UIAlertAction.Style.destructive) { (action) in
      self.petImageView.image = UIImage(named: "btn_photo")!
      self.petImageUrl = ""
    }
    
    
    let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
    
    actionSheet.addAction(cameraAction)
    actionSheet.addAction(albumAction)
    actionSheet.addAction(deleteAction)
    actionSheet.addAction(cancelAction)
    actionSheet.view.tintColor = .systemBlue
    
    self.present(actionSheet, animated: true, completion: nil)
  }
  
  /// 이미지 업로드
  ///
  /// - Parameter imageData: 업로드할 이미지
  func uploadImages(imageData : Data) {
    
    APIRouter.shared.api(path: .fileUpload_action, file: imageData) { response in
      if let fileResponse = FileModel(JSON: response), Tools.shared.isSuccessResponse(response: fileResponse) {
        self.petImageUrl = fileResponse.file_path ?? ""
        self.petImageView.sd_setImage(with: URL(string: "\(baseURL)\(fileResponse.file_path ?? "")"), completed: nil)
      }
    } fail: { error in
      Tools.shared.showToast(message: "알수 없는 오류가 발생하였습니다.")
    }
  }
  
  // 견분류 리스트
  func animalListAPI() {
    APIRouter.shared.api(path: APIURL.animal_list_type, method: .post, parameters: nil) { data in
      if let animalResponse = AnimalModel(JSON: data), Tools.shared.isSuccessResponse(response: animalResponse) {
        if let data_array = animalResponse.data_array {
          self.petGroupList = data_array
        }
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
      }
    } fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }
  }
  
  /// 견 분류, 견종 리스트
//  func animalListAPI() {
//
//    APIRouter.shared.api(path: APIURL.animal_list, method: .post, parameters: animalRequest.toJSON()) { data in
//      if let animalResponse = AnimalModel(JSON: data), Tools.shared.isSuccessResponse(response: animalResponse) {
//        if let data_array = animalResponse.data_array {
//          for value in data_array {
//            if value.category_depth == "1" {
//              self.petGroupList.append(value)
//            } else {
//              self.petList.append(value)
//            }
//          }
//
//        }
//      }
//    } fail: { error in
//      Tools.shared.showToast(message: error?.localizedDescription ?? "")
//    }
//  }
//
  /// 반려견 등록
  func animalRegInAPI() {
    self.animalRequest.member_idx = Defaults[.member_idx]
    self.animalRequest.animal_img_path = self.petImageUrl
    self.animalRequest.animal_name = self.petNameTextField.text
    self.animalRequest.animal_gender = self.genderMButton.isSelected ? "0" : self.genderFButton.isSelected ? "1" : ""
    self.animalRequest.animal_neuter = self.neutralOButton.isSelected ? "Y" : self.neutralXButton.isSelected ? "N" : ""
    self.animalRequest.animal_birth = "\(self.birthYearTextField.text ?? "")-\(self.birthMonthTextField.text ?? "")"
    self.animalRequest.animal_training = self.trainedButton.isSelected ? "Y" : self.notTrainedButton.isSelected ? "N" : ""
    if self.gentleButton.isSelected {
      self.animalRequest.animal_character = "0"
    } else if self.biteButton.isSelected {
      self.animalRequest.animal_character = "1"
    } else if self.curiosButton.isSelected {
      self.animalRequest.animal_character = "2"
    } else if self.activeButton.isSelected {
      self.animalRequest.animal_character = "3"
    }
    if self.healthyButton.isSelected {
      self.animalRequest.animal_health = "0"
    } else if self.normalHealthButton.isSelected {
      self.animalRequest.animal_health = "1"
    } else if self.needCautionButton.isSelected {
      self.animalRequest.animal_health = "2"
    }
    
    APIRouter.shared.api(path: APIURL.animal_reg_in, method: .post, parameters: self.animalRequest.toJSON()) { data in
      if let animalResponse = AnimalModel(JSON: data), Tools.shared.isSuccessResponse(response: animalResponse) {
        NotificationCenter.default.post(name: Notification.Name("MyPetListUpdate"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("MainUpdate"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("WalkViewUpdate"), object: nil)
        
        self.closeViewController()
      }
    } fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }
  }
  
  /// 반려견 상세
  func animalDetailAPI() {
    let animalRequest = AnimalModel()
    animalRequest.animal_idx = self.animal_idx
    
    APIRouter.shared.api(path: APIURL.animal_detail, method: .post, parameters: animalRequest.toJSON()) { data in
      if let animalResponse = AnimalModel(JSON: data), Tools.shared.isSuccessResponse(response: animalResponse) {
        self.animalRequest = animalResponse
        self.petImageUrl = animalResponse.animal_img_path ?? ""
        self.petImageView.sd_setImage(with: URL(string: "\(baseURL)\(animalResponse.animal_img_path ?? "")"), placeholderImage: UIImage(named: "btn_photo"), options: .lowPriority, completed: nil)
        self.petNameTextField.text = animalResponse.animal_name
        self.groupTextField.text = animalResponse.first_category_name
        self.breedTextField.text = animalResponse.second_category_name
        
        if let birth = animalResponse.animal_birth {
          let birthArray = birth.components(separatedBy: "-")
          self.birthYearTextField.text = birthArray[0]
          self.birthMonthTextField.text = birthArray[1]
        }
//        self.animalListKind(parent_category_management_idx: animalResponse.first_category_idx ?? "")
        
        self.genderMButton.isSelected = animalResponse.animal_gender == "0"
        self.genderFButton.isSelected = animalResponse.animal_gender == "1"
        self.neutralOButton.isSelected = animalResponse.animal_neuter == "Y"
        self.neutralXButton.isSelected = animalResponse.animal_neuter == "N"
        self.trainedButton.isSelected = animalResponse.animal_training == "Y"
        self.notTrainedButton.isSelected = animalResponse.animal_training == "N"
        self.gentleButton.isSelected = animalResponse.animal_character == "0"
        self.biteButton.isSelected = animalResponse.animal_character == "1"
        self.curiosButton.isSelected = animalResponse.animal_character == "2"
        self.activeButton.isSelected = animalResponse.animal_character == "3"
        self.healthyButton.isSelected = animalResponse.animal_health == "0"
        self.normalHealthButton.isSelected = animalResponse.animal_health == "1"
        self.needCautionButton.isSelected = animalResponse.animal_health == "2"
        self.setButtonUI()
      }
    } fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }
  }
  
  /// 반려견 수정
  func animalModUpAPI() {
    self.animalRequest.animal_img_path = self.petImageUrl
    self.animalRequest.animal_name = self.petNameTextField.text
    self.animalRequest.animal_gender = self.genderMButton.isSelected ? "0" : self.genderFButton.isSelected ? "1" : ""
    self.animalRequest.animal_neuter = self.neutralOButton.isSelected ? "Y" : self.neutralXButton.isSelected ? "N" : ""
    self.animalRequest.animal_birth = "\(self.birthYearTextField.text ?? "")-\(self.birthMonthTextField.text ?? "")"
    self.animalRequest.animal_training = self.trainedButton.isSelected ? "Y" : self.notTrainedButton.isSelected ? "N" : ""
    if self.gentleButton.isSelected {
      self.animalRequest.animal_character = "0"
    } else if self.biteButton.isSelected {
      self.animalRequest.animal_character = "1"
    } else if self.curiosButton.isSelected {
      self.animalRequest.animal_character = "2"
    } else if self.activeButton.isSelected {
      self.animalRequest.animal_character = "3"
    }
    if self.healthyButton.isSelected {
      self.animalRequest.animal_health = "0"
    } else if self.normalHealthButton.isSelected {
      self.animalRequest.animal_health = "1"
    } else if self.needCautionButton.isSelected {
      self.animalRequest.animal_health = "2"
    }
    
    APIRouter.shared.api(path: APIURL.animal_mod_up, method: .post, parameters: self.animalRequest.toJSON()) { data in
      if let animalResponse = AnimalModel(JSON: data), Tools.shared.isSuccessResponse(response: animalResponse) {
        NotificationCenter.default.post(name: Notification.Name("MyPetListUpdate"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("MainUpdate"), object: nil)
        self.navigationController?.popViewController(animated: true)
      }
    } fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 성별 선택
  /// - Parameter sender: UIButton
  @IBAction func genderButtonTouched(sender:UIButton) {
    if sender == self.genderMButton {
      self.genderMButton.isSelected = true
      self.genderFButton.isSelected = false
    } else {
      self.genderMButton.isSelected = false
      self.genderFButton.isSelected = true
    }
    self.setButtonUI()
  }
  
  /// 중성화 여부 선택
  /// - Parameter sender: UIButton
  @IBAction func neutralButtonTouched(sender:UIButton) {
    if sender == self.neutralOButton {
      self.neutralOButton.isSelected = true
      self.neutralXButton.isSelected = false
    } else {
      self.neutralOButton.isSelected = false
      self.neutralXButton.isSelected = true
    }
    
    self.setButtonUI()
  }
  
  /// 훈련 여부 선택
  /// - Parameter sender: UIButton
  @IBAction func trainedButtonTouched(sender:UIButton) {
    if sender == self.trainedButton {
      self.trainedButton.isSelected = true
      self.notTrainedButton.isSelected = false
    } else {
      self.trainedButton.isSelected = false
      self.notTrainedButton.isSelected = true
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
    if sender == self.gentleButton {
      self.gentleButton.isSelected = true
    } else if sender == self.biteButton {
      self.biteButton.isSelected = true
    } else if sender == self.curiosButton {
      self.curiosButton.isSelected = true
    } else {
      self.activeButton.isSelected = true
    }
    self.setButtonUI()
  }
  /// 건강상태
  /// - Parameter sender: UIButton
  @IBAction func healthButtonTouched(sender: UIButton) {
    self.healthyButton.isSelected = false
    self.normalHealthButton.isSelected = false
    self.needCautionButton.isSelected = false
    if sender == self.healthyButton {
      self.healthyButton.isSelected = true
    } else if sender == self.normalHealthButton {
      self.normalHealthButton.isSelected = true
    } else {
      self.needCautionButton.isSelected = true
    }
    self.setButtonUI()
  }
  
  
  /// 취소
  /// - Parameter sender: UIButton
  @IBAction func cancelButtonTouched(sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
  
  /// 저장하기
  /// - Parameter sender: UIButton
  @IBAction func saveButtonTouched(sender: UIButton) {
    guard self.birthYearTextField.text != "" || self.birthMonthTextField.text != "" else {
      Tools.shared.showToast(message: "나이를 입력하여 주세요.")
      return
    }
    
    if self.animal_idx != "" {
      self.animalModUpAPI()
    } else {
      self.animalRegInAPI()
    }
    
  }
}



//-------------------------------------------------------------------------------------------
// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
//-------------------------------------------------------------------------------------------
extension RegistPetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
    imagePickerController(picker, pickedImage: image)
    
  }
  
  @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
    let cropController = CropViewController(croppingStyle: .default, image: pickedImage!)
    
    cropController.title = ""
    let rectWidth = pickedImage!.size.width
    let rectHeight = pickedImage!.size.width
    
    cropController.imageCropFrame = CGRect(x: 0, y: 0, width: rectWidth, height: rectHeight)
    cropController.rotateButtonsHidden = true
    cropController.rotateClockwiseButtonHidden = true
    cropController.aspectRatioPickerButtonHidden = true
    cropController.hidesNavigationBar = true
    cropController.resetAspectRatioEnabled = false
    cropController.aspectRatioLockEnabled = true
    cropController.aspectRatioLockDimensionSwapEnabled = false
    cropController.resetButtonHidden = true
    
    cropController.doneButtonTitle = "완료"
    cropController.cancelButtonTitle = "취소"
    cropController.cancelButtonColor = .white
    cropController.delegate = self
    
    
    picker.dismiss(animated: true) {
      cropController.modalPresentationStyle = .fullScreen
      self.present(cropController, animated: true, completion: nil)
    }
  }
}


//-------------------------------------------------------------------------------------------
// MARK: - CropViewControllerDelegate
//-------------------------------------------------------------------------------------------
extension RegistPetViewController: CropViewControllerDelegate {
  func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
    let data = image.jpegData(compressionQuality: 0.6) ?? Data()
    self.uploadImages(imageData: data)
    
    cropViewController.dismiss(animated: true, completion: nil)
  }
}
