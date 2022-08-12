//
//  RecordViewController.swift
//  animalgo
//
//  Created by rocateer on 2021/10/29.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import Parchment

class RecordViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var recordView: UIView!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var pagingViewController = PagingViewController()
  var withMyPetViewController = WithMyPetViewController.instantiate(storyboard: "Record")
  var withMyFriendViewController = WithMyFriendViewController.instantiate(storyboard: "Record")
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    self.pagingViewController = PagingViewController(viewControllers: [
      self.withMyPetViewController,
      self.withMyFriendViewController
    ])

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
    self.recordView.addSubview(self.pagingViewController.view)
    self.recordView.constrainToEdges(self.pagingViewController.view)
    
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
  /// 산책하러가기
  /// - Parameter sender: UIButton
  @IBAction func goWalkButtonTouched(sender: UIButton) {
    self.tabBarController?.selectedIndex = 1
  }
}
