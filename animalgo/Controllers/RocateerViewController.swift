//
//  RocateerViewController.swift
//  animalgo
//
//  Created by rocket on 11/06/2019.
//  Copyright © 2019 rocateer. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import SDWebImage
import SKPhotoBrowser
import NVActivityIndicatorView
import Hero
import NotificationBannerSwift

class RocateerViewController: UIViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var appDelegate: AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
  }
  
  
  /// 테이블뷰 로드 되기 전.
  private let startLoadingOffset: CGFloat = 20.0
  var isLoadingList = true
  var leftSwipeGesture = UIScreenEdgePanGestureRecognizer()
  
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    log.info("#################################################")
    log.info("# View Controller : \(self.className)")
    log.info("#################################################")
    self.view.layoutIfNeeded()
    self.view.setNeedsLayout()
    self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    
    
    self.initLayout()
    self.initLocalize()
    self.initRequest()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.view.endEditing(true)
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func initLayout() {
    self.leftSwipeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(leftSwipeDismiss(gestureRecognizer:)))
    self.leftSwipeGesture.edges = .left

    if self.navigationController?.viewControllers.count == 1
        && ((self.navigationController?.hero.isEnabled ?? false) || (self.hero.isEnabled)) {
      self.view.addGestureRecognizer(self.leftSwipeGesture)
    }
  }
  
  func initRequest() {
    
  }
  
  @objc func initLocalize() {
    
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  
  /// Swipe dismiss
  /// - Parameter gestureRecognizer: UIScreenEdgePanGestureRecognizer
  @objc func leftSwipeDismiss(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
    let translation = self.leftSwipeGesture.translation(in: nil)
    let progress = translation.x / 1.6 / view.bounds.width
    let gestureView = gestureRecognizer.location(in: self.view)
    switch self.leftSwipeGesture.state {
    case .began:
      if gestureView.x <= 80 {
        hero.dismissViewController()
      }
    case .changed:
      let translation = self.leftSwipeGesture.translation(in: nil)
      let progress = translation.x / 1.6 / view.bounds.width
      Hero.shared.update(progress)
    default:
      if progress + self.leftSwipeGesture.velocity(in: nil).x / view.bounds.width > 0.3 {
        Hero.shared.finish()
        log.debug("finish")
      } else {
        Hero.shared.cancel()
        log.debug("cancel")
      }
    }
  }
  
  
  /// 뷰컨트롤러에 네비게이션 컨트롤러를 추가해 준다.
  ///
  /// - Returns: UINavigationController
  func coverNavigationController() -> UINavigationController {
    let navigationController = UINavigationController(rootViewController: self)
    return navigationController
  }
  
  /// 화면 닫기
  func closeViewController() {
    self.view.endEditing(true)
    if let navigation = self.navigationController {
      if navigation.viewControllers.count == 1 {
        self.dismiss(animated: true, completion: nil)
      } else {
        navigation.popViewController(animated: true)
      }
    } else {
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBAction
  //-------------------------------------------------------------------------------------------
  /// [공통]뒤로가기 버튼 눌렀을 때.
  ///
  /// - Parameter sender: barButton
  @IBAction func backButtonTouched(sender: UIBarButtonItem) {
    self.view.endEditing(true)
    if let navigation = self.navigationController {
      if navigation.viewControllers.count == 1 {
        self.dismiss(animated: true, completion: nil)
      } else {
        navigation.popViewController(animated: true)
      }
    } else {
      self.dismiss(animated: true, completion: nil)
    }
  }
  
}

//-------------------------------------------------------------------------------------------
// MARK: - StoryBoardHelper
//-------------------------------------------------------------------------------------------
protocol StoryBoardHelper {}
extension UIViewController: StoryBoardHelper {}
extension StoryBoardHelper where Self: UIViewController {
  static func instantiate() -> Self {
    let storyboard = UIStoryboard(name: self.className, bundle: nil)
    return storyboard.instantiateViewController(withIdentifier: self.className) as! Self
  }
  
  static func instantiate(storyboard: String) -> Self {
    let storyboard = UIStoryboard(name: storyboard, bundle: nil)
    return storyboard.instantiateViewController(withIdentifier: self.className) as! Self
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UIGestureRecognizerDelegate
//-------------------------------------------------------------------------------------------
extension RocateerViewController: UIGestureRecognizerDelegate {
}

