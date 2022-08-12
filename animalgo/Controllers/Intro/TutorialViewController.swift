//
//  TutorialViewController.swift
//  animalgo
//
//  Created by rocateer on 2020/01/03.
//  Copyright © 2020 rocateer. All rights reserved.
//

import UIKit
import Defaults

class TutorialViewController: RocateerViewController {
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var tutorialCollectionView: UICollectionView!
  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var startButton: UIButton!
  @IBOutlet weak var bottomView: UIView!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var tutoricalCount = 5
  
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  
  override func viewDidLoad() {
    super.viewDidLoad()

    self.tutorialCollectionView.registerCell(type: TutorialCell.self)
    self.tutorialCollectionView.delegate = self
    self.tutorialCollectionView.dataSource = self
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
  /// 시작 버튼 터치시
  ///
  /// - Parameter sender: 버튼
  @IBAction func startButtonTouched(sender: UIButton) {
    Defaults[.tutorial] = true

    let destination = LoginViewController.instantiate(storyboard: "Login").coverNavigationController()
    let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    window?.rootViewController = destination
  }
  
}

//-------------------------------------------------------------------------------------------
// MARK: UICollectionViewDataSource
//-------------------------------------------------------------------------------------------
extension TutorialViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.tutoricalCount
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorialCell", for: indexPath) as! TutorialCell

    cell.tutorialImageView.image = UIImage(named: "tutorial_0\(indexPath.row + 1)")
    
    return cell
  }
  
}


//-------------------------------------------------------------------------------------------
// MARK: UICollectionViewDelegate
//-------------------------------------------------------------------------------------------
extension TutorialViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  }
  
}

//-------------------------------------------------------------------------------------------
// MARK: UICollectionViewDelegateFlowLayout
//-------------------------------------------------------------------------------------------
extension TutorialViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let window = UIApplication.shared.windows.first!
    let statusHeight = window.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0
    let bottomPadding = window.safeAreaInsets.bottom
    
    let height = self.view.frame.size.height + statusHeight + bottomPadding
    return CGSize(width: self.view.frame.size.width, height: height)
  }
}

extension TutorialViewController: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let pageWidth = self.tutorialCollectionView.frame.width
    let currentPage = Int(self.tutorialCollectionView.contentOffset.x / pageWidth)
    self.pageControl.currentPage = currentPage
    
    if self.pageControl.currentPage == self.tutoricalCount - 1 {
      self.startButton.isHidden = false
      self.pageControl.isHidden = true
      self.bottomView.backgroundColor = UIColor(named: "accent")!
    } else {
      self.startButton.isHidden = true
      self.pageControl.isHidden = false
      self.bottomView.backgroundColor = .clear
    }
  }
}
