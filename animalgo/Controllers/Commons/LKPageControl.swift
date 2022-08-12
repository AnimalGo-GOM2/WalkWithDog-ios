//
//  LKPageControl.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/09.
//  Copyright © 2021 rocateer. All rights reserved.
//
import UIKit

@IBDesignable
class LKPageControl: UIControl {
  //MARK:- Properties
  
  private var numberOfDots = [UIView]() {
    didSet{
      if numberOfDots.count == numberOfPages {
        setupViews()
      }
    }
  }
  
  @IBInspectable var numberOfPages: Int = 0 {
    didSet{
      
      for tag in 0 ..< numberOfPages {
        let dot = getDotView()
        dot.tag = tag
//        dot.backgroundColor = pageIndicatorTintColor
        self.numberOfDots.append(dot)
      }
      
    }
  }
  
  var currentPage: Int = 0 {
    didSet{
//      print("CurrentPage is \(currentPage)")
      self.setIndicatorView()
    }
  }
  
  @IBInspectable var pageIndicatorTintColor: UIColor? = .lightGray
  @IBInspectable var currentPageIndicatorTintColor: UIColor? = .darkGray
  
  private lazy var stackView = UIStackView.init(frame: self.bounds)
  private lazy var constantSpace = ((stackView.spacing) * CGFloat(numberOfPages - 1) + ((self.bounds.height * 0.45) * CGFloat(numberOfPages)) - self.bounds.width)
  
  
  override var bounds: CGRect {
    didSet{
      self.numberOfDots.forEach { (dot) in
        self.setupDotAppearance(dot: dot)
      }
    }
  }
  
  //MARK:- Intialisers
  convenience init() {
    self.init(frame: .zero)
  }
  
  init(withNoOfPages pages: Int) {
    self.numberOfPages = pages
    self.currentPage = 0
    super.init(frame: .zero)
    setupViews()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
  }
  private func setupViews() {
    
    self.numberOfDots.forEach { (dot) in
      self.stackView.addArrangedSubview(dot)
    }
    
    stackView.alignment = .center
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.spacing = 0
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(stackView)
    
    
    self.addConstraints([
      
      stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      stackView.heightAnchor.constraint(equalTo: self.heightAnchor),
      
      ])
    
    self.numberOfDots.forEach { dot in
      
      self.addConstraints([
        
        dot.centerYAnchor.constraint(equalTo: self.stackView.centerYAnchor),
        dot.widthAnchor.constraint(equalTo: self.stackView.heightAnchor, multiplier: 1, constant: 0),
        dot.heightAnchor.constraint(equalTo: self.stackView.heightAnchor, multiplier: 0.1, constant: 0)
        ])
      
    }
    
    setIndicatorView()
    
  }
  
  @objc private func onPageControlTapped(_ sender: UITapGestureRecognizer) {
    
//    guard let selectedDot = sender.view else { return }
//    
//    _ = numberOfDots.map { (dot) in
//      setupDotAppearance(dot: dot)
//      if dot.tag == selectedDot.tag {
//        currentPage = selectedDot.tag
//        
//        UIView.animate(withDuration: 0.2, animations: {
//          selectedDot.backgroundColor = self.currentPageIndicatorTintColor
//        })
//        self.sendActions(for: .valueChanged)
//      }
//    }
    
  }
  
  func setIndicatorView() {
   
    guard self.numberOfDots.count > 0 else { return }
    for value in numberOfDots {
      if value.tag == self.currentPage {
        value.backgroundColor = self.currentPageIndicatorTintColor
      } else {
        value.backgroundColor = self.pageIndicatorTintColor
      }
    }
  }

  
  //MARK: Helper methods...
  private func getDotView() -> UIView {
    let dot = UIView()
    self.setupDotAppearance(dot: dot)
    dot.translatesAutoresizingMaskIntoConstraints = false
    return dot
  }
  
  private func setupDotAppearance(dot: UIView) {
//    dot.layer.masksToBounds = true
//    dot.backgroundColor = pageIndicatorTintColor
  }
  
}
