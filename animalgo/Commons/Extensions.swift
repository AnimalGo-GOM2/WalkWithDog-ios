//
//  Extensions.swift
//  animalgo
//
//  Created by rocket on 10/06/2019.
//  Copyright © 2019 rocateer. All rights reserved.
//

import UIKit
import CoreLocation
//-------------------------------------------------------------------------------------------
// MARK: - UITextField
//-------------------------------------------------------------------------------------------
extension UITextField {
  
  /// 플레이스 홀더 색상
  @IBInspectable var placeHolderColor: UIColor? {
    get {
      return self.placeHolderColor
    }
    set {
      self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
    }
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UILabel
//-------------------------------------------------------------------------------------------
extension UILabel {
  func setTextSpacingBy(value: Double) {
    if let textString = self.text {
      let attributedString = NSMutableAttributedString(string: textString)
      attributedString.addAttribute(NSAttributedString.Key.kern, value: value, range: NSRange(location: 0, length: attributedString.length - 1))
      attributedText = attributedString
    }
  }
  
  func setLinespace(spacing: CGFloat) {
    if let text = self.text {
      let attributeString = NSMutableAttributedString(string: text)
      let style = NSMutableParagraphStyle()
      style.lineSpacing = spacing
      style.alignment = .center
      attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, attributeString.length))
      self.attributedText = attributeString
    }
  }

}

//-------------------------------------------------------------------------------------------
// MARK: - UITableView
//-------------------------------------------------------------------------------------------
extension UITableView {
  
  /// 테이블뷰 Cell 을 등록
  ///
  /// - Parameters:
  ///   - type: Cell 타입
  ///   - className: class 이름
  public func registerCell<T: UITableViewCell>(type: T.Type) {
    let className = String(describing: type)
    let nib = UINib(nibName: className, bundle: nil)
    register(nib, forCellReuseIdentifier: className)
  }
  
  
  /// 테이블뷰에 Cell을 여러개 등록
  ///
  /// - Parameter types: Cell 타입
  public func registerCells<T: UITableViewCell>(types: [T.Type]) {
    types.forEach {
      registerCell(type: $0)
    }
  }
  
  public func reloadDataAndKeepOffset(newIndexPath: IndexPath) {
    // stop scrolling
    setContentOffset(contentOffset, animated: false)
    
    // calculate the offset and reloadData
    let beforeContentSize = contentSize
    
    reloadData()
    layoutIfNeeded()
    
    self.scrollToRow(at: newIndexPath, at: .top, animated: false)
   }
   
  func scrollToBottom(){
    DispatchQueue.main.async {
      let indexPath = IndexPath(
        row: self.numberOfRows(inSection:  self.numberOfSections - 1) - 1,
        section: self.numberOfSections - 1)
      if self.hasRowAtIndexPath(indexPath: indexPath) {
        self.scrollToRow(at: indexPath, at: .bottom, animated: false)
      }
    }

    performBatchUpdates(nil) { finish in
      DispatchQueue.main.async {
        let point = CGPoint(x: 0, y: self.contentSize.height + self.contentInset.bottom - self.frame.height)
        if point.y >= 0{
          self.setContentOffset(point, animated: false)
          
        }
      }
    }
    
    self.isHidden = false
    
  }
  
  func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
    return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionView
//-------------------------------------------------------------------------------------------
extension UICollectionView {
  
  /// 컬렉션뷰에 Cell 을 등록
  ///
  /// - Parameter type: 타입
  public func registerCell<T: UICollectionViewCell>(type: T.Type) {
    let className = String(describing: type)
    let nib = UINib(nibName: className, bundle: nil)
    register(nib, forCellWithReuseIdentifier: className)
  }
  
  /// 컬렉션뷰에 Cell을 여러개 등록
  ///
  /// - Parameter types: 타입 배열
  public func registerCells<T: UICollectionViewCell>(types: [T.Type]) {
    types.forEach {
      registerCell(type: $0)
    }
  }
  
  
  /// 컬렉션뷰에 ReusableView 를 등록
  ///
  /// - Parameters:
  ///   - type: 타입
  ///   - kind: 기본 UICollectionView.elementKindSectionHeader
  public func registerReusableView<T: UICollectionReusableView>(type: T.Type, kind: String = UICollectionView.elementKindSectionHeader) {
    let className = String(describing: type)
    let nib = UINib(nibName: className, bundle: nil)
    register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: className)
  }
  
  
  /// 컬렉션뷰에 ReusableView 를 여러개 등록
  ///
  /// - Parameters:
  ///   - types: 타입 배열
  ///   - kind: 기본 UICollectionView.elementKindSectionHeader
  public func registerReusableViews<T: UICollectionReusableView>(types: [T.Type], kind: String = UICollectionView.elementKindSectionHeader) {
    types.forEach {
      registerReusableView(type: $0, kind: kind)
    }
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UINavigationBar
//-------------------------------------------------------------------------------------------
extension UINavigationBar {
  
  /// 네비게이션 바를 투명하게
  func transparentNavigationBar() {
    self.setBackgroundImage(UIImage(), for: .default)
    self.shadowImage = UIImage()
    self.isTranslucent = true
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UINavigationController
//-------------------------------------------------------------------------------------------
extension UINavigationController {
  
  /// 투명한 네비게이션 바를 만들어준다.
  public func presentTransparentNavigationBar() {
    navigationBar.setBackgroundImage(UIImage(), for:UIBarMetrics.default)
    navigationBar.isTranslucent = true
    navigationBar.shadowImage = UIImage()
    setNavigationBarHidden(false, animated:true)
  }
  
  
  /// 네비게이션 바를 사라지게 한다.
  public func hideTransparentNavigationBar() {
    setNavigationBarHidden(true, animated:false)
    navigationBar.setBackgroundImage(UINavigationBar.appearance().backgroundImage(for: UIBarMetrics.default), for:UIBarMetrics.default)
    navigationBar.isTranslucent = UINavigationBar.appearance().isTranslucent
    navigationBar.shadowImage = UINavigationBar.appearance().shadowImage
  }
}


//-------------------------------------------------------------------------------------------
// MARK: - UIAlertController
//-------------------------------------------------------------------------------------------
extension UIAlertController {
  func show() {
    // TOP VIEW CONTROLLER
    UIApplication.topViewController()?.present(self, animated: true, completion: nil)
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UIPageControl
//-------------------------------------------------------------------------------------------
extension UIPageControl {
  
  /// 페이지 컨트롤 모양
  ///
  /// - Parameters:
  ///   - dotFillColor: Dot 컬러
  ///   - dotBorderColor: Dot Border 컬러
  ///   - dotBorderWidth: Dot 보더 너비
  func customPageControl(dotFillColor:UIColor, dotBorderColor:UIColor, dotBorderWidth:CGFloat) {
    for (pageIndex, dotView) in self.subviews.enumerated() {
      if self.currentPage == pageIndex {
        dotView.backgroundColor = dotFillColor
        dotView.layer.cornerRadius = dotView.frame.size.height / 2
      }else{
        dotView.backgroundColor = .clear
        dotView.layer.cornerRadius = dotView.frame.size.height / 2
        dotView.layer.borderColor = dotBorderColor.cgColor
        dotView.layer.borderWidth = dotBorderWidth
      }
    }
  }
  
}
//-------------------------------------------------------------------------------------------
// MARK: - UIImage
//-------------------------------------------------------------------------------------------
extension UIImage {
  class func outlinedEllipse(size: CGSize, color: UIColor, lineWidth: CGFloat = 1.0) -> UIImage? {
    
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    guard let context = UIGraphicsGetCurrentContext() else {
      return nil
    }
    
    context.setStrokeColor(color.cgColor)
    context.setLineWidth(lineWidth)
    let rect = CGRect(origin: .zero, size: size).insetBy(dx: lineWidth * 0.5, dy: lineWidth * 0.5)
    context.addEllipse(in: rect)
    context.strokePath()
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
  
  func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
    let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
    let format = imageRendererFormat
    format.opaque = isOpaque
    return UIGraphicsImageRenderer(size: canvas, format: format).image {
      _ in draw(in: CGRect(origin: .zero, size: canvas))
    }
  }
  func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
    let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
    let format = imageRendererFormat
    format.opaque = isOpaque
    return UIGraphicsImageRenderer(size: canvas, format: format).image {
      _ in draw(in: CGRect(origin: .zero, size: canvas))
    }
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UIApplication
//-------------------------------------------------------------------------------------------
extension UIApplication {
  
  /// URL 외부 브라우저로 열기
  ///
  /// - Parameter url: 공통
  func openURL(url: String) {
    if let url = URL(string: url) {
      if UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url)
      }
    }
  }
}
//-------------------------------------------------------------------------------------------
// MARK: - UIView
//-------------------------------------------------------------------------------------------
extension UIView {
  func constrainToEdges(_ subview: UIView) {
    
    subview.translatesAutoresizingMaskIntoConstraints = false
    
    let topContraint = NSLayoutConstraint(
      item: subview,
      attribute: .top,
      relatedBy: .equal,
      toItem: self,
      attribute: .top,
      multiplier: 1.0,
      constant: 0)
    
    let bottomConstraint = NSLayoutConstraint(
      item: subview,
      attribute: .bottom,
      relatedBy: .equal,
      toItem: self,
      attribute: .bottom,
      multiplier: 1.0,
      constant: 0)
    
    let leadingContraint = NSLayoutConstraint(
      item: subview,
      attribute: .leading,
      relatedBy: .equal,
      toItem: self,
      attribute: .leading,
      multiplier: 1.0,
      constant: 0)
    
    let trailingContraint = NSLayoutConstraint(
      item: subview,
      attribute: .trailing,
      relatedBy: .equal,
      toItem: self,
      attribute: .trailing,
      multiplier: 1.0,
      constant: 0)
    
    addConstraints([
      topContraint,
      bottomConstraint,
      leadingContraint,
      trailingContraint])
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - CAShapeLayer
//-------------------------------------------------------------------------------------------
extension CAShapeLayer {
  func drawCircleAtLocation(location: CGPoint, withRadius radius: CGFloat, andColor color: UIColor, filled: Bool) {
    fillColor = filled ? color.cgColor : UIColor.white.cgColor
    strokeColor = color.cgColor
    let origin = CGPoint(x: location.x - radius, y: location.y - radius)
    path = UIBezierPath(ovalIn: CGRect(origin: origin, size: CGSize(width: radius * 2, height: radius * 2))).cgPath
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UIBarButtonItem
//-------------------------------------------------------------------------------------------
private var handle: UInt8 = 0;
extension UIBarButtonItem {
  private var badgeLayer: CAShapeLayer? {
    if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
      return b as? CAShapeLayer
    } else {
      return nil
    }
  }
  
  func addBadge(number: Int, andColor color: UIColor = UIColor(named: "point")!, andFilled filled: Bool = true) {
    guard let view = self.value(forKey: "view") as? UIView else { return }
    
    badgeLayer?.removeFromSuperlayer()
    guard number > 0 else {
      return
    }
    
    var badgeWidth = 15
    var numberOffset = badgeWidth / 2
    let offset = CGPoint(x: 3, y: 10)
    if number > 9 {
      badgeWidth = 15
      numberOffset = badgeWidth / 2
    }
    
    // Initialize Badge
    let badge = CAShapeLayer()
    let radius = CGFloat(badgeWidth / 2)
//    let location = CGPoint(x: view.frame.width - (radius + offset.x), y: (radius + offset.y))
    let location = CGPoint(x: view.frame.width - (CGFloat(badgeWidth / 2) + offset.x), y: (radius + offset.y))
    badge.drawCircleAtLocation(location: location, withRadius: radius, andColor: color, filled: filled)
    view.layer.addSublayer(badge)
    
    // Initialiaze Badge's label
    let label = CATextLayer()
    label.string = "\(number)"
    label.alignmentMode = CATextLayerAlignmentMode.center
    label.fontSize = 10
    label.frame = CGRect(origin: CGPoint(x: location.x - CGFloat(numberOffset), y: offset.y), size: CGSize(width: badgeWidth, height: 16))
    label.foregroundColor = filled ? UIColor.white.cgColor : color.cgColor
    label.backgroundColor = UIColor.clear.cgColor
    label.contentsScale = UIScreen.main.scale
    badge.addSublayer(label)
    
    // Save Badge as UIBarButtonItem property
    objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
  }
  
  func updateBadge(number: Int) {
    if let text = badgeLayer?.sublayers?.filter({ $0 is CATextLayer }).first as? CATextLayer {
      text.string = "\(number)"
    }
  }
  
  func removeBadge() {
    badgeLayer?.removeFromSuperlayer()
  }
}


//-------------------------------------------------------------------------------------------
// MARK: - Date
//-------------------------------------------------------------------------------------------
extension Date {

  static func today() -> Date {
      return Date()
  }

  func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
    return get(.next,
               weekday,
               considerToday: considerToday)
  }

  func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
    return get(.previous,
               weekday,
               considerToday: considerToday)
  }

  func get(_ direction: SearchDirection,
           _ weekDay: Weekday,
           considerToday consider: Bool = false) -> Date {

    let dayName = weekDay.rawValue

    let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }

    assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")

    let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1

    let calendar = Calendar(identifier: .gregorian)

    if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
      return self
    }

    var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: self)
    nextDateComponent.weekday = searchWeekdayIndex

    let date = calendar.nextDate(after: self,
                                 matching: nextDateComponent,
                                 matchingPolicy: .nextTime,
                                 direction: direction.calendarSearchDirection)

    return date!
  }

}

// MARK: Helper methods
extension Date {
  func getWeekDaysInEnglish() -> [String] {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = Locale(identifier: "en_US_POSIX")
    return calendar.weekdaySymbols
  }

  enum Weekday: String {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
  }
  func startOfMonth() -> Date {
    return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
  }
  
  func endOfMonth() -> Date {
    return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
  }

  enum SearchDirection {
    case next
    case previous

    var calendarSearchDirection: Calendar.SearchDirection {
      switch self {
      case .next:
        return .forward
      case .previous:
        return .backward
      }
    }
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - CLLocation
//-------------------------------------------------------------------------------------------
extension CLLocation: Encodable {
  enum CodingKeys: String, CodingKey {
    case latitude
    case longitude
    case altitude
    case horizontalAccuracy
    case verticalAccuracy
    case speed
    case course
    case timestamp
  }
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(coordinate.latitude, forKey: .latitude)
    try container.encode(coordinate.longitude, forKey: .longitude)
    try container.encode(altitude, forKey: .altitude)
    try container.encode(horizontalAccuracy, forKey: .horizontalAccuracy)
    try container.encode(verticalAccuracy, forKey: .verticalAccuracy)
    try container.encode(speed, forKey: .speed)
    try container.encode(course, forKey: .course)
    try container.encode(timestamp, forKey: .timestamp)
  }
}
