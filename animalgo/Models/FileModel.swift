//
//  FileModel.swift
//  animalgo
//
//  Created by rocateer on 2020/01/03.
//  Copyright © 2020 rocateer. All rights reserved.
//

import Foundation
import ObjectMapper

class FileModel: BaseModel {
  var file_path: String?
  var img_path: String?
  var img_height: Int?
  var img_width: Int?
  var orig_name: String?
  
  override init() {
    super.init()
  }
  
  required init?(map: Map){
    super.init(map: map)
  }
  
  override func mapping(map: Map) {
    super.mapping(map: map)
    self.file_path <- map["file_path"]
    self.img_path <- map["img_path"]
    self.img_height <- map["img_height"]
    self.img_width <- map["img_width"]
    self.orig_name <- map["orig_name"]
  }
}
