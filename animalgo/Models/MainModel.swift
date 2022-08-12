//
//  MainModel.swift
//  animalgo
//
//  Created by rocateer on 2021/12/01.
//  Copyright © 2021 rocateer. All rights reserved.
//

import Foundation
import ObjectMapper

class MainModel: BaseListModel {
  /// 회원 위도
  var member_lat: String?
  /// 회원 경도
  var member_lng: String?
  /// 회원 이미지
  var member_img: String?
  /// 회원 닉네임
  var member_nickname: String?
  /// 별점
  var review_star: String?
  /// 반려동물 키
  var animal_idx: String?
  /// 반려동물 이미지
  var animal_img_path: String?
  /// 이미지
  var img_path: String?
  /// 산책 키
  var record_idx: String?
  /// 회원 나이대
  var member_age: String?
  /// 회원성별 (0: 남자 , 1: 여자)
  var member_gender: String?
  /// 산책 일시
  var record_date: String?
  /// 산책 위치
  var record_addr: String?
  /// 산책 장소 위도
  var record_lat: String?
  /// 산책 장소 경도
  var record_lng: String?
  /// 산책장소까지의 거리(km)
  var distant: String?
  /// 반려건 키(마릿수)
  var member_animal_idxs: String?
  /// 반려견 이름
  var animal_name: String?
  /// 반려견 성별 (0: 남자 , 1: 여자)
  var animal_gender: String?
  var animal_year: String?
  var animal_character: String?
  var animal_neuter: String?
  var animal_training: String?
  /// 이동 경로
  var target: String?
  /// 집계 기간 시작
  var record_king_start_date: String?
  /// 집계 기간 끝
  var record_king_end_date: String?
  /// 견종
  var category_name: String?
  /// 산책 수
  var record_cnt: String?
  /// 회사 정보 이미지
  var company_info: String?
  var link_url: String?
  
  var recommend_obj: MainModel?
  var animal_obj: MainModel?
  
  var data_array: [MainModel]?
  var compliment_array: [MainModel]?
  var banner_array: [MainModel]?
  var rank_array: [MainModel]?
  var my_animal_array: [MainModel]?
  var animal_array: [MainModel]?
  
  override func mapping(map: Map) {
    super.mapping(map: map)
    self.member_lat <- map["member_lat"]
    self.member_lng <- map["member_lng"]
    self.member_img <- map["member_img"]
    self.member_nickname <- map["member_nickname"]
    self.review_star <- map["review_star"]
    self.animal_idx <- map["animal_idx"]
    self.animal_img_path <- map["animal_img_path"]
    self.img_path <- map["img_path"]
    self.record_idx <- map["record_idx"]
    self.member_age <- map["member_age"]
    self.member_gender <- map["member_gender"]
    self.record_date <- map["record_date"]
    self.record_addr <- map["record_addr"]
    self.record_lat <- map["record_lat"]
    self.record_lng <- map["record_lng"]
    self.distant <- map["distant"]
    self.member_animal_idxs <- map["member_animal_idxs"]
    self.animal_name <- map["animal_name"]
    self.animal_gender <- map["animal_gender"]
    self.animal_year <- map["animal_year"]
    self.animal_character <- map["animal_character"]
    self.animal_neuter <- map["animal_neuter"]
    self.animal_training <- map["animal_training"]
    self.target <- map["target"]
    self.record_king_start_date <- map["record_king_start_date"]
    self.record_king_end_date <- map["record_king_end_date"]
    self.category_name <- map["category_name"]
    self.animal_obj <- map["animal_obj"]
    self.record_cnt <- map["record_cnt"]
    self.company_info <- map["company_info"]
    self.link_url <- map["link_url"]
    
    self.data_array <- map["data_array"]
    self.compliment_array <- map["compliment_array"]
    self.recommend_obj <- map["recommend_obj"]
    self.banner_array <- map["banner_array"]
    self.rank_array <- map["rank_array"]
    self.my_animal_array <- map["my_animal_array"]
    self.animal_array <- map["animal_array"]
    
  }
}
