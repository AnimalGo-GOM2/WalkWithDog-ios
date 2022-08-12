//
//  BaseModel.swift
//  animalgo
//
//  Created by rocket on 10/06/2019.
//  Copyright © 2019 rocateer. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseModel: Mappable {
  /// 오류체크 코드
  var code: String?
  /// 오류체크 메세지
  var code_msg: String?
  /// 회원 인덱스
  var member_idx: String?
  /// 디바이스 OS (I): IOS (A): 안드로이드
  var device_os: String?
  /// GCM 키
  var gcm_key: String?
  
  init() {
  }
  
  required init?(map: Map) {
  }
  
  func mapping(map: Map) {
    self.code <- map["code"]
    self.code_msg <- map["code_msg"]
    self.member_idx <- map["member_idx"]
    self.device_os <- map["device_os"]
    self.gcm_key <- map["gcm_key"]
  }
}

