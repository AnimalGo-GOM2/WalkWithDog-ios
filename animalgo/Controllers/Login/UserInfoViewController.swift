//
//  UserInfoViewController.swift
//  animalgo
//
//  Created by rocateer on 2020/03/03.
//  Copyright © 2020 rocateer. All rights reserved.
//

import UIKit
import Defaults
import CropViewController

class UserInfoViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var memberImageView: UIImageView!
  @IBOutlet weak var idLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var nicknameTextField: UITextField!
  @IBOutlet weak var birthTextField: UITextField!
  @IBOutlet weak var phoneTextField: UITextField!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var memberImageUrl = ""
  
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let datePickerView: UIDatePicker = UIDatePicker()
    datePickerView.datePickerMode = .date
    datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControl.Event.valueChanged)
    datePickerView.maximumDate = Date()
    self.birthTextField.inputView = datePickerView
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    self.memberImageView.addBorder(width: 1, color: UIColor(named: "333333")!)
  }
  
  override func initRequest() {
    super.initRequest()
    self.memberInfoDetail()
    
    /// 프로필 이미지 수정
    self.memberImageView.addTapGesture { (recognizer) in
      self.takeAPicture()
    }
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 날짜 변경시
  /// - Parameter sender: DatePicker
  @objc func datePickerValueChanged(sender: UIDatePicker) {
    self.birthTextField.text = sender.date.toString(format: "yyyy-MM-dd")
  }
  
  /// 회원정보 상세보기
  private func memberInfoDetail() {
    let memberReqeust = MemberModel()
    memberReqeust.member_idx = Defaults[.member_idx]
    
    APIRouter.shared.api(path: .member_info_detail, parameters: memberReqeust.toJSON()) { response in
      if let memberResponse = MemberModel(JSON: response), Tools.shared.isSuccessResponse(response: memberResponse) {
        self.memberImageView.sd_setImage(with: URL(string: memberResponse.member_img ?? ""), completed: nil)
        self.idLabel.text = memberResponse.member_id ?? ""
        self.nameLabel.text = memberResponse.member_name ?? ""
        self.nicknameTextField.text = memberResponse.member_nickname ?? ""
        self.birthTextField.text = memberResponse.member_birth ?? ""
        self.phoneTextField.text = memberResponse.member_phone ?? ""
      }
    } fail: { error in
      Tools.shared.showToast(message: "알수 없는 오류가 발생하였습니다.")
    }
  }
  
  
  /// 회원정보 수정
  private func memberInfoModUp() {
    let memberReqeust = MemberModel()
    memberReqeust.member_idx = Defaults[.member_idx]
    memberReqeust.member_img = self.memberImageUrl
    memberReqeust.member_name = self.nameLabel.text ?? ""
    memberReqeust.member_nickname = self.nicknameTextField.text ?? ""
    memberReqeust.member_phone = self.phoneTextField.text ?? ""
    memberReqeust.member_birth = self.birthTextField.text ?? ""
    memberReqeust.member_gender = "0"
    
    APIRouter.shared.api(path: .member_info_mod_up, parameters: memberReqeust.toJSON()) { response in
      if let memberResponse = MemberModel(JSON: response), Tools.shared.isSuccessResponse(response: memberResponse) {
        Tools.shared.showToast(message: "변경되었습니다.")
      }
    } fail: { error in
      Tools.shared.showToast(message: "알수 없는 오류가 발생하였습니다.")
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
    
    
    let albumAction = UIAlertAction(title: "앨범에서 사진 선택", style: UIAlertAction.Style.default) { (action) in
      let controller = UIImagePickerController()
      controller.delegate = self
      controller.sourceType = .photoLibrary
      self.present(controller, animated: true, completion: nil)
    }
    
    
    let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
    
    actionSheet.addAction(cameraAction)
    actionSheet.addAction(albumAction)
    actionSheet.addAction(cancelAction)
    
    self.present(actionSheet, animated: true, completion: nil)
  }
  
  /// 이미지 업로드
  ///
  /// - Parameter imageData: 업로드할 이미지
  func uploadImages(imageData : Data) {
    let param = ["": ""]
    
    APIRouter.shared.api(path: .fileUpload_action, file: imageData) { response in
      if let fileResponse = FileModel(JSON: response), Tools.shared.isSuccessResponse(response: fileResponse) {
        self.memberImageUrl = fileResponse.file_path ?? ""
        self.memberImageView.sd_setImage(with: URL(string: fileResponse.file_path ?? ""), completed: nil)
      }
    } fail: { error in
      Tools.shared.showToast(message: "알수 없는 오류가 발생하였습니다.")
    }

    

  }
  
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 회원정보 변경 버튼
  /// - Parameter sender: BarButton
  @IBAction func changeBarButtonToucehd(sender: UIBarButtonItem) {
    self.memberInfoModUp()
  }
  
}


//-------------------------------------------------------------------------------------------
// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
//-------------------------------------------------------------------------------------------
extension UserInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
extension UserInfoViewController: CropViewControllerDelegate {
  func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
    let data = image.jpegData(compressionQuality: 0.6) ?? Data()
    self.uploadImages(imageData: data)
    
    cropViewController.dismiss(animated: true, completion: nil)
  }
}
