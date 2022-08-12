//
//  RegistPopupViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/15.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit

protocol PetSelectPopupDelegate {
  func cancelButtonTouched()
  func registButtonTouched(animal_idx: String, comment: String)
}
class RegistPopupViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var registButton: UIButton!
  @IBOutlet weak var selectPetTableView: UITableView!
  @IBOutlet weak var messageTextView: UITextView!
  @IBOutlet weak var cardViewTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var dimmerView: UIView!
  @IBOutlet weak var cardView: UIView!
  @IBOutlet weak var listTableHeightConstraint: NSLayoutConstraint!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var popupHeight: CGFloat = 0
  let statusHeight = UIApplication.shared.windows.first {$0.isKeyWindow}?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0
  let window = UIApplication.shared.windows.first {$0.isKeyWindow}
  let bottomPadding = UIApplication.shared.windows.first {$0.isKeyWindow}?.safeAreaInsets.bottom ?? 0.0
  var delegate: PetSelectPopupDelegate?
  var record_idx: String?
  var petList = [AnimalModel]()
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.cardViewTopConstraint.constant = self.view.safeAreaLayoutGuide.layoutFrame.height + self.bottomPadding
    self.petList = self.appDelegate.myAnimalList
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    self.registButton.setCornerRadius(radius: 10)
    self.cancelButton.setCornerRadius(radius: 10)
    
    self.cardView.clipsToBounds = true
    self.cardView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    self.dimmerView.alpha = 0.0
    
    self.selectPetTableView.registerCell(type: SelPetPopupCell.self)
    self.selectPetTableView.dataSource = self
    self.selectPetTableView.delegate = self
    
    
    let maxHeight = self.view.safeAreaLayoutGuide.layoutFrame.height - 100
    let tableRowHeight = 50 * self.appDelegate.myAnimalList.count.toCGFloat
    let viewHeight: CGFloat = 316
    
    if maxHeight < viewHeight + tableRowHeight {
      self.popupHeight = maxHeight
      self.listTableHeightConstraint.constant = self.popupHeight - viewHeight
    } else {
      self.popupHeight = viewHeight + tableRowHeight
      self.listTableHeightConstraint.constant = tableRowHeight
    }
    
    
  }
  
  override func initRequest() {
    super.initRequest()
    
    self.dimmerView.addTapGesture { (recognizer) in
      self.hideCardAndGoBack(type: nil)
    }
    
    self.dimmerView.addSwipeGesture(direction: UISwipeGestureRecognizer.Direction.down) { (recognizer) in
      self.hideCardAndGoBack(type: nil)
    }
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.showCard()
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 카드 보이기
  private func showCard() {
    self.view.layoutIfNeeded()
    log.debug("statusHeight : \(statusHeight)")
    
    self.cardViewTopConstraint.constant = self.view.frame.size.height - (self.popupHeight + bottomPadding + self.statusHeight)
    
    let showCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
      self.view.layoutIfNeeded()
    })
    
    showCard.addAnimations({
      self.dimmerView.alpha = 0.7
    })
    
    showCard.startAnimation()
    
  }
  
  /// 카드 숨기면서 화면 닫기
  private func hideCardAndGoBack(type: Int?) {
    self.view.layoutIfNeeded()
    let bottomPadding = self.window?.safeAreaInsets.bottom ?? 0.0
    self.cardViewTopConstraint.constant = self.view.safeAreaLayoutGuide.layoutFrame.height + bottomPadding
    
    let hideCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
      self.view.layoutIfNeeded()
    })
    
    hideCard.addAnimations {
      self.dimmerView.alpha = 0.0
    }
    
    hideCard.addCompletion({ position in
      if position == .end {
        if(self.presentingViewController != nil) {
          self.dismiss(animated: false) {
            if type != nil {
              if type == 0 {
                self.delegate?.cancelButtonTouched()
              } else if type == 1 {
                var animalIdxs = [String]()
                for value in self.petList {
                  if value.isSelected ?? false {
                    animalIdxs.append(value.animal_idx ?? "")
                  }
                }
                self.delegate?.registButtonTouched(animal_idx: animalIdxs.joined(separator: ","), comment: self.messageTextView.text)
              }
            }
          }
        }
      }
    })
    
    hideCard.startAnimation()
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  @IBAction func cancelButtonTouched(sender:UIButton) {
    hideCardAndGoBack(type: nil)
  }
  @IBAction func registButtonTouched(sender: UIButton) {
    var isSelected = false
    for value in self.petList {
      if (value.isSelected ?? false) {
        isSelected = true
      }
    }
    guard isSelected else {
      AJAlertController.initialization().showAlertWithOkButton(astrTitle: "", aStrMessage: "함께 산책 할 반려견을 선택하여 주세요.", alertViewHiddenCheck: false) { position, title in
        
      }
      return
    }
    
    guard self.messageTextView.text != "" else {
      AJAlertController.initialization().showAlertWithOkButton(astrTitle: "", aStrMessage: "첫 대화 메세지는 필수 입니다.", alertViewHiddenCheck: false) { position, title in
        
      }
      return
    }
    hideCardAndGoBack(type: 1)
  }
}


//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDataSource
//-------------------------------------------------------------------------------------------
extension RegistPopupViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.petList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SelPetPopupCell", for: indexPath) as! SelPetPopupCell
    let petData = self.petList[indexPath.row]
    cell.petImageView.sd_setImage(with: URL(string: Tools.shared.thumbnailImageUrl(url: petData.animal_img_path ?? "")), placeholderImage: UIImage(named: "default_dog1"), options: .lowPriority, context: nil)
    cell.petNameLabel.text = petData.animal_name
    cell.checkButton.isSelected = petData.isSelected ?? false
    
    cell.addTapGesture { recognizer in
      petData.isSelected = !(petData.isSelected ?? false)
      self.selectPetTableView.reloadData()
    }
    return cell
  }
}
//-------------------------------------------------------------------------------------------
// MARK: - UITableViewDelegate
//-------------------------------------------------------------------------------------------
extension RegistPopupViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    log.debug("\(indexPath.section) - \(indexPath.row)")
    
  }
}
