//
//  MessageListViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/18.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import Parchment

class MessageListViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var messageView: UIView!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //------------------------------------------------------------------------------------------
  var pagingViewController = PagingViewController()
  var sendListViewController = SendListViewController.instantiate(storyboard: "Home")
  var receiveListViewController = ReceiveListViewController.instantiate(storyboard: "Home")
  var state = "" // send, receive
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    self.pagingViewController = PagingViewController(viewControllers: [
      self.receiveListViewController,
      self.sendListViewController
    ])
    self.pagingViewController.delegate = self
    self.pagingViewController.menuItemSize = .fixed(width: self.view.frame.size.width / 2, height: 50)
    self.pagingViewController.menuItemLabelSpacing = 0
    self.pagingViewController.indicatorColor = UIColor(named: "accent")!
    self.pagingViewController.indicatorOptions = PagingIndicatorOptions.visible(height: 3, zIndex: 0, spacing: UIEdgeInsets(top: 0, left: 70, bottom: 0, right: 70), insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    self.pagingViewController.menuInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    self.pagingViewController.borderColor = UIColor(named: "F9F9F9")!
    self.pagingViewController.borderOptions = PagingBorderOptions.visible(height: 0, zIndex: 0, insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    self.pagingViewController.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    self.pagingViewController.textColor = UIColor(named: "CCCCCC")!
    self.pagingViewController.selectedFont = UIFont.systemFont(ofSize: 16, weight: .bold)
    self.pagingViewController.selectedTextColor = .black

    
    self.addChild(self.pagingViewController)
    self.messageView.addSubview(self.pagingViewController.view)
    self.messageView.constrainToEdges(self.pagingViewController.view)
    
    self.pagingViewController.didMove(toParent: self)
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    
  }
  
  override func initRequest() {
    super.initRequest()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 보내기
  /// - Parameter sender: UIButton
  @IBAction func sendButtonTouched(sender: UIButton) {
    let destination = ReceiverFindViewController.instantiate(storyboard: "Home")
    self.navigationController?.pushViewController(destination, animated: true)
  }
  
  /// 쪽지 찾기
  /// - Parameter sender: UIBarButtonItem
  @IBAction func findButtonTouched(sender: UIBarButtonItem) {
    let destination = FindMessageViewController.instantiate(storyboard: "Home")
    if self.state == "send" {
      destination.msgType = .send
    } else {
      destination.msgType = .recieve
    }
    self.navigationController?.pushViewController(destination, animated: true)
    
    
  }
}

extension MessageListViewController : PagingViewControllerDelegate {
  func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {

    if self.pagingViewController.visibleItems.indexPath(for: pagingItem)?.row == 0 {
      self.state = "receive"
    } else {
      self.state = "send"
    }
    
    
  }
}
