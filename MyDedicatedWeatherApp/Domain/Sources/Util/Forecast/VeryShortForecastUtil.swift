//
//  VeryShortForecastUtil.swift
//
//
//  Created by 윤형석 on 1/1/25.
//

import Foundation

public struct VeryShortForecastUtil {
    public init() {}
    /**
     바람속도 값 변환
     
     - parameter value: 예보 조회 response 바람속도 값
     */
    public func convertWindSpeed(rawValue: String) -> WeatherAPIValue {
        return WindSpeedConverter.convert(rawValue: rawValue)
    }
}
