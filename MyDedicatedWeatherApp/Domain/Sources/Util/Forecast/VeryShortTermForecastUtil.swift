//
//  VeryShortTermForecastUtil.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/08/04.
//

import Foundation

public protocol VeryShortForecastRequestParam {
    var requestBaseTime: String { get }
    var requestBaseDate: String { get }
}

public struct VeryShortTermForecastUtil: VeryShortForecastRequestParam {
    
    public init() {}
    
    /**
     Return 현재시간 -> baseTime (초단기예보 Requst 타입)
     */
    public var requestBaseTime: String {
        let currentDate: Date = Date()
        let currentHour: String = currentDate.toString(format: "HH")
        let currentMinute: String = currentDate.toString(format: "mm")
        let currentMinuteToInt: Int = Int(currentMinute) ?? 0
        
        if currentMinuteToInt < 30 {
            if currentHour == "00" {
                return "2330"
                
            } else {
                let currentHourToInt = Int(currentHour) ?? 0
                let currentHourMinusOneHour = currentHourToInt - 1
                var toString = String(currentHourMinusOneHour)
                
                if toString.count == 1 {
                    toString.insert("0", at: toString.startIndex)
                }
                
                return toString + "30"
            }
            
        } else { // currentMinute >= 30
            return currentHour + "30"
        }
    }
    
    
    /**
     초단기예보 Reqeust baseTime(시간)에 따른 baseDate(날짜) 설정
     */
    public var requestBaseDate: String {
        let currentDate = Date()
        let currentHHmm = currentDate.toString(format: "HHmm").toInt
        
        return currentDate.toString(
            byAdding: currentHHmm < 0030 ? -1 : 0,
            format: "yyyyMMdd"
        )
    }
}
