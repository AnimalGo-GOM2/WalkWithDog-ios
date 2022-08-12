//
//  ChatModel.swift
//  animalgo
//
//  Created by rocateer on 2021/11/24.
//  Copyright © 2021 rocateer. All rights reserved.
//


import Foundation
import ObjectMapper

class ChatModel: BaseListModel {

  /// 마지막 채팅 날짜
  var last_chatting_date: String?
  /// 채팅방키
  var chatting_room_idx: String?
  /// 일자
  var st_date: String?
  /// 작성시간
  var ins_hi: String?
  /// 작성내용
  var comment: String?
  /// 이미지 경로
  var img_path: String?
  /// 이미지 세로
  var img_height: Int?
  /// 이미지 가로
  var img_width: Int?
  /// 탈퇴여부(Y/N)
  var del_yn: String?
  /// 이름
  var member_name: String?
  /// 프로필 이미지
  var member_img: String?
  /// 매칭키
  var member_like_idx: String?
  /// 상대방 회원키
  var partner_member_idx: String?
  /// 닉네임
  var member_nickname: String?
  /// 채팅 마지막 내용
  var last_chatting_comment: String?
  /// new 표시여부
  var new_icon_yn: String?
  /// 남은시간
  var date_diff: String?
  /// 상대방상태(N:정상,P:이용정지)
  var member_del_yn: String?
  /// 회원 성별
  var member_gender: String?
  /// 회원 나이
  var member_age: String?
  /// 산책일시
  var record_date: String?
  /// 차단여부(산책 등록자가 지원자를 차단했는지)
  var block_yn: String?
  /// 산책 지원 상태 (0:지원중,1:수락,2:거절,3:지원취소,4:산책취소됨)
  var state: String?
  /// 채팅종료 여부
  var chatting_close_yn: String?
  var record_idx: String?
  /// 산책 등록자의 회원 키
  var record_owner_idx: String?
  /// 산책 지원 키
  var record_participant_idx: String?

  /// 채팅 리스트
  var data_array: [ChatModel]?
  /// 일자 채팅 리스트
  var day_list_array: [ChatModel]?
  
  override func mapping(map: Map) {
    super.mapping(map: map)
    self.last_chatting_date <- map["last_chatting_date"]
    self.chatting_room_idx <- map["chatting_room_idx"]
    self.st_date <- map["st_date"]
    self.ins_hi <- map["ins_hi"]
    self.img_height <- map["img_height"]
    self.img_width <- map["img_width"]
    self.comment <- map["comment"]
    self.img_path <- map["img_path"]
    self.del_yn <- map["del_yn"]
    self.member_name <- map["member_name"]
    self.member_img <- map["member_img"]
    self.member_like_idx <- map["member_like_idx"]
    self.partner_member_idx <- map["partner_member_idx"]
    self.member_nickname <- map["member_nickname"]
    self.last_chatting_comment <- map["last_chatting_comment"]
    self.new_icon_yn <- map["new_icon_yn"]
    self.date_diff <- map["date_diff"]
    self.member_del_yn <- map["member_del_yn"]
    self.member_gender <- map["member_gender"]
    self.member_age <- map["member_age"]
    self.record_date <- map["record_date"]
    self.block_yn <- map["block_yn"]
    self.state <- map["state"]
    self.chatting_close_yn <- map["chatting_close_yn"]
    self.record_idx <- map["record_idx"]
    self.record_owner_idx <- map["record_owner_idx"]
    self.record_participant_idx <- map["record_participant_idx"]

    self.data_array <- map["data_array"]
    self.day_list_array <- map["day_list_array"]
  }
}
