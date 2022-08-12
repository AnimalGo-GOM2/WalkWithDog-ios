//
//  MoreViewController.swift
//  animalgo
//
//  Created by rocateer on 2021/10/29.
//  Copyright © 2021 rocateer. All rights reserved.
//

import UIKit
import SkeletonView
import Defaults
import SafariServices

class MoreViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var moreScrollView: UIScrollView!
  @IBOutlet weak var starsStackView: UIStackView!
  @IBOutlet weak var starShadowView: UIView!
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var walkDistanceLabel: UILabel!
  @IBOutlet weak var numberOfWalkLabel: UILabel!
  @IBOutlet weak var prepareScoreLabel: UILabel!
  @IBOutlet weak var mannerScoreLabel: UILabel!
  @IBOutlet weak var timeScoreLabel: UILabel!
  @IBOutlet weak var socialityScoreLabel: UILabel!
  @IBOutlet weak var accountManagementView: UIView!
  @IBOutlet weak var customerCenterView: UIView!
  @IBOutlet weak var animalgoInfoView: UIView!
  @IBOutlet weak var sendSuggestionView: UIView!
  @IBOutlet weak var goAnimalgoAppView: UIView!
  @IBOutlet weak var profileView: UIView!
  @IBOutlet weak var nicknameLabel: UILabel!
  @IBOutlet weak var appTableView: UITableView!
  @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
  @IBOutlet weak var blockView: UIView!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var appList = [MemberModel]()
  let refreshControl = UIRefreshControl()
  
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(self.profileUpdate), name: Notification.Name("profileUpdate"), object: nil)
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = UIColor(named: "accent")!
    appearance.shadowImage = nil
    appearance.shadowColor = .clear
    navigationController?.navigationBar.tintColor = .white
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.compactAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
    
    self.profileImageView.showAnimatedSkeleton()
    self.walkDistanceLabel.showAnimatedSkeleton()
    self.numberOfWalkLabel.showAnimatedSkeleton()
    self.prepareScoreLabel.showAnimatedSkeleton()
    self.mannerScoreLabel.showAnimatedSkeleton()
    self.timeScoreLabel.showAnimatedSkeleton()
    self.socialityScoreLabel.showAnimatedSkeleton()
    
    self.appTableView.registerCell(type: AppListCell.self)
    self.appTableView.dataSource = self
    self.appTableView.delegate = self
    self.moreScrollView.addSubview(self.refreshControl)
    self.refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
    
    
    // 고객센터
    self.customerCenterView.addTapGesture { recognizer in
      let destination = CustomerCenterViewController.instantiate(storyboard: "More").coverNavigationController()
      destination.hero.isEnabled = true
      destination.hero.modalAnimationType = .autoReverse(presenting: .cover(direction: .left))
      destination.modalPresentationStyle = .fullScreen
      self.present(destination, animated: true, completion: nil)
    }
    
    // 애니멀고 정보
    self.animalgoInfoView.addTapGesture { recognizer in
      let destination = AnimalgoInfoViewController.instantiate(storyboard: "More").coverNavigationController()
      destination.hero.isEnabled = true
      destination.hero.modalAnimationType = .autoReverse(presenting: .cover(direction: .left))
      destination.modalPresentationStyle = .fullScreen
      self.present(destination, animated: true, completion: nil)
    }
    
    // 애니멀고 산책 의견 보내기
    self.sendSuggestionView.addTapGesture { recognizer in
      let destination = SuggestionViewController.instantiate(storyboard: "More").coverNavigationController()
      destination.hero.isEnabled = true
      destination.hero.modalAnimationType = .autoReverse(presenting: .cover(direction: .left))
      destination.modalPresentationStyle = .fullScreen
      self.present(destination, animated: true, completion: nil)
    }
    
    //계정관리
    self.accountManagementView.addTapGesture { recognizer in
      let destination = AccountManagerVIewController.instantiate(storyboard: "More").coverNavigationController()
      destination.hero.isEnabled = true
      destination.hero.modalAnimationType = .autoReverse(presenting: .cover(direction: .left))
      destination.modalPresentationStyle = .fullScreen
      self.present(destination, animated: true, completion: nil)
    }
    
    //프로필 관리
    self.profileView.addTapGesture { recognizer in
      let destination = ProfileModifyViewController.instantiate(storyboard: "More").coverNavigationController()
      destination.hero.isEnabled = true
      destination.hero.modalAnimationType = .autoReverse(presenting: .cover(direction: .left))
      destination.modalPresentationStyle = .fullScreen
      self.present(destination, animated: true, completion: nil)
    }
    
    // 차단관리
    self.blockView.addTapGesture { recognizer in
      let destination = BlockViewController.instantiate(storyboard: "More").coverNavigationController()
      destination.hero.isEnabled = true
      destination.hero.modalAnimationType = .autoReverse(presenting: .cover(direction: .left))
      destination.modalPresentationStyle = .fullScreen
      self.present(destination, animated: true, completion: nil)
    }
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    
    self.profileImageView.setCornerRadius(radius: 54)
    self.starsStackView.setCornerRadius(radius: 10)
    self.starShadowView.setCornerRadius(radius: 10)
    self.starShadowView.layer.shadowRadius = 10
    self.starShadowView.layer.shadowOpacity = 0.6
    self.starShadowView.layer.shadowColor = UIColor(named: "F6F6F6")!.cgColor
    self.starShadowView.layer.shadowOffset = CGSize(width: 0, height: 10)

    self.starShadowView.layer.masksToBounds = false
  }
  
  override func initRequest() {
    super.initRequest()
    self.mypageDetailAPI()
    self.appLinkAPI()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 더보기 상세 API
  func mypageDetailAPI() {
    let memberRequest = MemberModel()
    memberRequest.member_idx = Defaults[.member_idx]
    
    APIRouter.shared.api(path: .mypage_detail, parameters: memberRequest.toJSON()) { response in
      if let memberResponse = MemberModel(JSON: response), Tools.shared.isSuccessResponse(response: memberResponse) {
        self.refreshControl.endRefreshing()
        self.nicknameLabel.text = memberResponse.member_nickname
        self.profileImageView.sd_setImage(with: URL(string: "\(baseURL)\(memberResponse.member_img ?? "")"), placeholderImage: UIImage(named: "default_profile"), options: .lowPriority, context: nil)
        self.walkDistanceLabel.text = "\(memberResponse.total_record_distant ?? "0")km"
        self.numberOfWalkLabel.text = "\(memberResponse.total_record_cnt ?? "0")회"
        self.prepareScoreLabel.text = "\(memberResponse.review_0 ?? "0.0")"
        self.mannerScoreLabel.text = "\(memberResponse.review_1 ?? "0.0")"
        self.timeScoreLabel.text = "\(memberResponse.review_2 ?? "0.0")"
        self.socialityScoreLabel.text = "\(memberResponse.review_3 ?? "0.0")"
        
        self.profileImageView.hideSkeleton()
        self.walkDistanceLabel.hideSkeleton()
        self.numberOfWalkLabel.hideSkeleton()
        self.prepareScoreLabel.hideSkeleton()
        self.mannerScoreLabel.hideSkeleton()
        self.timeScoreLabel.hideSkeleton()
        self.socialityScoreLabel.hideSkeleton()
      }
    } fail: { error in
      Tools.shared.showToast(message: "알수 없는 오류가 발생하였습니다.")
    }
  }
  
  /// 앱 바로가기 링크 리스트
  func appLinkAPI() {
    APIRouter.shared.api(path: .link_list, parameters: nil) { response in
      if let appResponse = MemberModel(JSON: response), Tools.shared.isSuccessResponse(response: appResponse) {
        self.refreshControl.endRefreshing()
        if let data_array = appResponse.data_array {
          self.appList = data_array
          
        }
        self.tableViewHeight.constant = CGFloat(86 * self.appList.count)
        self.appTableView.reloadData()
      }
    } fail: { error in
      Tools.shared.showToast(message: "알수 없는 오류가 발생하였습니다.")
    }
  }
  
  /// 프로필  업데이트
  /// - Parameter notificaiton: notificaiton
  @objc func profileUpdate(notification: Notification) {
    self.mypageDetailAPI()
  }
  
  // 당겨서 새로고침
  @objc func refresh() {
    self.mypageDetailAPI()
    self.appLinkAPI()
  }
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  /// 설정 버튼
  /// - Parameter sender: UIBarButtonItem
  @IBAction func settingButtonTouched(sender: UIBarButtonItem) {
    let destination = SettingViewController.instantiate(storyboard: "More").coverNavigationController()
    destination.hero.isEnabled = true
    destination.hero.modalAnimationType = .autoReverse(presenting: .cover(direction: .left))
    destination.modalPresentationStyle = .fullScreen
    self.present(destination, animated: true, completion: nil)
  }
}

//-------------------------------------------------------------------------------------------
  // MARK: - UITableViewDelegate
  //-------------------------------------------------------------------------------------------
extension MoreViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    Tools.shared.openBrowser(urlString: self.appList[indexPath.row].ios_url ?? "")
  }
}
//-------------------------------------------------------------------------------------------
  // MARK: - UITableViewDataSource
  //-------------------------------------------------------------------------------------------
extension MoreViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.appList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "AppListCell", for: indexPath) as! AppListCell
    let app = self.appList[indexPath.row]
    
    cell.titleLabel.text = app.title ?? ""
    cell.contentsLabel.text = app.contents ?? ""
    
    return cell
  }
  
  
  
}
