//
//  LocalStore.swift
//  Taiger
//
//  Created by 김성남 on 2018. 3. 26..
//  Copyright © 2018년 ksn. All rights reserved.
//

import UIKit
import Defaults
import CoreLocation

extension Defaults.Keys {
  static let member_idx = Key<String?>("member_idx")
  static let member_join_type = Key<String?>("member_join_type")
  static let member_id = Key<String?>("member_id")
  static let member_pw = Key<String?>("member_pw")
  static let member_nickname = Key<String?>("member_nickname")
  static let bannerDay = Key<Date?>("bannerDay")
  static let tutorial = Key<Bool?>("tutorial") // false 면 tutorial열고, true면 열지 않음
  static let currentLat = Key<Double?>("lat")
  static let currentLng = Key<Double?>("lng")
  static let guide_alarm_yn = Key<String?>("guide_alarm_yn") // 가이드 메시지 알림 여부
  
  //산책 기록
  static let totalLocationList = Key<[String]>("totalLocationList", default: [String]()) // date(yyyy-MM-dd HH:mm:ss), lat, lng
  static let totalDistance = Key<Double?>("totalDistance")
  static let record_idx = Key<String?>("record_idx")
  static let record_type = Key<String?>("record_type") // 산책구분(0:나와반려건,1:산책친구와함께)
  static let member_animal_idxs = Key<String?>("member_animal_idxs")
  static let start_date = Key<Date?>("start_date")
  static let recording_time = Key<Int?>("recording_time")
  static let recording_address = Key<String?>("recording_address")
}
