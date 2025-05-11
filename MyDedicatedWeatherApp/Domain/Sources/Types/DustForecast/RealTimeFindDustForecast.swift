//
//  RealTimeFindDustForecast.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/05/14.
//

import Foundation

public struct RealTimeFindDustForecast: Decodable {
    public init(pm10Value: String, pm25Value: String) {
        self.pm10Value = pm10Value
        self.pm25Value = pm25Value
    }
    
    public let pm10Value: String
    public let pm25Value: String
}
