//
//  AJAlertController.swift
//  bike
//
//  Created by Rocateerimac on 2018. 12. 27..
//  Copyright © 2018년 rocket. All rights reserved.
//

import UIKit
import Foundation
import EZSwiftExtensions

class AJAlertController: UIViewController {
  
  // MARK:- Private Properties
  private var strAlertTitle = ""
  private var strAlertText = String()
  private var btnCancelTitle:String?
  private var btnOtherTitle:String?
  private let btnOtherColor  = UIColor.white
  private let btnCancelColor = UIColor.white
  
  // MARK:- Public Properties
  @IBOutlet var viewAlert: UIView!
  @IBOutlet var lblTitle: UILabel!
  @IBOutlet var lblAlertText: UILabel?
  @IBOutlet var btnCancel: UIButton!
  @IBOutlet var btnOther: UIButton!
  @IBOutlet var btnOK: UIButton!
//  @IBOutlet var viewAlertBtns: UIView!
  //  @IBOutlet var alertImageView: UIImageView!
  @IBOutlet var alertWidthConstraint: NSLayoutConstraint!
  
  /// AlertController Completion handler
  typealias alertCompletionBlock = ((Int, String) -> Void)?
  private var block : alertCompletionBlock?
  var alertViewHidden = false
  // MARK:- AJAlertController Initialization
  
  /**
   Creates a instance for using AJAlertController
   - returns: AJAlertController
   */
  static func initialization() -> AJAlertController {
    let alertController = AJAlertController(nibName: "AJAlertController", bundle: nil)
    return alertController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupAJAlertController()
    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
  }
  
  // MARK:- AJAlertController Private Functions
  
  /// Inital View Setup
  private func setupAJAlertController() {
    // 배경 흐리게
//    let visualEffectView   = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
//    visualEffectView.alpha = 1
//    visualEffectView.frame = self.view.bounds
//    visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//    visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapped)))
//    self.view.insertSubview(visualEffectView, at: 0)
    
    preferredAlertWidth()
    
    viewAlert.layer.cornerRadius  = 10.0
    viewAlert.layer.shadowOffset  = CGSize(width: 0.0, height: 0.0)
    viewAlert.layer.shadowColor   = UIColor(white: 0.0, alpha: 1.0).cgColor
    viewAlert.layer.shadowOpacity = 0.3
    viewAlert.layer.shadowRadius  = 18.0
    
    lblTitle.text   = strAlertTitle
    lblAlertText?.text   = strAlertText
    
    if let aCancelTitle = btnCancelTitle {
      btnCancel.setCornerRadius(radius: 10)
      btnCancel.setTitle(aCancelTitle, for: .normal)
      btnCancel.setTitleColor(btnCancelColor, for: .normal)
      btnOK.setTitle(nil, for: .normal)
      btnOK.setCornerRadius(radius: 10)
    } else {
      btnCancel.isHidden  = true
    }
    
    if self.alertViewHidden {
      //      self.alertImageView.isHidden = true
    }
    
    if let aOtherTitle = btnOtherTitle {
      btnOther.setTitle(aOtherTitle, for: .normal)
      btnOther.setCornerRadius(radius: 10)
      btnOK.setTitle(nil, for: .normal)
      btnOK.setCornerRadius(radius: 10)
      btnOther.setTitleColor(btnOtherColor, for: .normal)
      btnOther.setCornerRadius(radius: 10)
    } else {
      btnOther.isHidden  = true
    }
    
    if btnOK.title(for: .normal) != nil {
      btnOK.setTitleColor(btnOtherColor, for: .normal)
      btnOK.setCornerRadius(radius: 10)
    } else {
      btnOK.isHidden  = true
    }
  }
  
  /// Setup different widths for iPad and iPhone
  private func preferredAlertWidth() {
    switch UIDevice.current.userInterfaceIdiom {
    case .phone:
      alertWidthConstraint.constant = 280.0
    case .pad:
      alertWidthConstraint.constant = 340.0
    case .mac : break
    case .unspecified: break
    case .tv: break
    case .carPlay: break
    @unknown default: break
    }
  }
  
  /// Create and Configure Alert Controller
  private func configure(title: String, message:String, btnCancelTitle:String?, btnOtherTitle:String?) {
    self.strAlertTitle    = title
    self.strAlertText     = message
    self.btnCancelTitle   = btnCancelTitle
    self.btnOtherTitle    = btnOtherTitle
  }
  
  /// Show Alert Controller
  private func show() {
    let sceneDelegate = UIApplication.shared.connectedScenes .first!.delegate as! SceneDelegate
    if let window = sceneDelegate.window, let rootViewController = window.rootViewController {
      
      var topViewController = rootViewController
      while topViewController.presentedViewController != nil {
        topViewController = topViewController.presentedViewController!
      }
      
      topViewController.addChild(self)
      topViewController.view.addSubview(view)
      viewWillAppear(true)
      didMove(toParent: topViewController)
      view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      view.alpha = 0.0
      view.frame = topViewController.view.bounds
      
      viewAlert.alpha     = 0.0
      UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
        self.view.alpha = 1.0
      }, completion: nil)
      
      viewAlert.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
      viewAlert.center    = CGPoint(x: (self.view.bounds.size.width/2.0), y: (self.view.bounds.size.height/2.0)-10)
      UIView.animate(withDuration: 0.2 , delay: 0.1, options: .curveEaseOut, animations: { () -> Void in
        self.viewAlert.alpha = 1.0
        self.viewAlert.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        self.viewAlert.center    = CGPoint(x: (self.view.bounds.size.width/2.0), y: (self.view.bounds.size.height/2.0))
      }, completion: nil)
    }
  }
  
  /// Hide Alert Controller
  private func hide() -> Bool {
    self.view.endEditing(true)
    self.viewAlert.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: { () -> Void in
      self.viewAlert.alpha = 0.0
      self.viewAlert.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
      self.viewAlert.center    = CGPoint(x: (self.view.bounds.size.width/2.0), y: (self.view.bounds.size.height/2.0)-5)
    }, completion: nil)
    
    UIView.animate(withDuration: 0.25, delay: 0.05, options: .curveEaseIn, animations: { () -> Void in
      self.view.alpha = 0.0
      self.view.removeFromSuperview()
      self.removeFromParent()
    }) { (completed) -> Void in
      
      
    }
    
    return true
  }
  
  // MARK:- UIButton Clicks
  @IBAction func btnCancelTapped(sender: UIButton) {
    var _ = hide()
    block!!(0,btnCancelTitle!)
    
  }
  
  @IBAction func btnOtherTapped(sender: UIButton) {
    var _ = hide()
    block!!(1,btnOtherTitle!)
    
  }
  
  @IBAction func btnOkTapped(sender: UIButton){
    var _ = hide()
    block!!(0,"확인")
    
  }
  
  /// Hide Alert Controller on background tap
  @objc func backgroundViewTapped(sender:AnyObject) {
    // hide()
  }
  
  // MARK:- AJAlert Functions
  /**
   Display an Alert
   
   - parameter aStrMessage:    Message to display in Alert
   - parameter aCancelBtnTitle: Cancel button title
   - parameter aOtherBtnTitle: Other button title
   - parameter otherButtonArr: Array of other button title
   - parameter completion:     Completion block. Other Button Index - 1 and Cancel Button Index - 0
   */
  
  public func showAlert(astrTitle: String, aStrMessage: String, aCancelBtnTitle: String?, aOtherBtnTitle: String?, completion : alertCompletionBlock) {
    configure(title: astrTitle, message: aStrMessage, btnCancelTitle: aCancelBtnTitle, btnOtherTitle: aOtherBtnTitle)
    show()
    block = completion
  }
  
  /**
   Display an Alert With "OK" Button
   
   - parameter aStrMessage: Message to display in Alert
   - parameter completion:  Completion block. OK Button Index - 0
   */
  
  // 2018-03-29 sn
  // astrTitle add
  // aImageViewCheck add
  public func showAlertWithOkButton(astrTitle: String, aStrMessage: String, alertViewHiddenCheck: Bool, completion : alertCompletionBlock){
    alertViewHidden = alertViewHiddenCheck
    configure(title: astrTitle, message: aStrMessage, btnCancelTitle: nil, btnOtherTitle: nil)
    show()
    block = completion
  }
}
