//
//  APIRouter.swift
//  animalgo
//
//  Created by rocket on 11/06/2019.
//  Copyright © 2019 rocateer. All rights reserved.
//

import Alamofire
import ObjectMapper
import SwiftyJSON
import Result
import NVActivityIndicatorView
import Defaults

#if DEBUG
let baseURL = "http://api.animalgowalk.co.kr/"
#else
let baseURL = "http://api.animalgowalk.co.kr/"
#endif

typealias JSONDict = [String: AnyObject]
typealias APIParams = [String: AnyObject]?

enum APIResult<T, Error> {
  case success(T)
  case fail(NSError)
  case unexpect(NSError)
}

enum APIURL: String {
  /// 공통
  case fileUpload_action = "common/fileUpload_action" // 이미지 업로드
  
  /// 회원가입/로그인
  case member_reg_in = "join_v_1_0_0/member_reg_in" // 회원가입
  case member_login = "login_v_1_0_0/member_login" // 로그인
  case member_id_find = "find_id_v_1_0_0/member_id_find" // 아이디 찾기
  case member_pw_reset_send_email = "find_pw_to_email_v_1_0_0/member_pw_reset_send_email" // 비밀번호 찾기
  case tel_verify_setting = "tel_verify_v_1_0_0/tel_verify_setting" // 휴대전화 인증키 발급
  case tel_verify_confirm = "tel_verify_v_1_0_0/tel_verify_confirm" // 휴대전화 인증키 확인
  case member_pw_mod_up = "member_pw_change_v_1_0_0/member_pw_mod_up" // 비밀번호 변경
  case member_info_detail = "member_info_v_1_0_0/member_info_detail" // 회원정보 상세보기
  case member_info_mod_up = "member_info_v_1_0_0/member_info_mod_up" // 회원정보 수정
  case member_out_up = "member_out_v_1_0_0/member_out_up" // 회원탈퇴
  case report_reg_in = "member_report_v_1_0_0/report_reg_in" // 신고하기
  case block_reg_in = "member_block_v_1_0_0/block_reg_in" // 차단하기
  
  /// 메인
  case banner_list = "banner_v_1_0_0/banner_list" // 배너 리스트
  case main = "main_v_1_0_0/main" // 메인
  
  /// 쪽지
  case memo_list = "memo_v_1_0_0/memo_list" // 쪽지 리스트
  case read_all = "memo_v_1_0_0/read_all" // 쪽지 모두 읽음
  case memo_detail = "memo_v_1_0_0/memo_detail" // 쪽지 상세
  case memo_reg_view = "memo_v_1_0_0/memo_reg_view" // 쪽지 보내기 폼
  case memo_reg_in = "memo_v_1_0_0/memo_reg_in" // 쪽지 보내기
  case member_list = "memo_v_1_0_0/member_list" // 회원리스트(검색)
  
  /// 산책하기
  case registered_record_list = "record_v_1_0_0/registered_record_list" // 산책친구 등록 리스트
  case registered_record_detail = "record_v_1_0_0/registered_record_detail" // 산책친구 등록 상세
  case registered_record_cancel = "record_v_1_0_0/registered_record_cancel" // 산책친구 등록 취소
  case record_apply_member_list = "record_v_1_0_0/record_apply_member_list" // 산책친구 지원한 친구들
  
  case record_apply_list = "record_v_1_0_0/record_apply_list" // 산책친구 지원 리스트
  case record_apply_reg_in = "record_v_1_0_0/record_apply_reg_in" // 산책친구 지원
  case record_apply_cancel = "record_v_1_0_0/record_apply_cancel" // 산책친구 지원 취소
  case record_apply_refuse = "record_v_1_0_0/record_apply_refuse" // 산책친구 지원 거부
  case record_start = "record_v_1_0_0/record_start" // 산책친구 수락
  case partner_animal_list = "record_v_1_0_0/partner_animal_list" // 산책친구 상대 반려견 리스트
  
  case record_together_list = "record_v_1_0_0/record_together_list" // 산책친구와 함께
  case record_guide = "record_v_1_0_0/record_guide" // 산책 가이드
  
  /// 채팅
  case chatting_room_detail = "chatting_v_1_0_0/chatting_room_detail" // 채팅 상세
  case chatting_list = "chatting_v_1_0_0/chatting_list" // 채팅방 내용
  case chatting_reg_in = "chatting_v_1_0_0/chatting_reg_in" // 채팅 등록
  
  /// 산책기록
  case record_reg_in = "record_v_1_0_0/record_reg_in" // 산책 등록
  case diary_reg_view = "record_v_1_0_0/diary_reg_view" // 산책친구 등록 폼
  case tracking_reg_in = "record_v_1_0_0/tracking_reg_in" // 트래킹정보 저장
  case diary_reg_in = "record_v_1_0_0/diary_reg_in" // 산책친구 등록
  case record_diary_list = "record_v_1_0_0/record_diary_list" // 산책기록 리스트
  case record_diary_detail = "record_v_1_0_0/record_diary_detail" // 산책기록 상세
  
  /// 내 반려견
  case my_animal_list = "animal_v_1_0_0/my_animal_list" // 내 반려견 리스트
  case animal_list_type = "animal_v_1_0_0/animal_list_type" // 견분류 리스트
  case animal_list_kind = "animal_v_1_0_0/animal_list_kind" // 견종 리스트
  case animal_list = "animal_v_1_0_0/animal_list" // 견분류, 견종 리스트
  case animal_reg_in = "animal_v_1_0_0/animal_reg_in" // 반려견 등록
  case animal_detail = "animal_v_1_0_0/animal_detail" // 반려견 상세
  case animal_mod_up = "animal_v_1_0_0/animal_mod_up" // 반려견 수정
  
  
  /// 설정
  case mypage_detail = "mypage_v_1_0_0/mypage_detail" // 마이페이지 상세
  case link_list = "mypage_v_1_0_0/link_list" // 앱 바로가기 링크 리스트
  case notice_list = "notice_v_1_0_0/notice_list" // 공지사항 리스트
  case notice_detail = "notice_v_1_0_0/notice_detail" // 공지사항 리스트
  case company_info = "company_info_v_1_0_0/company_info" // 회사소개
  case qa_list = "qa_v_1_0_0/qa_list" // QnA 리스트
  case qa_detail = "qa_v_1_0_0/qa_detail" // QnA 상세
  case qa_reg_in = "qa_v_1_0_0/qa_reg_in" // QnA 등록
  case qa_del = "qa_v_1_0_0/qa_del" // QnA 삭제
  case faq_list = "faq_v_1_0_0/faq_list" // FaQ 리스트
  case faq_category_list = "faq_v_1_1_0/faq_category_list" // Faq 카테고리
  case faq_list_1 = "faq_v_1_1_0/faq_list" // Faq 카테로리 리스트
  case event_list = "event_v_1_0_0/event_list" // 이벤트 리스트
  case alarm_list = "alarm_v_1_0_0/alarm_list" // 알림 리스트
  case alarm_del = "alarm_v_1_0_0/alarm_del" // 알림 삭제
  case alarm_toggle_view = "alarm_v_1_0_0/alarm_toggle_view" // 알림 설정 보기
  case alarm_toggle = "alarm_v_1_0_0/alarm_toggle" // 알림 설정
  case new_alarm_count = "alarm_v_1_0_0/new_alarm_count" // 새로 온 알림 카운트
  case alarm_all_del = "alarm_v_1_0_0/alarm_all_del" // 알림 전체삭제
  case member_logout = "logout_v_1_0_0/member_logout" // 로그아웃
  case member_pw_mod_view = "member_pw_change_v_1_0_0/member_pw_mod_view" // 비밀번호 변경 뷰
  case block_list = "member_block_v_1_0_0/block_list" // 차단 리스트
  
  case start_popup_detail = "start_popup_v_1_0_0/start_popup_detail" // 시작팝업
  case member_state_detail = "member_state_v_1_0_0/member_state_detail" // 회원 상태 확인
}


class APIRouter {
  // Singleton
  static let shared = APIRouter()
  var activityData: ActivityData = ActivityData()
  
  private init() {
    self.activityData = ActivityData(size: CGSize(width: 50, height: 50), message: "", messageFont: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular), type: NVActivityIndicatorType.circleStrokeSpin, color: UIColor(named: "333333"), padding: nil, displayTimeThreshold: 1, minimumDisplayTime: 300, backgroundColor: UIColor.clear, textColor: UIColor.black)
  }
  // 회원상태체크
  func memberCheck(closure: @escaping () -> ()) {
    
    if Defaults[.member_idx] != nil {
      let memberParam = MemberModel()
      memberParam.member_idx = Defaults[.member_idx]

      NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.activityData, nil)
      AF.request( baseURL + APIURL.member_state_detail.rawValue, method: .post, parameters: memberParam.toJSON(), headers: nil).responseJSON(completionHandler: { response in
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
         
        switch response.result {
        case .success(let value):
          if let memberResponse = MemberModel(JSON: value as! [String : Any]), memberResponse.del_yn == "N" {
            
            closure()
          }
          if let memberResponse = MemberModel(JSON: value as! [String : Any]), memberResponse.del_yn == "P" {
            AF.request(baseURL + APIURL.member_logout.rawValue, method: .post, parameters: memberParam.toJSON(), headers: nil).responseJSON(completionHandler: { response2 in
              Defaults.removeAll()
              Defaults[.tutorial] = true
              
              let destination = LoginViewController.instantiate(storyboard: "Login")
              let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
              window?.rootViewController = destination
              
              let alert = UIAlertController(title: "", message: "'이용 중지' 처리된 계정입니다", preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
              alert.show()
            })
          }
          break
        case .failure(_):
          Defaults.removeAll()
          Defaults[.tutorial] = true
          let destination = LoginViewController.instantiate(storyboard: "Login")
          let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
          window?.rootViewController = destination
          break
        }
      })
      
      
    } else {
      closure()
    }
  }
  
  
  
  /// Simple API
  /// - Parameters:
  ///   - path: API URL
  ///   - method: HTTP Method
  ///   - parameters: parameter
  ///   - success: 성공
  ///   - fail: 실패
  func api(path: APIURL, method: HTTPMethod = .post, parameters: [String: Any]?, success: @escaping(_ data: [String: Any])-> Void, fail: @escaping (_ error: Error?)-> Void) {
    self.memberCheck {
      NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.activityData, nil)
      AF.request( baseURL + path.rawValue, method:method, parameters: parameters, headers: nil).responseJSON(completionHandler: { response in
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        switch response.result {
        case .success(let value):
          success(value as! [String : Any])
        case .failure(let error):
          fail(error)
        }
      })
    }
  }
  
  
  /// Multipart Form
  /// - Parameters:
  ///   - path: API URL
  ///   - method: HTTP Method
  ///   - userFile: File
  ///   - success: 성공
  ///   - fail: 실패
  func api(path: APIURL, method: HTTPMethod = .post, file : Data, success: @escaping(_ data: [String: Any])-> Void, fail: @escaping (_ error: Error?)-> Void) {
    let headers: HTTPHeaders = [
      "Content-type": "multipart/form-data"
    ]
    NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.activityData, nil)
    AF.upload(multipartFormData: { (multipartFormData) in
    multipartFormData.append(file, withName: "file", fileName: "rocateer.jpg", mimeType: "image/jpeg")
    }, to: baseURL + path.rawValue, method: .post, headers: headers).responseJSON(completionHandler: { response in
      NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
      switch response.result {
      case .success(let value):
        success(value as! [String : Any])
      case .failure(let error):
        fail(error)
      }
    })
  }
  
  /// 주소 변환
  /// - Parameters:
  ///   - success: 성공
  ///   - fail: 실패
  func geo_api(lat: String, lng: String, success: @escaping(_ data: [String: Any])-> Void, fail: @escaping (_ error: Error?)-> Void) {

    let headers: HTTPHeaders = [
      "X-NCP-APIGW-API-KEY-ID" : "qeqwv19ug3",
      "X-NCP-APIGW-API-KEY" : "wKuf5yIIrUFkVq2gsjzyCbQr9mrGON2qW9JRRYif"
    ]
    
    let url = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords=\(lng),\(lat)&sourcecrs=epsg:4326&output=json&orders=addr,roadaddr"
    AF.request(url, method: .get, parameters: [:], headers: headers).responseJSON(completionHandler: { response in
      switch response.result {
      case .success(let value):
        success(value as! [String : Any])
      case .failure(let error):
        fail(error)
      }
    })
  }
}


