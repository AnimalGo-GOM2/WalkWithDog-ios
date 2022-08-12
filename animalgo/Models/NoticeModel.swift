//
//  NoticeModel.swift
//  animalgo
//
//  Created by rocket on 10/06/2019.
//  Copyright © 2019 rocateer. All rights reserved.
//

import Foundation
import ObjectMapper

class NoticeModel: BaseListModel {
  /// 공지사항 인덱스
  var notice_idx: String?
  /// 공지사항 제목
  var title: String?
  /// 공지사항 이미지
  var img_path: String?
  /// 이미지 가로 길이 (px)
  var img_width: Int?
  /// 이미지 세로 길이 (px)
  var img_height: Int?
  /// 공지사항 내용
  var contents: String?
  /// 공지사항 등록일
  var ins_date: String?
  var img: String?
  /// 공지사항 리스트
  var data_array: [NoticeModel]?
  
  
  override func mapping(map: Map) {
    super.mapping(map: map)
    self.notice_idx <- map["notice_idx"]
    self.title <- map["title"]
    self.img_path <- map["img_path"]
    self.img_width <- map["img_width"]
    self.img_height <- map["img_height"]
    self.contents <- map["contents"]
    self.ins_date <- map["ins_date"]
    self.img <- map["img"]
    self.data_array <- map["data_array"]
  }
}
