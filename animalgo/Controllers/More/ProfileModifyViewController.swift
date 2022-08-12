//
//  ProfileModifyViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/04.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import CropViewController
import Defaults

class ProfileModifyViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var profileView: UIView!
  @IBOutlet weak var nickNameTextField: UITextField!
  @IBOutlet weak var genderLabel: UILabel!
  @IBOutlet weak var ageLabel: UILabel!
  @IBOutlet weak var confirmButton: UIButton!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var memberImageUrl = ""
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
    
    self.nickNameTextField.addBorderBottom(size: 1, color: UIColor(named: "EAE8E5")!)
    self.profileImageView.setCornerRadius(radius: 75)
    self.confirmButton.setCornerRadius(radius: 10)
    
    self.profileView.addTapGesture { recognizer in
      self.takeAPicture()
    }
    
  }
  
  override func initRequest() {
    super.initRequest()
    self.memberInfoDetailAPI()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 정보 상세보기API
  func memberInfoDetailAPI() {
    let memberRequest = MemberModel()
    memberRequest.member_idx = Defaults[.member_idx]
    
    APIRouter.shared.api(path: .member_info_detail, parameters: memberRequest.toJSON()) { response in
      if let memberResponse = MemberModel(JSON: response), Tools.shared.isSuccessResponse(response: memberResponse) {
        self.nickNameTextField.text = memberResponse.member_nickname
        if memberResponse.member_gender == "0" {
          self.genderLabel.text = "남"
        } else {
          self.genderLabel.text = "여"
        }
        self.ageLabel.text = "\(memberResponse.member_age ?? "")대"
        self.memberImageUrl = memberResponse.member_img ?? ""
        self.profileImageView.sd_setImage(with: URL(string: "\(baseURL)\(self.memberImageUrl)"), placeholderImage: UIImage(named: "default_profile"), options: .lowPriority, context: nil)
      }
    } fail: { error in
      Tools.shared.showToast(message: "알수 없는 오류가 발생하였습니다.")
    }
  }
  
  /// 정보 수정API
  func memberInfoModAPI() {
    let memberRequest = MemberModel()
    memberRequest.member_idx = Defaults[.member_idx]
    memberRequest.member_nickname = self.nickNameTextField.text
    memberRequest.member_img = self.memberImageUrl
    
    APIRouter.shared.api(path: .member_info_mod_up, parameters: memberRequest.toJSON()) { response in
      if let memberResponse = MemberModel(JSON: response), Tools.shared.isSuccessResponse(response: memberResponse) {
        Defaults[.member_nickname] = self.nickNameTextField.text
        AJAlertController.initialization().showAlertWithOkButton(astrTitle: "", aStrMessage: "정보가 수정되었습니다.", alertViewHiddenCheck: false){
          (position, title) in
          if position == 0 {
            NotificationCenter.default.post(name: Notification.Name("profileUpdate"), object: self.nickNameTextField.text)
            self.dismiss(animated: true, completion: nil)
          }
        }
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
    
    
    let albumAction = UIAlertAction(title: "앨범에서 선택", style: UIAlertAction.Style.default) { (action) in
      let controller = UIImagePickerController()
      controller.delegate = self
      self.present(controller, animated: true, completion: nil)
    }
    
    let deleteAction = UIAlertAction(title: "프로필 사진 삭제", style: UIAlertAction.Style.destructive) { (action) in
      self.profileImageView.image = UIImage(named: "default_profile")!
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
        self.memberImageUrl = fileResponse.file_path ?? ""
        self.profileImageView.sd_setImage(with: URL(string: "\(baseURL)\(fileResponse.file_path ?? "")"), completed: nil)
      }
    } fail: { error in
      Tools.shared.showToast(message: "알수 없는 오류가 발생하였습니다.")
    }
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 완료
  /// - Parameter sender: UIButton
  @IBAction func confirmButtonTouched(sender: UIButton) {
    self.memberInfoModAPI()
  }
}



//-------------------------------------------------------------------------------------------
// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
//-------------------------------------------------------------------------------------------
extension ProfileModifyViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
extension ProfileModifyViewController: CropViewControllerDelegate {
  func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
    let data = image.jpegData(compressionQuality: 0.6) ?? Data()
    self.uploadImages(imageData: data)
    
    cropViewController.dismiss(animated: true, completion: nil)
  }
}
