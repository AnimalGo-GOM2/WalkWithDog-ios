//
//  KalmanLatLong.swift
//  animalgo
//
//  Created by rocateer on 2021/12/01.
//  Copyright © 2021 rocateer. All rights reserved.
//


import Foundation

class KalmanLatLong {
  
  private final var MinAccuracy: Float = 1
  private var Q_metres_per_second: Float?
  private var TimeStamp_milliseconds: Double?
  private var lat: Double = 0.0
  private var lng: Double = 0.0
  private var variance: Float? // P matrix. Negative means object uninitialised.
  public var consecutiveRejectCount: Int = 0
  
  
  init (Q_metres_per_second: Float) {
    self.Q_metres_per_second = Q_metres_per_second
    self.variance = -1
    self.consecutiveRejectCount = 0
  }
  
  public func get_TimeStamp() -> Double? {
    return self.TimeStamp_milliseconds
  }
  
  public func get_lat() -> Double {
    return self.lat
  }
  
  public func get_lng() -> Double {
    return self.lng
  }
  
  public func get_accuracy() -> Float? {
    return self.variance?.squareRoot()
  }
  
  public func SetState(lat: Double, lng: Double, accuracy: Float, TimeStamp_milliseconds: Double) {
    self.lat = lat
    self.lng = lng
    self.variance = accuracy * accuracy
    self.TimeStamp_milliseconds = TimeStamp_milliseconds
  }
  
  public func Process(lat_measurement: Double, lng_measurement: Double, accuracy: Float, TimeStamp_milliseconds: Double, Q_metres_per_second: Float) {
    self.Q_metres_per_second = Q_metres_per_second
    
    var accu: Float?
    
    // 정확도 측정
    if accuracy < self.MinAccuracy {
      accu = self.MinAccuracy
    } else {
      accu = accuracy
    }
    
    if variance ?? -1 < 0 {
      self.TimeStamp_milliseconds = TimeStamp_milliseconds
      self.lat = lat_measurement
      self.lng = lng_measurement
      self.variance = accu! * accu!
    } else {
      let timeIncMilliseconds: Double = TimeStamp_milliseconds - (self.TimeStamp_milliseconds ?? 0.0)
      
      if timeIncMilliseconds > 0 {
        self.variance! += Float(timeIncMilliseconds) * (self.Q_metres_per_second!) * (self.Q_metres_per_second!) / 1000
      }
      
      let K = self.variance! / (self.variance! * accu! * accu!)
      
      self.lat += Double(K) * (lat_measurement - self.lat)
      self.lng += Double(K) * (lat_measurement - self.lng)
      
      self.variance = (1 - K) * self.variance!
    }
  }
  
  public func getConsecutiveRejectCount() -> Int {
    return self.consecutiveRejectCount
  }
  
  public func setConsecutiveRejectCount(consecutiveRejectCount: Int) {
    self.consecutiveRejectCount = consecutiveRejectCount
  }
  
}
