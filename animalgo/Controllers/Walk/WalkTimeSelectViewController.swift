//
//  WalkTimeSelectViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/11.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import Daysquare
import DropDown

class WalkTimeSelectViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var timeTextField: UITextField!
  @IBOutlet weak var minuteTextField: UITextField!
  @IBOutlet weak var timeWrapView: UIView!
  @IBOutlet weak var minuteWrapView: UIView!
  @IBOutlet weak var calendarView: DAYCalendarView!
  @IBOutlet weak var calendarHeight: NSLayoutConstraint!
  @IBOutlet weak var previousButton: UIButton!
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var yearLabel: UILabel!
  @IBOutlet weak var monthLabel: UILabel!
  @IBOutlet weak var calendarCollectionView: UICollectionView!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var goNextButton: UIButton!
  @IBOutlet weak var selYearLabel: UILabel!
  @IBOutlet weak var selMonthLabel: UILabel!
  @IBOutlet weak var selDayLabel: UILabel!
  @IBOutlet weak var selTimeLabel: UILabel!
  @IBOutlet weak var selMinuteLabel: UILabel!
  
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var currentPage = 0 // 달력 현재 페이지
  var maxPage = 3 // 달력 장수
  var today = Date.today()
  let checkWeekday = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"]
  let timeDropDown = DropDown()
  let minuteDropDown = DropDown()
  var type = 0
  var timeList = ["00시","01시","02시","03시","04시","05시","06시","07시","08시","09시","10시","11시","12시","13시","14시","15시","16시","17시","18시","19시","20시","21시","22시","23시"]
  var minuteList = ["0분","10분","20분","30분","40분","50분"]
  
  var dateArray = [Date]()
  var selectedDate = Date()
  var recordRequest = RecordModel()
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    self.calendarView.singleRowMode = true
    self.calendarView.localizedStringsOfWeekday = ["일", "월", "화", "수", "목", "금", "토"]
    self.calendarView.selectedIndicatorColor = UIColor(named: "accent")!
    self.calendarView.weekdayHeaderTextColor = UIColor(named: "999999")!
    self.calendarView.weekdayHeaderWeekendTextColor = UIColor(named: "999999")!
    self.calendarView.reload(animated: false)
    self.calendarCollectionView.registerCell(type: CalendarDayCell.self)
    self.calendarCollectionView.dataSource = self
    self.calendarCollectionView.delegate = self

    self.selYearLabel.text = String(format: "%02d", self.today.year)
    self.selMonthLabel.text = String(format: "%02d", self.today.month)
    self.selDayLabel.text = String(format: "%02d", self.today.day)
    self.setCalendar()
    self.setTitleDate()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    self.cancelButton.setCornerRadius(radius: 10)
    self.goNextButton.setCornerRadius(radius: 10)
    self.calendarHeight.constant = CGFloat((self.calendarCollectionView.frame.width) / 7)
  }
  
  override func initRequest() {
    super.initRequest()
    self.timeDropDown.anchorView = self.timeWrapView
    self.timeDropDown.dataSource = self.timeList
    self.minuteDropDown.anchorView = self.minuteWrapView
    self.minuteDropDown.dataSource = self.minuteList
    self.customizeDropDown(self)
    
    
    // 시간 선택
    self.timeWrapView.addTapGesture { recognizer in
      self.timeDropDown.show()
      
    }
    // 분 선택
    self.minuteWrapView.addTapGesture { recognizer in
      self.minuteDropDown.show()
    }
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  // 달력
  func setCalendar() {
    var calendar = Calendar.autoupdatingCurrent
    calendar.firstWeekday = 1 // Start on Sunday
    let today = calendar.startOfDay(for: Date())
    var week = [Date]()
    if let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) {
      
      var dateCount = 14
      if self.today.weekday == "일요일" {
        self.maxPage = 2
        dateCount = 14
      } else {
        self.maxPage = 3
        dateCount = 21
      }
      
      for i in 0...dateCount {
        if let day = calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
          week += [day]
        }
      }
    }
    self.dateArray = week
  }
  
  // 상단 년/월 표시
  func setTitleDate() {
    let firstDate = self.dateArray[self.currentPage * 7]
    self.yearLabel.text = firstDate.toString(format: "yyyy")
    self.monthLabel.text = "\(firstDate.toString(format: "MM"))월"
  }
  
  /// 드롭다운 세팅
  /// - Parameter sender: self
  func customizeDropDown(_ sender: AnyObject) {
    DropDown.appearance().cornerRadius = 4
    DropDown.appearance().direction = .bottom
    DropDown.appearance().shadowColor = UIColor(named: "707070")!
    DropDown.appearance().cellHeight = 44
    self.timeDropDown.width = self.timeWrapView.frame.width
    self.timeDropDown.bottomOffset = CGPoint(x: 0, y: 49)
    self.timeDropDown.shadowOpacity = 0.5
    self.timeDropDown.shadowOffset = CGSize(width: 0, height: 0)
    self.timeDropDown.backgroundColor = .white
    self.timeDropDown.cellNib = UINib(nibName: "TextDropDownCell", bundle: nil)
    
    self.minuteDropDown.width = self.timeWrapView.frame.width
    self.minuteDropDown.bottomOffset = CGPoint(x: 0, y: 49)
    self.minuteDropDown.shadowOpacity = 0.5
    self.minuteDropDown.shadowOffset = CGSize(width: 0, height: 0)
    self.minuteDropDown.backgroundColor = .white
    self.minuteDropDown.cellNib = UINib(nibName: "TextDropDownCell", bundle: nil)
    
    
    self.timeDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
      guard let cell = cell as? TextDropDownCell else { return }
      cell.titleLabel.text = item
      cell.optionLabel.isHidden = true
    }
    
    self.minuteDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
      guard let cell = cell as? TextDropDownCell else { return }
      cell.titleLabel.text = item
      cell.optionLabel.isHidden = true
    }
    
    
    self.timeDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
      self.timeTextField.text = self.timeList[index]
      self.selTimeLabel.text = self.timeList[index]
      if index < 12 {
        self.selTimeLabel.text = self.timeList[index] + "(오전 \(self.timeList[index]))"
      }else if index == 12 {
        self.selTimeLabel.text = self.timeList[index] + "(오후 12시)"
      }else {
        self.selTimeLabel.text = self.timeList[index] + "(오후 \(index - 12)시)"
      }
    }
    self.minuteDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
      self.minuteTextField.text = self.minuteList[index]
      self.selMinuteLabel.text = self.minuteList[index]
    }
    
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  
  /// 이전 주 버튼
  /// - Parameter sender: UIButton
  @IBAction func previousButtonTouched(sender: UIButton) {
    if currentPage == 1 {
      self.currentPage -= 1
      self.calendarCollectionView.scrollToItem(at: [0,0], at: .left, animated: true)
    } else if currentPage == 2 {
      self.currentPage -= 1
      self.calendarCollectionView.scrollToItem(at: [0,7], at: .left, animated: true)
      
    } else {
      self.previousButton.isEnabled = false
    }
    self.nextButton.isEnabled = true
    self.setTitleDate()
  }
  /// 다음 주 버튼
  /// - Parameter sender: UIButton
  @IBAction func nextButtonTouched(sender: UIButton) {
    if self.currentPage == 0 {
      self.currentPage += 1
      self.calendarCollectionView.scrollToItem(at: [0,7], at: .left, animated: true)
      if self.maxPage == 2 {
        self.nextButton.isEnabled = false
      }
    } else if self.currentPage == 1 {
      if self.maxPage == 3 {
        self.currentPage += 1
        self.calendarCollectionView.scrollToItem(at: [0,14], at: .left, animated: true)
        self.nextButton.isEnabled = false
      }
    }
    self.previousButton.isEnabled = true
    self.setTitleDate()
  }
  
  /// 취소
  /// - Parameter sender: UIButton
  @IBAction func cancelButtonTouched(sender: UIButton) {
    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
  }
  /// 다음
  /// - Parameter sender: UIButton
  @IBAction func goNextButtonTouched(sender: UIButton) {
    guard self.timeTextField.text != "" && self.minuteTextField.text != "" else {
      AJAlertController.initialization().showAlertWithOkButton(astrTitle: "", aStrMessage: "산책 시간을 선택해주세요.", alertViewHiddenCheck: false) { position, title in
        
      }
      return
    }
    
    let time = (self.timeTextField.text ?? "").dropLast()
    let min = Int((self.minuteTextField.text ?? "").dropLast()) ?? 0
    
    self.recordRequest.record_date = "\(self.selectedDate.toString(format: "yyyy-MM-dd")) \(time):\(String(format: "%02d", min))"
    let destination = MyLocationViewController.instantiate(storyboard: "Walk").coverNavigationController()
    if let firstViewController = destination.viewControllers.first {
      let viewController = firstViewController as! MyLocationViewController
      viewController.fromView = "WalkTimeSelect"
      viewController.recordRequest = self.recordRequest
    }
    destination.hero.isEnabled = false
    destination.hero.modalAnimationType = .autoReverse(presenting: .cover(direction: .left))
    destination.modalPresentationStyle = .fullScreen
    self.present(destination, animated: true, completion: nil)
  
  }
}

//-------------------------------------------------------------------------------------------
// MARK: UICollectionViewDataSource
//-------------------------------------------------------------------------------------------
extension WalkTimeSelectViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if maxPage == 3 {
      return 21
    } else {
      return 14
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarDayCell", for: indexPath) as! CalendarDayCell
    
    cell.date = self.dateArray[indexPath.row]
    cell.dateLabel.text = "\(cell.date.day)"
    cell.dateButton.isSelected = self.selectedDate.toString(format: "yyyy-MM-dd") == cell.date.toString(format: "yyyy-MM-dd")
    cell.selectedView.isHidden = !(self.selectedDate.toString(format: "yyyy-MM-dd") == cell.date.toString(format: "yyyy-MM-dd"))
    cell.dateButton.isEnabled = cell.date.toString(format: "yyyy-MM-dd") >= Date().toString(format: "yyyy-MM-dd")
    cell.dateLabel.textColor = cell.dateButton.isEnabled ? .black : .lightGray
    

    // 날짜 선택
    cell.dateButton.addTapGesture { recognizer in
      self.selectedDate = cell.date
      self.calendarCollectionView.reloadData()
      self.selYearLabel.text = cell.date.toString(format: "yyyy")
      self.selMonthLabel.text = cell.date.toString(format: "MM")
      self.selDayLabel.text = cell.date.toString(format: "dd")
    }
    
    return cell
  }
  
}


//-------------------------------------------------------------------------------------------
// MARK: UICollectionViewDelegate
//-------------------------------------------------------------------------------------------
extension WalkTimeSelectViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let pageWidth = self.calendarCollectionView.frame.width - 10
    self.currentPage = Int(self.calendarCollectionView.contentOffset.x / pageWidth)
    if self.calendarCollectionView.cellForItem(at: [0, 7*currentPage]) != nil {
      self.setTitleDate()
    }
  }
}

//-------------------------------------------------------------------------------------------
// MARK: UICollectionViewDelegateFlowLayout
//-------------------------------------------------------------------------------------------
extension WalkTimeSelectViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (self.calendarCollectionView.frame.width) / 7
    return CGSize(width: width , height: width)
  }
}
