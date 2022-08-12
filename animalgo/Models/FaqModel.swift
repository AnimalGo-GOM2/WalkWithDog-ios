//
//  FaqModel.swift
//  animalgo
//
//  Created by rocket on 10/06/2019.
//  Copyright © 2019 rocateer. All rights reserved.
//

import Foundation
import ObjectMapper

class FaqModel: BaseListModel {
  /// FAQ 카테고리 키
  var faq_category_idx: String?
  /// FAQ 카테고리 제목
  var faq_category_name: String?
  /// FAQ 인덱스
  var faq_idx: String?
  /// FAQ 제목
  var title: String?
  /// FAQ 내용
  var contents: String?
  /// 이미지
  var img: String?
  /// faq 타입
  var faq_type: String?
  /// FAQ 리스트 또는 FAQ 카테고리 리스트
  var data_array: [FaqModel]?
  
  
  override func mapping(map: Map) {
    super.mapping(map: map)
    self.faq_category_idx <- map["faq_category_idx"]
    self.faq_category_name <- map["faq_category_name"]
    self.faq_idx <- map["faq_idx"]
    self.title <- map["title"]
    self.contents <- map["contents"]
    self.img <- map["img"]
    self.faq_type <- map["faq_type"]
    self.data_array <- map["data_array"]
  }
}
