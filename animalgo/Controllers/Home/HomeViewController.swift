//
//  HomeViewController.swift
//  animalgo
//
//  Created by rocateer on 2021/10/29.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import SkeletonView
import Defaults
import CoreLocation

class HomeViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var moreScrollView: UIScrollView!
  @IBOutlet weak var alarmBarButton: UIBarButtonItem!
  @IBOutlet weak var memoBarButton: UIBarButtonItem!
  @IBOutlet weak var todayRecommendView: UIView!
  @IBOutlet weak var recommendWrapView: UIView!
  @IBOutlet weak var memberImageView: UIImageView!
  @IBOutlet weak var nicknameLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var ageLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var petImageView: UIImageView!
  @IBOutlet weak var petNameLabel: UILabel!
  @IBOutlet weak var breedLabel: UILabel!
  @IBOutlet weak var complimentWrapView: UIView!
  @IBOutlet weak var complimentCollectionView: UICollectionView!
  @IBOutlet weak var bannerWrapView: UIView!
  @IBOutlet weak var bannerImageView: UIImageView!
  @IBOutlet weak var rankingWrapView: UIView!
  @IBOutlet weak var rankingDateLabel: UILabel!
  @IBOutlet weak var rankingTableView: UITableView!
  @IBOutlet weak var rankingHeight: NSLayoutConstraint!
  @IBOutlet weak var myPetWrapView: UIView!
  @IBOutlet weak var petCollectionView: UICollectionView!
  @IBOutlet weak var personalityTagButton: UIButton!
  @IBOutlet weak var neuterTagButton: UIButton!
  @IBOutlet weak var trainedTagButton: UIButton!
  @IBOutlet weak var bannerCollectionView: UICollectionView!
  @IBOutlet weak var topLabel: UILabel!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var complimentList = [MainModel]() // 칭찬해요
  var rankingList = [MainModel]() // 산책왕
  var bannerList = [MainModel]() // 배너
  var myPetList = [MainModel]() // 내 반려견
  var recommendData = MainModel()
  var timer: Timer?
  var bannerTime = 0
  let refreshControl = UIRefreshControl()
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(self.mainUpdate), name: Notification.Name("MainUpdate"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.profileUpdate), name: Notification.Name("profileUpdate"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.pushPresent), name: Notification.Name("PushNotification"),  object: nil)
    NotificationCenter.default.addObserver(self, selector:#selector(self.appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    self.moreScrollView.addSubview(self.refreshControl)
    self.refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
    self.complimentCollectionView.registerCell(type: ComplimentCell.self)
    self.complimentCollectionView.delegate = self
    self.complimentCollectionView.dataSource = self
    self.rankingTableView.registerCell(type: RankingCell.self)
    self.rankingTableView.delegate = self
    self.rankingTableView.dataSource = self
    self.petCollectionView.registerCell(type: PetImageCell.self)
    self.petCollectionView.delegate = self
    self.petCollectionView.dataSource = self
    self.bannerCollectionView.registerCell(type: BannerCell.self)
    self.bannerCollectionView.delegate = self
    self.bannerCollectionView.dataSource = self
    let bannerLayout = UICollectionViewFlowLayout()
    bannerLayout.minimumLineSpacing = 40
    bannerLayout.minimumInteritemSpacing = 40
    bannerLayout.scrollDirection = .horizontal
    bannerLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    self.bannerCollectionView.collectionViewLayout = bannerLayout
    
    self.petCollectionView.collectionViewLayout = OverlapCollectionViewLayout()


    self.personalityTagButton.setCornerRadius(radius: 14.5)
    self.neuterTagButton.setCornerRadius(radius: 14.5)
    self.trainedTagButton.setCornerRadius(radius: 14.5)
    self.personalityTagButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.neuterTagButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    self.trainedTagButton.addBorder(width: 1, color: UIColor(named: "EAE8E5")!)
    
    self.rankingHeight.constant = 0
    
    self.view.showAnimatedSkeleton()
    self.complimentCollectionView.showAnimatedSkeleton()
    self.rankingTableView.showAnimatedSkeleton()
  
    if Defaults[.record_idx] != nil {
      let destination = WalkTrackingViewController.instantiate(storyboard: "Walk")
      destination.modalPresentationStyle = .fullScreen
      self.present(destination, animated: false, completion: nil)
    }
    
    self.checkLoationPermission()

  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    self.recommendWrapView.layer.cornerRadius = 20
    self.recommendWrapView.layer.borderWidth = 1.0
    self.recommendWrapView.layer.borderColor = UIColor(named: "EAE8E5")!.cgColor
    self.recommendWrapView.layer.shadowColor = UIColor.black.cgColor
    self.recommendWrapView.layer.shadowOffset = CGSize(width: 0, height: 0)
    self.recommendWrapView.layer.shadowOpacity = 0.2
    self.recommendWrapView.layer.shadowRadius = 4
    
    self.memberImageView.setCornerRadius(radius: 20)
    self.petImageView.setCornerRadius(radius: 16)
    self.bannerImageView.setCornerRadius(radius: 20)
    
    
    
    self.recommendWrapView.addTapGesture { recognizer in
      let vc = FriendAskDetailViewController.instantiate(storyboard: "Walk")
      vc.record_idx = self.recommendData.record_idx ?? ""
      let destination = vc.coverNavigationController()
      destination.hero.isEnabled = true
      destination.hero.modalAnimationType = .autoReverse(presenting: .cover(direction: .left))
      destination.modalPresentationStyle = .fullScreen
      self.present(destination, animated: true, completion: nil)
    }

  }
  
  override func initRequest() {
    super.initRequest()
    self.startPopupDetailAPI()
    self.mainAPI()
  }

  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.newAlarmCountAPI()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  // 앱시작시 팝업
  func startPopupDetailAPI() {
    APIRouter.shared.api(path: .start_popup_detail, parameters: nil) { response in
      if let popupResponse = EventModel(JSON: response), Tools.shared.isSuccessResponse(response: popupResponse) {
        if !popupResponse.img_path.isNil {
          let interval = Date().timeIntervalSince(Defaults[.bannerDay] ?? Date())
          let days = Int(interval / 259200)

          // 하루 지났거나, 배너를 닫은 기록이 없을 때만 띄움
          // 배너 있는 경우 체크 필요
          if (days > 0 || Defaults[.bannerDay] == nil) {
            let destination = PopupViewController.instantiate(storyboard: "Home")
            destination.eventData = popupResponse
            destination.modalTransitionStyle = .crossDissolve
            destination.modalPresentationStyle = .overCurrentContext
            self.tabBarController?.present(destination, animated: false, completion: nil)
          } else {
//            self.pushPresent()
          }
        }
      }
    } fail: { error in
      Tools.shared.showToast(message: "알수 없는 오류가 발생하였습니다.")
    }
  }
  
  
  /// 메인
  func mainAPI() {
    let mainRequest = MainModel()
    mainRequest.member_idx = Defaults[.member_idx]
    mainRequest.member_lat = "\(Defaults[.currentLat] ?? 0.0)"
    mainRequest.member_lng = "\(Defaults[.currentLng] ?? 0.0)"
    
    APIRouter.shared.api(path: APIURL.main, method: .post, parameters: mainRequest.toJSON()) { data in
      if let mainResponse = MainModel(JSON: data), Tools.shared.isSuccessResponse(response: mainResponse) {
        self.refreshControl.endRefreshing()
        self.topLabel.text = "\(mainResponse.member_nickname ?? "")님!\n안녕하세요."
        if let recommendData = mainResponse.recommend_obj {
          self.recommendData = recommendData
          self.recommendWrapView.isHidden = false
          self.memberImageView.sd_setImage(with: URL(string: Tools.shared.thumbnailImageUrl(url: recommendData.member_img ?? "")), placeholderImage: UIImage(named: "default_profile")!, options: .lowPriority, context: nil)
          self.nicknameLabel.text = recommendData.member_nickname
          self.distanceLabel.text = "\(recommendData.distant ?? "0")km"
          self.ageLabel.text = "\(recommendData.member_age ?? "")대·\(recommendData.member_gender == "0" ? "남성" : "여성")"
          self.dateLabel.text = recommendData.record_date

          if let petData = recommendData.animal_obj {
            self.petImageView.sd_setImage(with: URL(string: "\(Tools.shared.thumbnailImageUrl(url: petData.animal_img_path ?? ""))"), completed: nil)
            self.petImageView.sd_setImage(with: URL(string: "\(Tools.shared.thumbnailImageUrl(url: petData.animal_img_path ?? ""))"), placeholderImage: UIImage(named: "default_dog1"), options: .lowPriority, context: nil)
            let animalList = recommendData.member_animal_idxs?.components(separatedBy: ",") ?? [String]()
            if animalList.count > 1 {
              self.petNameLabel.text = "\(petData.animal_name ?? "") 외 \(animalList.count - 1)마리"
            } else {
              self.petNameLabel.text = "\(petData.animal_name ?? "")"
            }
            self.breedLabel.text = "\(petData.category_name ?? "")·\(petData.animal_gender == "0" ? "남아" : "여아")·\(petData.animal_year ?? "")"
            self.personalityTagButton.setTitle("#\(characterString(animal_character: petData.animal_character ?? ""))", for: .normal)
            self.neuterTagButton.setTitle("\(petData.animal_neuter == "Y" ? "#중성화 했어요" : "#중성화 안 했어요")", for: .normal)
            self.trainedTagButton.setTitle("\(petData.animal_training == "Y" ? "#훈련 했어요" : "#훈련 안 했어요")", for: .normal)
          }
          
        } else {
          self.recommendWrapView.isHidden = true
        }
        
        if let compliment_array = mainResponse.compliment_array, compliment_array.count > 0 {
          self.complimentWrapView.isHidden = false
          self.complimentList = compliment_array
        } else {
          self.complimentWrapView.isHidden = true
        }
        
        if let rank_array = mainResponse.rank_array, rank_array.count > 0 {
          self.rankingWrapView.isHidden = false
          self.rankingList = rank_array
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
          let startDate = dateFormatter.date(from: mainResponse.record_king_start_date ?? "") ?? Date()
          let endDate = dateFormatter.date(from: mainResponse.record_king_end_date ?? "") ?? Date()
          self.rankingDateLabel.text = "\(startDate.toString(format: "yyyy.MM.dd"))~\(endDate.toString(format: "yyyy.MM.dd"))"
        } else {
          self.rankingWrapView.isHidden = true
        }
        
        self.rankingHeight.constant = CGFloat(226 * self.rankingList.count)
        
        if let banner_array = mainResponse.banner_array, banner_array.count > 0 {
          self.bannerWrapView.isHidden = false
          self.bannerList = banner_array
          if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.bannerTimerAction), userInfo: nil, repeats: true)
          }
        } else {
          self.timer?.invalidate()
          self.timer = nil
          
          self.bannerWrapView.isHidden = true
        }
        
        if let animal_array = mainResponse.my_animal_array, animal_array.count > 0 {
          self.myPetWrapView.isHidden = false
          self.myPetList = animal_array
          self.appDelegate.myAnimalList = [AnimalModel]()
          for value in animal_array {
            let animalModel = AnimalModel()
            animalModel.animal_idx = value.animal_idx
            animalModel.animal_img_path = value.animal_img_path
            self.appDelegate.myAnimalList.append(animalModel)
          }
        } else {
          self.myPetWrapView.isHidden = true
        }
        
        self.complimentCollectionView.reloadData()
        self.rankingTableView.reloadData()
        self.bannerCollectionView.reloadData()
        self.petCollectionView.reloadData()
        
        self.view.hideSkeleton()
        self.complimentCollectionView.hideSkeleton()
        self.rankingTableView.hideSkeleton()
      }
    } fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }
  }
  
  // 배너 타이머
  @objc func bannerTimerAction() {
    if self.bannerTime >= self.bannerList.count - 1 {
      self.bannerTime = 0
    } else {
      self.bannerTime += 1
    }

    let indexPath = IndexPath(row: self.bannerTime, section: 0)

    self.bannerCollectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.left, animated: true)
  }
  
  
  /// 매인 업데이트
  @objc func mainUpdate() {
    self.mainAPI()
  }
  
  /// 프로필  업데이트
  /// - Parameter notificaiton: notificaiton
  @objc func profileUpdate(notification: Notification) {
    self.topLabel.text = "\(notification.object ?? "")님!\n안녕하세요."
  }
  
  /// 안읽은 알람수
  func newAlarmCountAPI() {
    let alarmRequest = AlarmModel()
    alarmRequest.member_idx = Defaults[.member_idx]
    
    APIRouter.shared.api(path: APIURL.new_alarm_count, method: .post, parameters: alarmRequest.toJSON()) { data in
      if let alarmResponse = AlarmModel(JSON: data), Tools.shared.isSuccessResponse(response: alarmResponse) {
        if let new_alarm_conut =  alarmResponse.new_alarm_conut {
          self.alarmBarButton.addBadge(number: Int(new_alarm_conut) ?? 0)
        }
        
        if let new_memo_conut =  alarmResponse.new_memo_conut {
          self.memoBarButton.addBadge(number: Int(new_memo_conut) ?? 0)
        }
      }
    } fail: { error in
      Tools.shared.showToast(message: error?.localizedDescription ?? "")
    }

  }
  
  // 위치 권한 체크
  func checkLoationPermission() {
  
    switch CLLocationManager.authorizationStatus() {
    case .authorizedAlways, .authorizedWhenInUse:
      print("GPS: 권한 있음")
      break
    case .restricted, .notDetermined:
      print("GPS: 아직 선택하지 않음")
      let locationManager = CLLocationManager()
      // 아직 결정하지 않은 상태: 시스템 팝업 호출
      locationManager.requestWhenInUseAuthorization()
    case .denied:
      print("GPS: 권한 없음")
      let alertController = UIAlertController(title: "위치 권한 설정", message: "애니멀고 산책 앱 사용을 위해 위치 권한을 설정해주세요.", preferredStyle: UIAlertController.Style.alert)
      
      let okAction = UIAlertAction(title: "설정", style: .default, handler: {(action) in
        //Redirect to Settings app
        UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
      })
      
      let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel)
      alertController.addAction(cancelAction)
      alertController.addAction(okAction)
      
      self.present(alertController, animated: true, completion: nil)
      return
    @unknown default:
      print("GPS: Default")
      return
    }
  }
  
  
  @objc func appMovedToForeground() {
    print("App moved to foreground!")
    self.appDelegate.getLocation()
  }
  
  // 당겨서 새로고침
  @objc func refresh() {
    self.mainAPI()
  }
  
  /// 알림 화면 이동
  @objc func pushPresent() {
    let destination = ChatViewController.instantiate(storyboard: "Walk").coverNavigationController()
    if let firstViewController = destination.viewControllers.first {
      let viewController = firstViewController as! ChatViewController
      viewController.chatting_room_idx = appDelegate.chatting_room_idx
    }
    destination.hero.isEnabled = true
    destination.hero.modalAnimationType = .autoReverse(presenting: .push(direction: .left))
    destination.modalPresentationStyle = .fullScreen
    self.getTopViewController().present(destination, animated: true, completion: nil)
    
    appDelegate.chatting_room_idx = ""
  }
  
  /// 상단 viewcontroller 가져오기
  /// - Returns: viewController
  func getTopViewController() -> UIViewController {
    if var topController = UIApplication.shared.windows.first(where: {$0.isKeyWindow})?.rootViewController {
      while let presentedViewController = topController.presentedViewController {
        topController = presentedViewController
      }
      
      return topController
      // topController should now be your topmost view controller
    }
    return UIViewController()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  
  /// 알람
  /// - Parameter sender: UIButton
  @IBAction func alarmButtonTouched(sender: UIButton) {
    let destination = AlarmViewController.instantiate(storyboard: "Home").coverNavigationController()
    destination.hero.isEnabled = true
    destination.hero.modalAnimationType = .autoReverse(presenting: .cover(direction: .left))
    destination.modalPresentationStyle = .fullScreen
    self.present(destination, animated: true, completion: nil)
  }
  /// 쪽지
  /// - Parameter sender: UIButton
  @IBAction func messageButtonTouched(sender: UIButton) {
    let destination = MessageListViewController.instantiate(storyboard: "Home").coverNavigationController()
    destination.hero.isEnabled = true
    destination.hero.modalAnimationType = .autoReverse(presenting: .cover(direction: .left))
    destination.modalPresentationStyle = .fullScreen
    self.present(destination, animated: true, completion: nil)
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - SkeletonCollectionViewDelegate
//-------------------------------------------------------------------------------------------
extension HomeViewController: SkeletonCollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if collectionView == self.petCollectionView {
      let destination = RegistPetViewController.instantiate(storyboard: "MyPet").coverNavigationController()
      if let firstViewController = destination.viewControllers.first {
        let viewController = firstViewController as! RegistPetViewController
        viewController.animal_idx = self.myPetList[indexPath.row].animal_idx ?? ""
      }
      destination.hero.isEnabled = true
      destination.hero.modalAnimationType = .autoReverse(presenting: .cover(direction: .left))
      destination.modalPresentationStyle = .fullScreen
      self.present(destination, animated: true, completion: nil)
    } else if collectionView == self.bannerCollectionView {
      Tools.shared.openBrowser(urlString: self.bannerList[indexPath.row].link_url ?? "")
    }
  }
  
}

//-------------------------------------------------------------------------------------------
// MARK: - SkeletonCollectionViewDataSource
//-------------------------------------------------------------------------------------------
extension HomeViewController: SkeletonCollectionViewDataSource {
  func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 2
  }
  
  func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
    if skeletonView == self.complimentCollectionView {
      return "ComplimentCell"
    } else {
      return "TagCell"
    }
    
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView == self.complimentCollectionView {
      return self.complimentList.count
    }else if collectionView == self.bannerCollectionView{
      return self.bannerList.count
    } else {
      return self.myPetList.count
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView == self.complimentCollectionView {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComplimentCell", for: indexPath) as! ComplimentCell
      guard self.complimentList.count > 0 else { return cell }
      cell.setComplimentData(complimentData: self.complimentList[indexPath.row])
      
      return cell
    } else if collectionView == self.bannerCollectionView {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as! BannerCell
      guard self.bannerList.count > 0 else { return cell }
      cell.setBannderData(bannerData: self.bannerList[indexPath.row])
      return cell
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetImageCell", for: indexPath) as! PetImageCell
      guard self.myPetList.count > 0 else { return cell }
      let petData = self.myPetList[indexPath.row]
      cell.petImageView.sd_setImage(with: URL(string: Tools.shared.thumbnailImageUrl(url: petData.animal_img_path ?? "")), placeholderImage: UIImage(named: "default_dog1"), options: .lowPriority, context: nil)
      return cell
    }
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionViewDelegateFlowLayout
//-------------------------------------------------------------------------------------------
extension HomeViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if collectionView == self.complimentCollectionView {
      let width = (self.view.frame.size.width - 40) / 2
      return CGSize(width: width, height: 44)
    } else if collectionView == self.bannerCollectionView {
      let width = (self.view.frame.size.width - 40)
      let height =  (335 * 111) / width
      return CGSize(width: width, height: height)
    } else {
      return CGSize(width: 90, height: 90)
    }
  }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    if collectionView == self.petCollectionView || collectionView == self.bannerCollectionView{
      return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    } else {
      return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - SkeletonTableViewDelegate
//-------------------------------------------------------------------------------------------
extension HomeViewController: SkeletonTableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    let vc = FriendAskDetailViewController.instantiate(storyboard: "Walk")
//    vc.record_idx = self.rankingList[indexPath.row].record_idx ?? ""
//    let destination = vc.coverNavigationController()
//    destination.hero.isEnabled = true
//    destination.hero.modalAnimationType = .autoReverse(presenting: .cover(direction: .left))
//    destination.modalPresentationStyle = .fullScreen
//    self.present(destination, animated: true, completion: nil)
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - SkeletonTableViewDataSource
//-------------------------------------------------------------------------------------------
extension HomeViewController: SkeletonTableViewDataSource {
  func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
    return "RankingCell"
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.rankingList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "RankingCell", for: indexPath) as! RankingCell
    guard self.rankingList.count > 0 else { return cell }
    cell.setRankingData(recordData: self.rankingList[indexPath.row])
    return cell
  }
  

}
