//
//  AppDelegate.swift
//  animalgo
//
//  Created by rocateer on 08/01/2019.
//  Copyright © 2019 rocateer. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import SwiftyBeaver
import IQKeyboardManagerSwift
import SDWebImage
import SKPhotoBrowser
import UserNotifications
import AlamofireNetworkActivityLogger
import Hero
import NMapsMap
import SwiftLocation
import Defaults

let log = SwiftyBeaver.self
let NOTIFICATION_GPS_DATA = Notification.Name("NOTIFICATION_GPS_DATA")
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
//  var window: UIWindow?
  var fcmKey: String?
  
  let gcmMessageIDKey = "gcm.message_id"
  var userInfo: [AnyHashable : Any]?
  var myAnimalList = [AnimalModel]()

  var timer: Timer?

  var pushIndex = ""
  var chatting_room_idx = ""
  var isChangeAuthorization = true
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    
    UNUserNotificationCenter.current().delegate = self
    Messaging.messaging().delegate = self
    
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
    } else {
      let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }
    
    application.registerForRemoteNotifications()
    
    if let notification = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [String: Any] {
      if let index = notification["index"] as? String {
        self.pushIndex = index
        self.chatting_room_idx = notification["chatting_room_idx"] as? String ?? ""
        
        log.debug(self.pushIndex)
      }
      
    }
    
//   네이버지도
    NMFAuthManager.shared().clientId = "qeqwv19ug3"
    
    
    self.applicationSetting()
    
    return true
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
    print(userInfo)
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
    print(userInfo)
    completionHandler(UIBackgroundFetchResult.newData)
  }
  
  // MARK: UISceneSession Lifecycle
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
  
  
  /// 기록 시간 타이머
  @objc func timerAction() {
//    let recording_time = Defaults[.recording_time] ?? 0
//    Defaults[.recording_time] = recording_time + 1
    
    if let start_date = Defaults[.start_date] {
      let diffDate = Date().timeIntervalSince(start_date)
      Defaults[.recording_time] = Int(diffDate)
    } else {
      Defaults[.recording_time] = 0
    }

    // 가이드 알림 산책 ON 한 회원에게만 전송
    if Defaults[.guide_alarm_yn] == "Y" {
      if (Defaults[.recording_time] ?? 0) % 600 == 0 {
        var title = ""
        if Defaults[.record_type] == "0" {
          title = TRACKING_PUSH_TEXT.random() ?? ""
        } else {
          title = TRACKING_PUSH_TEXT_WITH_FRIEND.random() ?? ""
        }
        self.sendLocalPushNotification(title: "애니멀고 산책", subtitle: title, object: "record")
      }
    }
  }
  
  /// 로컬 노티피케이션
  /// - Parameters:
  ///   - title: 제목
  ///   - subtitle: 부제목
  ///   - object: 데이터
  ///   - afterInterval: 인터벌
  func sendLocalPushNotification(title: String, subtitle: String, object: Any? = nil, afterInterval: TimeInterval = 0.1) {
    let content = UNMutableNotificationContent()
    content.title = title
//    content.subtitle = subtitle
    content.body = subtitle
    content.sound = UNNotificationSound.default
    
    if let object = object {
      content.userInfo = ["result": object]
    }
    
    // show this notification five seconds from now
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: afterInterval, repeats: false)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request)
  }
  
}

extension AppDelegate {
  
  /// 어플리케이션 기본 세팅
  ///  - 로그
  ///  - IQKeyboard
  ///  - SD Web image 세팅
  ///  - SKPhotoBrowser
  func applicationSetting() {
    
    //SwiftyBeaver
    let console = ConsoleDestination()  // log to Xcode Console
    
    
    // add the destinations to SwiftyBeaver
    log.addDestination(console)
    log.verbose("not so important")  // prio 1, VERBOSE in silver
    log.debug("something to debug")  // prio 2, DEBUG in green
    log.info("a nice information")   // prio 3, INFO in blue
    log.warning("oh no, that won’t be good")  // prio 4, WARNING in yellow
    log.error("ouch, an error did occur!")  // prio 5, ERROR in red
    
    // Alamofire
    NetworkActivityLogger.shared.level = .debug
    NetworkActivityLogger.shared.startLogging()
    
    // IQKeyboardManager 세팅
    IQKeyboardManager.shared.enable = true
    //    IQKeyboardManager.shared.keyboardDistanceFromTextField = 100
    IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    
    // SD WEB Image 세팅
    SDImageCache.shared.store(nil, forKey: nil, toDisk: false, completion: nil)
    
    NSSetUncaughtExceptionHandler { (exception) in
      log.error(exception.description)
    }
    
    // SKPhotoBrowser 세팅
    SKPhotoBrowserOptions.displayStatusbar = false
    SKPhotoBrowserOptions.displayCounterLabel = true
    SKPhotoBrowserOptions.displayBackAndForwardButton = true
    SKPhotoBrowserOptions.displayAction = false
    SKPhotoBrowserOptions.displayDeleteButton = false
    SKPhotoBrowserOptions.displayHorizontalScrollIndicator = false
    SKPhotoBrowserOptions.displayVerticalScrollIndicator = false
    SKPhotoBrowserOptions.bounceAnimation = true
    
  
    // UI 세팅
    // 네비게이션
    let navigationBarAppearance = UINavigationBarAppearance()
    navigationBarAppearance.shadowColor = .clear
    navigationBarAppearance.shadowImage = nil
    navigationBarAppearance.backgroundColor = UIColor(named: "FFFFFF")
    navigationBarAppearance.titleTextAttributes = [
      NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold),
      NSAttributedString.Key.foregroundColor: UIColor(named: "000000")!
    ]
    
    UINavigationBar.appearance().standardAppearance = navigationBarAppearance
    UINavigationBar.appearance().compactAppearance = navigationBarAppearance
    UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    if #available(iOS 15, *) {
      UINavigationBar.appearance().compactScrollEdgeAppearance = navigationBarAppearance
    }
   
    // 하단 탭바
    let appearance = UITabBarAppearance()
    if #available(iOS 13, *) {
      appearance.backgroundColor = .white
      appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
        NSAttributedString.Key.font:UIFont.systemFont(ofSize: 11, weight: .medium),NSAttributedString.Key.foregroundColor: UIColor(named: "999999")!]
      appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
        NSAttributedString.Key.font:UIFont.systemFont(ofSize: 11, weight: .medium),NSAttributedString.Key.foregroundColor: UIColor(named: "accent")!]

      UITabBar.appearance().standardAppearance = appearance
    } else {
      UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 11, weight: .medium),NSAttributedString.Key.foregroundColor: UIColor(named: "999999")!], for: .normal)
      UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 11, weight: .medium),NSAttributedString.Key.foregroundColor: UIColor(named: "accent")!], for: .selected)
    }
 

    if #available(iOS 15, *) {
      UITabBar.appearance().scrollEdgeAppearance = UITabBar.appearance().standardAppearance
    }
     
    self.getLocation()
    
    Hero.shared.containerColor = .clear
    
  }
  
  /// 제일 상단 컨트롤러
  /// - Returns: controller
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
  
  // 위치정보 가져오기
  func getLocation() {
    // GPS
    let serviceOptions = GPSLocationOptions()
    serviceOptions.accuracy = .block
    serviceOptions.subscription = .continous
    let locationRequest = SwiftLocation.gpsLocationWith(serviceOptions)
    
    if locationRequest.isEnabled {
      locationRequest.then(queue: .main) { result in
        switch result {
        case .success(let location):
          print("Location is \(String(describing: location))")
  //        if Defaults[.currentLat] == nil || Defaults[.currentLng] == nil {
  //          Defaults[.currentLat] = location.coordinate.latitude
  //          Defaults[.currentLng] = location.coordinate.longitude
  //        }
          Defaults[.currentLat] = location.coordinate.latitude
          Defaults[.currentLng] = location.coordinate.longitude
        
          if self.isChangeAuthorization {
            self.isChangeAuthorization = false
            NotificationCenter.default.post(name: Notification.Name("MainUpdate"), object: nil)
            NotificationCenter.default.post(name: Notification.Name("UpdateLocation"), object: nil)
          }
          break
        case .failure(let error):
          log.error(error.localizedDescription)
          self.isChangeAuthorization = true
        }
      }
    } else {
      self.isChangeAuthorization = false
      NotificationCenter.default.post(name: Notification.Name("MainUpdate"), object: nil)
      NotificationCenter.default.post(name: Notification.Name("UpdateLocation"), object: nil)
    }
  }
  
}



@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
  
  // Foreground에 있을 경우
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo
    
    print("FOREGROUND = \(userInfo)")
    
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
    
    if let index = userInfo["index"] as? String {
      if index == "101" || index == "900" || index == "201" { // 채팅 업데이트
        NotificationCenter.default.post(name: Notification.Name("ChattingDetailUpdate"), object: nil)
      }
    }
    
    completionHandler(UNNotificationPresentationOptions.alert)
  }
  
  // Foreground 로 돌아 올때
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    let responseUserInfo = response.notification.request.content.userInfo
    log.debug(responseUserInfo)
    
    if let index = responseUserInfo["index"] as? String {
      self.pushIndex = index
      self.chatting_room_idx = responseUserInfo["chatting_room_idx"] as? String ?? ""
    }
    
    log.debug("BACKGROUND = \(userInfo)")
    
    let state = UIApplication.shared.applicationState
    
    if state == .active || state == .inactive {
      let notificationCenter = NotificationCenter.default
      notificationCenter.post(name: Notification.Name("PushNotification"), object: nil)
    }
    
    
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
    self.userInfo = userInfo
    
    completionHandler()
  }
}
//-------------------------------------------------------------------------------------------
// MARK: - MessagingDelegate
//-------------------------------------------------------------------------------------------
extension AppDelegate : MessagingDelegate {
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Firebase registration token: \(fcmToken ?? "")")
    //    LocalStore.gcm.value = fcmToken
    self.fcmKey = fcmToken
  }
  
}
