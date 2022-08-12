//
//  AlarmModel.swift
//  animalgo
//
//  Created by rocket on 10/06/2019.
//  Copyright © 2019 rocateer. All rights reserved.
//

import Foundation
import ObjectMapper

class AlarmModel: BaseListModel {
  /// 알림 인덱스
  var alarm_idx: String?
  /// 알림 제목
  var msg: String?
  /// 알림 데이터: JSON 형식 > 파싱해서 써야함.
  var data: AlarmModel?
  /// 읽음 유무: (Y: 읽음, N: 읽지 않음)
  var read_yn: String?
  /// 삭제 유무: (Y: 삭제, N: 정상)
  var del_yn: String?
  /// 알림 등록일
  var ins_date: String?
  /// 알림 수정일
  var upd_date: String?
  /// 모든 푸시 알림 상태: (Y: 수신, N: 수신거부)
  var all_alarm_yn: String?
  /// 이벤트 푸시 알림 상태: (Y: 수신, N: 수신거부)
  var event_alarm_yn: String?
  /// 공지사항 푸시 알림 상태: (Y: 수신, N: 수신거부)
  var notice_alarm_yn: String?
  /// 이메일 푸시 알림 상태: (Y: 수신, N: 수신거부)
  var email_alarm_yn: String?
  /// 새로운 알림 카운트
  var new_alarm_conut: String?
  var new_memo_conut: String?
  var title: String?
  /// 알림 리스트
  var data_array: [AlarmModel]?
  
  override func mapping(map: Map) {
    super.mapping(map: map)
    self.alarm_idx <- map["alarm_idx"]
    self.msg <- map["msg"]
    self.data <- map["data"]
    self.read_yn <- map["read_yn"]
    self.del_yn <- map["del_yn"]
    self.ins_date <- map["ins_date"]
    self.upd_date <- map["upd_date"]
    self.all_alarm_yn <- map["all_alarm_yn"]
    self.event_alarm_yn <- map["event_alarm_yn"]
    self.notice_alarm_yn <- map["notice_alarm_yn"]
    self.email_alarm_yn <- map["email_alarm_yn"]
    self.new_alarm_conut <- map["new_alarm_conut"]
    self.new_memo_conut <- map["new_memo_conut"]
    self.title <- map["title"]
    self.data_array <- map["data_array"]
  }
}
