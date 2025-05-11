//
//  VeryShortOrShortTermForecast.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/05/03.
//

import Foundation

public struct VeryShortOrShortTermForecast<T: Decodable>: Decodable {
    public init(baseDate: String, baseTime: String, category: T, fcstDate: String, fcstTime: String, fcstValue: String) {
        self.baseDate = baseDate
        self.baseTime = baseTime
        self.category = category
        self.fcstDate = fcstDate
        self.fcstTime = fcstTime
        self.fcstValue = fcstValue
    }
    
    public let baseDate: String
    public let baseTime: String
    public let category: T
    public let fcstDate: String
    public let fcstTime: String
    public let fcstValue: String
}
