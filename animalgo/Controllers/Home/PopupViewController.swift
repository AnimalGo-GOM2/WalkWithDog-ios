//
//  PopupViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/19.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import Defaults

class PopupViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var dimmerView: UIView!
  @IBOutlet weak var cardView: UIView!
  @IBOutlet weak var cardViewTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var bannerImageView: UIImageView!
  @IBOutlet weak var imageHeight: NSLayoutConstraint!
  
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var cardPanStartingTopConstant : CGFloat = 0
  var panGestureRecognizer: UIPanGestureRecognizer!
  
  let window = UIApplication.shared.windows.first {$0.isKeyWindow}
  let statusHeight = UIApplication.shared.windows.first {$0.isKeyWindow}?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0
  let bottomPadding = UIApplication.shared.windows.first {$0.isKeyWindow}?.safeAreaInsets.bottom ?? 0.0
  var popupHeight: CGFloat = 0
  var eventData = EventModel()
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    self.cardViewTopConstraint.constant = self.view.safeAreaLayoutGuide.layoutFrame.height
    self.cardPanStartingTopConstant = self.view.safeAreaLayoutGuide.layoutFrame.height + bottomPadding
    self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.panRecognized))
    self.view.addGestureRecognizer(self.panGestureRecognizer)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    self.bannerImageView.sd_setImage(with: URL(string: "\(baseURL)\(self.eventData.img_path ?? "")"), completed: nil)
    
    // 팝업 상단 corner
    self.cardView.clipsToBounds = true
    self.cardView.layer.cornerRadius = 30
    self.cardView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
  }
  
  override func initRequest() {
    super.initRequest()
    
    
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
    
    let image:UIImage = UIImage(urlString: "\(baseURL)\(self.eventData.img_path ?? "")") ?? UIImage()
    let height: CGFloat = self.view.frame.width * (image.size.height / image.size.width)
    self.imageHeight.constant = height
    self.popupHeight = height + CGFloat(40)
    
    log.debug("\(self.view.frame.width)")
    log.debug("\(image.size.height)")
    log.debug("\(image.size.width)")
    
    self.cardViewTopConstraint.constant = (self.window?.frame.size.height ?? 0) - (self.popupHeight + self.statusHeight + self.bottomPadding)
    
    
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
            }
          }
        }
      }
    })
    
    hideCard.startAnimation()
  }
  
  /// 스와이프 닫기
  /// - Parameter recognizer: recognizer
  @objc func panRecognized(recognizer: UIPanGestureRecognizer) {
    let translation = recognizer.translation(in: self.view)
    
    switch recognizer.state {
    case .began:
      self.cardPanStartingTopConstant = self.cardViewTopConstraint.constant
    case .changed :
      if translation.y > 0 && self.cardPanStartingTopConstant + translation.y > self.cardPanStartingTopConstant {
        self.cardViewTopConstraint.constant = self.cardPanStartingTopConstant + translation.y
      }
    case .ended :
      let safeAreaHeight = self.view.safeAreaLayoutGuide.layoutFrame.height
      if self.cardViewTopConstraint.constant < (safeAreaHeight + self.bottomPadding) * 0.25 {
      } else if self.cardViewTopConstraint.constant < safeAreaHeight - 170 {
        self.showCard()
      } else {
        self.hideCardAndGoBack(type: nil)
      }
    default:
      break
    }
  }

  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  
  /// 닫기
  /// - Parameter sender: 버튼
  @IBAction func closeButtonTouched(sender: UIButton) {
    Defaults[.bannerDay] = nil
    self.hideCardAndGoBack(type: nil)
  }
  @IBAction func hide3DaysButtonTouched(sender: UIButton) {
    Defaults[.bannerDay] = Date()
    self.hideCardAndGoBack(type: nil)
  }
}
