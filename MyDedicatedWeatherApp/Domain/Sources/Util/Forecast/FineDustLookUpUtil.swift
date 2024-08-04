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
    public func remakeFindDustValue(value: String) -> Weather.DescriptionAndColor { // 미세먼지
        
        let valueToInt: Int = Int(value) ?? 0
        
        switch valueToInt {
            
        case 0...30:
            return Weather.DescriptionAndColor(description: "좋음", color: .blue)
        case 31...81:
            return Weather.DescriptionAndColor(description: "보통", color: .green)
        case 81...150:
            return Weather.DescriptionAndColor(description: "나쁨", color: .orange)
        case _ where valueToInt >= 151:
            return Weather.DescriptionAndColor(description: "매우 나쁨", color: .red)
        default:
            return Weather.DescriptionAndColor(description: "알 수 없음", color: .clear)
        }
    }
    
    /**
     초 미세먼지 api response value 값 -> UI 보여질 값으로 remake
     
     - parameter value: 초미세먼지 값
     */
    public func remakeUltraFindDustValue(value: String) -> Weather.DescriptionAndColor { // 초 미세먼지
        
        let valueToInt: Int = Int(value) ?? 0
        
        switch valueToInt {
            
        case 0...15:
            return Weather.DescriptionAndColor(description: "좋음", color: .blue)
        case 16...35:
            return Weather.DescriptionAndColor(description: "보통", color: .green)
        case 36...75:
            return Weather.DescriptionAndColor(description: "나쁨", color: .orange)
        case _ where valueToInt >= 76:
            return Weather.DescriptionAndColor(description: "매우 나쁨", color: .red)
        default:
            return Weather.DescriptionAndColor(description: "알 수 없음", color: .clear)
        }
    }
}
