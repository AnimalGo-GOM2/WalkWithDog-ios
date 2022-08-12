//
//  QnaModel.swift
//  animalgo
//
//  Created by rocket on 10/06/2019.
//  Copyright © 2019 rocateer. All rights reserved.
//

import Foundation
import ObjectMapper

class QnaModel: BaseListModel {
  /// QNA 인덱스
  var qa_idx: String?
  /// QNA 질문 제목
  var qa_title: String?
  /// QNA 질문 내용
  var qa_contents: String?
  /// QNA 답변 유무: (Y: 답변 있음, N: 답변 없음)
  var reply_yn: String?
  /// QNA 답변 내용
  var reply_contents: String?
  /// QNA 답변일
  var reply_date: String?
  /// QNA 등록일
  var ins_date: String?
  /// QNA 리스트
  var data_array: [QnaModel]?
  /// 분류(0:문의, 1:의견)
  var qa_type: String?
  /// 구분(문의 :: 0:회원가입, 1:앱 사용, 2:산책등록, 3:산책기록, 4:기타)(의견 :: 10:지금도좋아요, 11:새로운기능이필요해요, 12:개선이필요해요)
  var qa_category: String?
  
  override func mapping(map: Map) {
    super.mapping(map: map)
    self.qa_idx <- map["qa_idx"]
    self.qa_title <- map["qa_title"]
    self.qa_contents <- map["qa_contents"]
    self.reply_yn <- map["reply_yn"]
    self.reply_contents <- map["reply_contents"]
    self.reply_date <- map["reply_date"]
    self.ins_date <- map["ins_date"]
    self.data_array <- map["data_array"]
    self.qa_type <- map["qa_type"]
    self.qa_category <- map["qa_category"]
  }
}
