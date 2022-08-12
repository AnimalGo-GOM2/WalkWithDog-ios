//
//  CardPopupViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/10.
//  Copyright © 2021 rocateer. All rights reserved.
//
import UIKit

protocol SelectedCardPopupDelegate {
  func cancelTouched()
  func denyTouched()
  func reportTouched()
  func blockTouched()
}

class CardPopupViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var cancelWalkButton: UIButton!
  @IBOutlet weak var reportButton: UIButton!
  @IBOutlet weak var blockButton: UIButton!
  @IBOutlet weak var closeButton: UIButton!
  @IBOutlet weak var denyButton: UIButton!
  @IBOutlet weak var cardViewTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var dimmerView: UIView!
  @IBOutlet weak var cardView: UIView!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var popupHeight: CGFloat = 0
  let statusHeight = UIApplication.shared.windows.first {$0.isKeyWindow}?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0
  let window = UIApplication.shared.windows.first {$0.isKeyWindow}
  var fromView = ""
  let bottomPadding = UIApplication.shared.windows.first {$0.isKeyWindow}?.safeAreaInsets.bottom ?? 0.0
  var delegate: SelectedCardPopupDelegate?
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.cardViewTopConstraint.constant = self.view.safeAreaLayoutGuide.layoutFrame.height + self.bottomPadding
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    
    self.cardView.clipsToBounds = true
    self.cardView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    self.dimmerView.alpha = 0.0
    
    self.closeButton.addBorderTop(size: 1, color: UIColor(named: "F9F9F9")!)
    
    if fromView == "registedFriendAsk" {
      self.reportButton.isHidden = true
      self.blockButton.isHidden = true
      self.denyButton.isHidden = true
      self.popupHeight = 64 * 2
    } else if fromView == "appliedFriendAsk" {
      self.reportButton.isHidden = true
      self.blockButton.isHidden = true
      self.denyButton.setTitle("지원 취소", for: .normal)
      self.cancelWalkButton.isHidden = true
      self.popupHeight = 64 * 2
    } else if fromView == "walkTracking"{
      self.reportButton.isHidden = true
      self.blockButton.isHidden = true
      self.denyButton.isHidden = true
      self.popupHeight = 64 * 2
    }else if fromView == "appliedChat"{
      self.cancelWalkButton.isHidden = true
      self.denyButton.setTitle("지원 취소", for: .normal)
      self.popupHeight = 64 * 4
    }else if fromView == "registedChat"{
      self.popupHeight = 64 * 5
    }else {
      self.cancelWalkButton.isHidden = true
      self.denyButton.isHidden = true
      self.popupHeight = 64 * 3
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
                self.delegate?.cancelTouched()
              } else if type == 1 {
                self.delegate?.denyTouched()
              } else if type == 2 {
                self.delegate?.reportTouched()
              } else if type == 3 {
                self.delegate?.blockTouched()
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
  /// 하단 팝업 버튼 터치 이벤트
  /// - Parameter sender: 버튼
  @IBAction func buttonTouched(sender: UIButton) {
    self.hideCardAndGoBack(type: sender.tag)
  }
  
  /// 취소
  /// - Parameter sender: 버튼
  @IBAction func closeButtonTouched(sender: UIButton) {
    self.hideCardAndGoBack(type: nil)
  }
}
