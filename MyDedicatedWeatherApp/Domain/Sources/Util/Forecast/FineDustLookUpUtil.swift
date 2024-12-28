//
//  FineDustLookUpUtil.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/08/04.
//

import Foundation

public struct FineDustLookUpUtil {
    
    public init() {}
    
    /**
     미세먼지 api response value 값 -> UI 보여질 값으로 remake
     
     - parameter value: 미세먼지 값
     */
    public func convertFineDust(rawValue: String) -> WeatherAPIValue { // 미세먼지
        return FineDustStateConverter.convert(rawValue: rawValue)
    }
    
    /**
     초 미세먼지 api response value 값 -> UI 보여질 값으로 remake
     
     - parameter value: 초미세먼지 값
     */
    public func convertUltraFineDust(rawValue: String) -> WeatherAPIValue { // 초 미세먼지
        return UltraFineDustStateConverter.convert(rawValue: rawValue)
    }
}
