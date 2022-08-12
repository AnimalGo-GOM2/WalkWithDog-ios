//
//  BannerModel.swift
//  animalgo
//
//  Created by rocket on 10/06/2019.
//  Copyright © 2019 rocateer. All rights reserved.
//

import Foundation
import ObjectMapper

class BannerModel: BaseListModel {
  /// 배너 인덱스
  var banner_idx: String?
  /// 배너 제목
  var title: String?
  /// 배너 이미지 URL
  var img_url: String?
  /// 배너 링크
  var link_url: String?
  
  override func mapping(map: Map) {
    super.mapping(map: map)
    self.banner_idx <- map["banner_idx"]
    self.title <- map["title"]
    self.img_url <- map["img_url"]
    self.link_url <- map["link_url"]
  }
}
