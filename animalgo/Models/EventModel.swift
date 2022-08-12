//
//  EventModel.swift
//  animalgo
//  이벤트와 앱 시작시 팝업 보기에서 같이 사용한다.
//  Created by rocket on 10/06/2019.
//  Copyright © 2019 rocateer. All rights reserved.
//

import Foundation
import ObjectMapper

class EventModel: BaseListModel {
  /// 이벤트 인덱스
  var event_idx: String?
  /// 이벤트 제목
  var title: String?
  /// 이벤트 내용
  var contents: String?
  /// 이벤트 이미지 URL
  var img_url: String?
  /// 이벤트 이미지 가로 길이
  var img_width: Int?
  /// 이벤트 이미지 세로 길이
  var img_height: Int?
  /// 이벤트 링크
  var link_url: String?
  /// 이벤트 이미지 URL
  var img_path: String?
  /// 날짜
  var ins_date: String?
  /// 이벤트 리스트
  var data_array: [EventModel]?
  
  override func mapping(map: Map) {
    super.mapping(map: map)
    self.event_idx <- map["event_idx"]
    self.title <- map["title"]
    self.contents <- map["contents"]
    self.img_url <- map["img_url"]
    self.img_width <- map["img_width"]
    self.img_height <- map["img_height"]
    self.link_url <- map["link_url"]
    self.img_path <- map["img_path"]
    self.ins_date <- map["ins_date"]
    self.data_array <- map["data_array"]
  }
}
