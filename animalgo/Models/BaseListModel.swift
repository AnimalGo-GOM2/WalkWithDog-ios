//
//  ListModel.swift
//  animalgo
//
//  Created by rocket on 10/06/2019.
//  Copyright © 2019 rocateer. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseListModel: BaseModel {
  /// 현재 페이지 번호
  var page_num: Int?
  /// 리스트 갯수
  var list_cnt: Int?
  /// 총 페이지 수
  var total_page: Int?
  /// 총 아이템 갯수
  var total_cnt: Int?
  
  
  override func mapping(map: Map) {
    super.mapping(map: map)
    self.page_num <- map["page_num"]
    self.list_cnt <- map["list_cnt"]
    self.total_page <- map["total_page"]
    self.total_cnt <- map["total_cnt"]
  }
  
  /// 다음 페이지 넘버 받아오는 함수
  /// : 페이지 넘버가 없을 경우에는 1로 시작한다.
  /// - Parameter pageNum: 현재 페이지 넘버
  func setNextPage() {
    if let page_num = self.page_num {
      self.page_num = page_num + 1
    } else {
      self.page_num = 1
    }
  }
  
  /// 페이징 초기화
  func resetPage() {
    self.page_num = 0
  }
  
  
  /// total Page 세팅
  ///
  /// - Parameter total_page: totalPage
  func setTotalPage(total_page: Int) {
    self.total_page = total_page
  }
  
  
  /// total page 가져오기
  ///
  /// - Returns: total page
  func getTotalPage() -> Int {
    return self.total_page ?? 0
  }
  
  /// 다음 페이지가 있는지 체크
  ///
  /// - Returns: 다음페이지가 있는지 체크
  func isMore() -> Bool {
    if getTotalPage() > (self.page_num ?? 1) {
      return true
    } else {
      return false
    }
  }
  
}

