//
//  Tools.swift
//  자주 사용하는 함수 모음
//
//  Created by rocket on 2021/05/11.
//  Copyright © 2021 rocateer. All rights reserved.
//

import Foundation
import NotificationBannerSwift

class Tools {
  static let shared = Tools()
  
  private init() {
  }
  
  
  /// API 성공 유무를 판단
  /// - Parameter response:
  /// - Returns: 성공 여부
  func isSuccessResponse(response: BaseModel) -> Bool {
    let successCode = [ "1000", "1001", "1002", "1003", "2000", "2001", "3000", "3001", "3002", "3003", "3004", "3005", "3006", "3007", "3008", "3009", "3010", "3013", "3014" ]     // 성공만 있을 경우
    let messageCode = [ "3015", "3016" ]         // 성공 후 메세지를 띄워줄때
    
    if let code = response.code {
      // 성공의 경우
      if successCode.contains(code) {
        return true
      } else if messageCode.contains(code) {
        return true
      } else {
        self.showToast(message: response.code_msg ?? "")
        return false
      }
    } else {
      self.showToast(message: "알 수 없는 오류가 발생하였습니다.")
      return false
    }
  }
  
  /// 숫자 String 에 ",(콤마)" 표시 추가
  /// - Parameter value: 숫자 String
  /// - Returns: 결과 값
  func numberPlaceValue(_ value: String?) -> String {
    guard value != nil else { return "0" }
    let doubleValue = Double(value!) ?? 0.0
    let formatter = NumberFormatter()
    formatter.currencyCode = "KRW"
    formatter.currencySymbol = ""
    formatter.minimumFractionDigits = 0 //(value!.contains(".00")) ? 0 : 2
    formatter.maximumFractionDigits = 0
    formatter.numberStyle = .currencyAccounting
    return formatter.string(from: NSNumber(value: doubleValue)) ?? "\(doubleValue)"
  }
  
  
  /// 토스트 표시
  /// - Parameter message: 배너 내용
  func showToast(message: String) {
    let banner = FloatingNotificationBanner(title: message, subtitle: nil, titleFont: UIFont.systemFont(ofSize: 14), titleColor: .white, titleTextAlign: .left, subtitleFont: nil, subtitleColor: nil, subtitleTextAlign: nil, leftView: nil, rightView: nil, style: .info, colors: .none, iconPosition: .center)
    banner.backgroundColor = UIColor(named: "333333")!
    banner.duration = 2
    banner.animationDuration = 0.3
    banner.bannerHeight = 70

    banner.show(queuePosition: .front, bannerPosition: .bottom, queue: .default, on: nil, edgeInsets: UIEdgeInsets(inset: 10), cornerRadius: 5, shadowColor: .black, shadowOpacity: 0.3, shadowBlurRadius: 5, shadowCornerRadius: 5, shadowOffset: UIOffset(horizontal: 0, vertical: 10), shadowEdgeInsets: UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0))
  }
  
  
  
  /// 전화 걸기
  /// - Parameter tel: 전화번호
  func openPhone(tel: String) {
    if let url = URL(string: "tel://\(tel)"), UIApplication.shared.canOpenURL(url) {
      if #available(iOS 10, *) {
        UIApplication.shared.open(url, options: [:], completionHandler:nil)
      } else {
        UIApplication.shared.openURL(url)
      }
    }
  }
  
  /// 외부 링크 열기
  /// - Parameter url: 링크
  func openBrowser(urlString: String) {
    if let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
  }
  
  /// 클립보드에 복사
  /// - Parameter text: 복사할 문자
  func copyToClipboard(text: String) {
    UIPasteboard.general.string = text
  }
  
  /// 썸네일 url
  /// - Parameter url: url
  /// - Returns: 썸네일 url
  func thumbnailImageUrl(url: String) -> String {
    if url.contains(".jpg") {
      return "\(baseURL)\(url.components(separatedBy: ".jpg")[0])_s.jpg"
    } else if url.contains(".jpeg") {
      return "\(baseURL)\(url.components(separatedBy: ".jpeg")[0])_s.jpeg"
    } else if url.contains(".png") {
      return "\(baseURL)\(url.components(separatedBy: ".png")[0])_s.png"
    } else {
      return ""
    }
  }
  


}
