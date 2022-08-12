//
//  RecordModel.swift
//  animalgo
//
//  Created by rocateer on 2021/12/01.
//  Copyright © 2021 rocateer. All rights reserved.
//


import Foundation
import ObjectMapper

class RecordModel: BaseListModel {
  /// 산책 키
  var record_idx: String?
  /// 산책 일시
  var record_date: String?
  /// 산책 주소
  var record_addr: String?
  /// 안읽은 채팅이 있는지 (Y:있음, N:없음)
  var new_chat_yn: String?
  /// 반려견 수 (animal_name 외 member_animal_cnt-1마리  하시면 됩니다!)
  var member_animal_cnt: Int?
  /// 반려견 키
  var animal_idx: String?
  /// 반려견 이름
  var animal_name: String?
  /// 반려견 이미지
  var animal_img_path: String?
  /// 등록일
  var ins_date: String?
  /// 구분 (0: 내 산책에 지원한 산책친구 리스트, 1: 내가 지원한 산책친구 리스트)
  var type: String?
  /// 산책 구분(0: 나와 반려견만, 1: 산책 친구와 함께)
  var record_type: String?
  /// 내 반려견 키 (구분자 콤마)
  var member_animal_idxs: String?
  /// 이동거리(km)
  var record_distant: String?
  /// 이동시간(분)
  var record_hour: String?
  /// 산책 시작일시(yyyy-mm-dd hh:ii)
  var record_start_date: String?
  /// 주행기록 좌표 (lat:"위도",lng:"경도")
  var location: String?
  /// 위도
  var lat: String?
  /// 경도
  var lng: String?
  /// 산책 일기 키
  var record_diary_idx: String?
  /// 사진 (구분자 쉼표)
  var record_img_paths: String?
  /// 내용
  var memo: String?
  /// 산책 준비
  var review_0: String?
  /// 산책 매너
  var review_1: String?
  /// 시간 약속
  var review_2: String?
  /// 사교성
  var review_3: String?
  /// 위치 정보
  var coordinates: String?
  /// 산책 시작 위도
  var record_lat: String?
  /// 산책 시작 경도
  var record_lng: String?
  /// 산책친구 조건 :: 반려견 성별(0:남아,1:여아, 상관없음: 공백)
  var animal_gender: String?
  
  var animal_year: String?
  /// 산책친구 조건 :: 성격(0:온순, 1:입질, 2:호기심많음,3:활동적, 상관없음: 공백)
  var animal_character: String?
  /// 산책친구 조건 :: 중성화여부(Y:함, N:안함, 상관없음: 공백)
  var animal_neuter: String?
  var animal_training: String?
  /// 산책친구 조건 :: 보호자 성별 (0:남성,1:여성, 상관없음: 공백)
  var guardian_gender: String?
  /// 산책친구 조건 :: 보호자 나이대(20: 20대, 30: 30대, 40: 40대, 50: 50대 이상, 상관없음: 공백)
  var guardian_age: String?
  ///  산책친구 조건 :: 견종 (구분자 콤마, 상관없음 공백)
  var second_category_idx: String?
  /// 회원 위도
  var member_lat: String?
  /// 회원 경도
  var member_lng: String?
  /// 회원 이미지
  var member_img: String?
  /// 닉네임
  var member_nickname: String?
  /// 나이
  var member_age: String?
  /// 성별
  var member_gender: String?
  /// 지원 여부 Y(:본 산책에 지원 N:본 산책에 지원 안함)
  var apply_yn: String?
  /// 첫 대화 메세지
  var comment: String?
  /// 견종
  var category_name: String?
  /// 새로운 채팅 개수
  var new_chat_cnt: String?
  var chatting_room_idx: String?
  /// 가이드 이미지
  var guide_img: String?
  /// 채팅 버튼 활성화 여부(Y:활성화, N:비활성화)
  var chat_active_yn: String?
  /// 산책 지원 키
  var record_participant_idx: String?
  var partner_member_idx: String?
  var partner_animal_cnt: Int?
  
  
  var breedList: [RecordModel]?
  var data_array: [RecordModel]?
  var my_animal_array: [RecordModel]?
  var member_animal_array: [RecordModel]?
  var record_animal_array: [RecordModel]?
  var animal_array: [RecordModel]?
  var partner_animal_array: [RecordModel]?

  
  override func mapping(map: Map) {
    super.mapping(map: map)
    
    self.record_idx <- map["record_idx"]
    self.record_date <- map["record_date"]
    self.record_addr <- map["record_addr"]
    self.new_chat_yn <- map["new_chat_yn"]
    self.member_animal_cnt <- map["member_animal_cnt"]
    self.animal_idx <- map["animal_idx"]
    self.animal_name <- map["animal_name"]
    self.animal_img_path <- map["animal_img_path"]
    self.type <- map["type"]
    self.record_type <- map["record_type"]
    self.member_animal_idxs <- map["member_animal_idxs"]
    self.record_distant <- map["record_distant"]
    self.record_hour <- map["record_hour"]
    self.record_start_date <- map["record_start_date"]
    self.location <- map["location"]
    self.lat <- map["lat"]
    self.lng <- map["lng"]
    self.record_diary_idx <- map["record_diary_idx"]
    self.record_img_paths <- map["record_img_paths"]
    self.memo <- map["memo"]
    self.review_0 <- map["review_0"]
    self.review_1 <- map["review_1"]
    self.review_2 <- map["review_2"]
    self.review_3 <- map["review_3"]
    self.coordinates <- map["coordinates"]
    self.record_lat <- map["record_lat"]
    self.record_lng <- map["record_lng"]
    self.animal_gender <- map["animal_gender"]
    self.animal_year <- map["animal_year"]
    self.animal_character <- map["animal_character"]
    self.animal_neuter <- map["animal_neuter"]
    self.animal_training <- map["animal_training"]
    self.guardian_gender <- map["guardian_gender"]
    self.guardian_age <- map["guardian_age"]
    self.second_category_idx <- map["second_category_idx"]
    self.member_lat <- map["member_lat"]
    self.member_lng <- map["member_lng"]
    self.member_img <- map["member_img"]
    self.member_nickname <- map["member_nickname"]
    self.member_age <- map["member_age"]
    self.member_gender <- map["member_gender"]
    self.apply_yn <- map["apply_yn"]
    self.comment <- map["comment"]
    self.category_name <- map["category_name"]
    self.new_chat_cnt <- map["new_chat_cnt"]
    self.chatting_room_idx <- map["chatting_room_idx"]
    self.guide_img <- map["guide_img"]
    self.chat_active_yn <- map["chat_active_yn"]
    self.record_participant_idx <- map["record_participant_idx"]
    self.partner_member_idx <- map["partner_member_idx"]
    self.partner_animal_cnt <- map["partner_animal_cnt"]
    
    self.data_array <- map["data_array"]
    self.my_animal_array <- map["my_animal_array"]
    self.member_animal_array <- map["member_animal_array"]
    self.record_animal_array <- map["record_animal_array"]
    self.animal_array <- map["animal_array"]
    self.partner_animal_array <- map["partner_animal_array"]
    
  }
}
