//
//  AnimalModel.swift
//  animalgo
//
//  Created by rocateer on 2021/12/01.
//  Copyright © 2021 rocateer. All rights reserved.
//


import Foundation
import ObjectMapper

class AnimalModel: BaseListModel {
  /// 반려견 키
  var animal_idx: String?
  /// 반려견 이름
  var animal_name: String?
  /// 반려견 이미지
  var animal_img_path: String?
  /// 반려견 성별
  var animal_gender: String?
  /// 생년월 구분자 -
  var animal_year: String?
  /// 성격(0:온순, 1:입질, 2:호기심많음,3:활동적)
  var animal_character: String?
  /// 중성화여부(Y:함, N:안함)
  var animal_neuter: String?
  /// 훈련(Y:훈련,N:안함)
  var animal_training: String?
  /// 건강상태(0:좋아요,1:보통이에요,2:주의가 필요해요)
  var animal_health: String?
  /// 견분류, 견종
  var category_name: String?
  /// 견분류 키(9: 대형견, 12: 중형견, 15: 소형견)
  var first_category_idx: String?
  /// 견종 키
  var second_category_idx: String?
  /// 견분류
  var first_category: String?
  /// 견종
  var second_category: String?
  /// 견분류
  var first_category_name: String?
  /// 견종
  var second_category_name: String?
  /// 카테고리 키
  var category_management_idx: String?
  /// 부모 카테고리 키
  var parent_category_management_idx: String?
  /// 생년월
  var animal_birth: String?
  /// 산책횟수
  var record_cnt: String?
  /// 카테고리 depth ( 1: 견분류, 2 : 견종 )
  var category_depth: String?
  /// 등록일
  var ins_date: String?
  var isSelected: Bool?
  var data_array: [AnimalModel]?

  
  override func mapping(map: Map) {
    super.mapping(map: map)
    
    self.animal_idx <- map["animal_idx"]
    self.animal_img_path <- map["animal_img_path"]
    self.animal_name <- map["animal_name"]
    self.animal_gender <- map["animal_gender"]
    self.animal_year <- map["animal_year"]
    self.animal_character <- map["animal_character"]
    self.animal_neuter <- map["animal_neuter"]
    self.animal_training <- map["animal_training"]
    self.animal_health <- map["animal_health"]
    self.category_name <- map["category_name"]
    self.first_category_idx <- map["first_category_idx"]
    self.second_category_idx <- map["second_category_idx"]
    self.first_category <- map["first_category"]
    self.second_category <- map["second_category"]
    self.first_category_name <- map["first_category_name"]
    self.second_category_name <- map["second_category_name"]
    self.category_management_idx <- map["category_management_idx"]
    self.parent_category_management_idx <- map["parent_category_management_idx"]
    self.animal_birth <- map["animal_birth"]
    self.record_cnt <- map["record_cnt"]
    self.category_depth <- map["category_depth"]
    self.ins_date <- map["ins_date"]
    
    self.data_array <- map["data_array"]

    
  }
}
