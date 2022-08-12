//
//  GeoModel.swift
//  animalgo
//
//  Created by rocateer on 2021/12/01.
//  Copyright © 2021 rocateer. All rights reserved.
//


import Foundation
import ObjectMapper

class GeoModel: BaseListModel {
 
  var name: String?
  var message: String?

  
  var status: GeoModel?
  var region: GeoModel?
  var area1: GeoModel?
  var area2: GeoModel?
  var area3: GeoModel?
  var coords: GeoModel?
  var land: GeoModel?
  
  var results: [GeoModel]?
  
  
  override func mapping(map: Map) {
    super.mapping(map: map)
    self.name <- map["name"]
    self.message <- map["message"]

    
    self.status <- map["status"]
    self.region <- map["region"]
    self.area1 <- map["area1"]
    self.area2 <- map["area2"]
    self.area3 <- map["area3"]
    self.coords <- map["coords"]
    self.results <- map["results"]
    self.land <- map["land"]

  }
}
