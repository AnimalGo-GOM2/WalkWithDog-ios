//
//  MemberModel.swift
//  animalgo
//
//  Created by rocket on 10/06/2019.
//  Copyright © 2019 rocateer. All rights reserved.
//

import Foundation
import ObjectMapper

class MemberModel: BaseListModel {
  /// 회원 아이디
  var member_id: String?
  /// 회원 비밀번호
  var member_pw: String?
  /// 회원 비밀번호 확인
  var member_pw_confirm: String?
  /// 회원 새로운 비밀번호 - 비멀번호 변경 시 사용
  var new_member_pw: String?
  /// 회원 새로운 비밀번호 확인 - 비밀번호 변경 시 사용
  var new_member_pw_check: String?
  /// SNS 회원가입시 타입 (C: 일반, K: 카카오톡, F: 페이스북, N: 네이버)
  var member_join_type: String?
  /// 회원 이름
  var member_name: String?
  /// 회원 닉네임
  var member_nickname: String?
  /// 회원 생년월일
  var member_birth: String?
  /// 회원 휴대폰 번호
  var member_phone: String?
  /// 인증키
  var verify_idx: String?
  /// 인증번호
  var verify_num: String?
  /// 인증확인
  var verify_yn: String?
  /// 회원 성별: (0: 남성, 1: 여성, 2: 무관-사용 안함)
  var member_gender: String?
  /// 회원 이미지
  var member_img: String?
  /// 회원 알림 설정: (Y: 사용함, N: 사용안함)
  var alarm_yn: String?
  /// 회원 탈퇴 사유: (0: 사용하지 않음, 1: 컨텐츠 부족, 2: 부적절한 컨텐츠, 3: 기타)
  var member_leave_type: String?
  /// 회원탈퇴 사유 내용
  var member_leave_reason: String?
  ///  기록 키
  var record_idx: String?
  /// 산책친구 대화 알림 yn
  var chatting_alarm_yn: String?
  /// 산책중 가이드 메시지 알림 yn
  var guide_alarm_yn: String?
  /// 마케팅 정보 이용 동의 yn
  var marketing_agree_yn: String?
  ///설정 타입(0: 선택친구 대화 알림, 1: 산책중 가이드 알림, 2: 마케팅 동의여부)
  var type: String?
  ///설정 값(Y: 설정, N: 미설정)
  var value: String?
  /// 회원 연령대
  var member_age: String?
  /// 산책거리
  var total_record_distant: String?
  /// 산책횟수
  var total_record_cnt: String?
  /// 산책준비 별점
  var review_0: String?
  /// 산책매너 별점
  var review_1: String?
  /// 시간약속 별점
  var review_2: String?
  /// 사교성 별점
  var review_3: String?
  /// 회원키(신고 대상)
  var partner_member_idx: String?
  /// 신고유형(0:부적절한대화,1:불친절한매너,2:기타)
  var report_type: String?
  /// 신고내용 :: * report_type 2번일 때 필수입력
  var report_contents: String?
  /// 신고 사진
  var img_path: String?
  /// 가입일
  var ins_date: String?
  /// 쪽지 인덱스
  var memo_idx: String?
  /// 내용
  var contents: String?
  /// 쪽지 읽음 여부
  var read_yn: String?
  /// 검색어
  var search: String?
  var unread_cnt: Int?
  /// 제목
  var title: String?
  /// 앱 링크
  var ios_url: String?
  
  var memo_date: String?
  var block_type: String?
  var block_contents: String?
  var del_yn: String?
  
  /// 쪽지 리스트
  var data_array:[MemberModel]?
  
  override func mapping(map: Map) {
    super.mapping(map: map)
    self.member_id <- map["member_id"]
    self.member_pw <- map["member_pw"]
    self.member_pw_confirm <- map["member_pw_confirm"]
    self.new_member_pw <- map["new_member_pw"]
    self.new_member_pw_check <- map["new_member_pw_check"]
    self.member_join_type <- map["member_join_type"]
    self.member_name <- map["member_name"]
    self.member_nickname <- map["member_nickname"]
    self.member_birth <- map["member_birth"]
    self.member_phone <- map["member_phone"]
    self.verify_idx <- map["verify_idx"]
    self.verify_num <- map["verify_num"]
    self.verify_yn <- map["verify_yn"]
    self.member_gender <- map["member_gender"]
    self.member_img <- map["member_img"]
    self.alarm_yn <- map["alarm_yn"]
    self.member_leave_type <- map["member_leave_type"]
    self.member_leave_reason <- map["member_leave_reason"]
    self.record_idx <- map["record_idx"]
    self.chatting_alarm_yn <- map["chatting_alarm_yn"]
    self.guide_alarm_yn <- map["guide_alarm_yn"]
    self.marketing_agree_yn <- map["marketing_agree_yn"]
    self.type <- map["type"]
    self.value <- map["value"]
    self.member_age <- map["member_age"]
    self.total_record_distant <- map["total_record_distant"]
    self.total_record_cnt <- map["total_record_cnt"]
    self.review_0 <- map["review_0"]
    self.review_1 <- map["review_1"]
    self.review_2 <- map["review_2"]
    self.review_3 <- map["review_3"]
    self.partner_member_idx <- map["partner_member_idx"]
    self.report_type <- map["report_type"]
    self.report_contents <- map["report_contents"]
    self.img_path <- map["img_path"]
    self.ins_date <- map["ins_date"]
    self.memo_idx <- map["memo_idx"]
    self.contents <- map["contents"]
    self.read_yn <- map["read_yn"]
    self.search <- map["search"]
    self.unread_cnt <- map["unread_cnt"]
    self.title <- map["title"]
    self.ios_url <- map["ios_url"]
    self.memo_date <- map["memo_date"]
    self.block_type <- map["block_type"]
    self.block_contents <- map["block_contents"]
    self.del_yn <- map["del_yn"]
    
    self.data_array <- map["data_array"]
  }
}
