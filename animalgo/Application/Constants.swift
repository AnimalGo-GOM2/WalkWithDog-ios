//
//  Constant.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/04.
//  Copyright © 2021 rocateer. All rights reserved.
//

import Foundation


var QNA_CATEGORY_LIST = ["회원서비스", "산책하기", "산책기록", "앱사용", "기타"]

// 산책 트래킹 알림 (나와 반려견만 산책)
var TRACKING_PUSH_TEXT = ["산책 시에는 \"애니멀고 산책\"으로 추억을 계속 남겨주세요.", "반려견과 사진도 남겨 좋은 추억을 만들어 보세요.", "산책친구 완료 시 후기 잊지 말고 남겨주세요.", "배변활동시 배변봉투로 뒤처리 꼭 잊지 마세요!", "산책 후 발바닥을 깨끗이 닦아주세요!", "잠깐의 휴식 시간을 가져 충분한 휴식을 취해주세요.", "산책 시 주변 반려견과 인사해보는 건 어떨까요?", "다음 산책 시에는 산책친구와 같이 해보세요!", "산책 시 마실 물과 간식은 챙기셨나요?", "기본적인 산책 에티켓을 지켜주세요."]

// 산책 트래킹 알림 (산책친구와 함께)
var TRACKING_PUSH_TEXT_WITH_FRIEND = ["반려견들은 서로 잘 어울려서 놀고 있나요?", "서로 사진도 남겨 좋은 추억을 만들어 보세요.", "산책친구 완료 시 후기 잊지말고 남겨주세요.", "다음 산책 약속도 잡아보세요.", "산책 후 발바닥을 깨끗이 닦아주세요!", "잠깐의 휴식시간을 가져보는 건 어떠신가요?", "자주가는 산책코스도 서로 공유해보세요.", "상대 견주분과 유익한 정보들을 나눠보세요.", "우리 아이의 일상 사진첩을 서로 공유해보세요.", "산책이 끝나고 서로 일상얘기도 나눠보세요."]



// 반려견 특징(성격(0:온순, 1:입질, 2:호기심많음,3:활동적))
func characterString(animal_character: String) -> String {
  if animal_character == "0" {
    return "온순"
  } else if animal_character == "1" {
    return "입질"
  } else if animal_character == "2" {
    return "호기심많음"
  } else if animal_character == "3" {
    return "활동적"
  }
  
  return ""
}



/// 나이계산
/// - Parameter birth: 생년월
/// - Returns: 나이
func calculateAge(birth: String) -> String {
  let birth = birth.components(separatedBy: "-")
  guard birth.count > 0 else { return "" } // 정상적인 생년월 형식(yyyy-MM)이 아닌 경우
  
  let birthYear = Int(birth[0]) ?? 0
  let year = Int(Date().toString(format: "yyyy")) ?? 0
  return "\(year - birthYear + 1)"
}
