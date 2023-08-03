//
//  VeryShortTermForecastUtil.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/08/04.
//

import Foundation

struct VeryShortTermForecastUtil {
    
    /**
     Return 현재시간 -> baseTime (초단기예보 Requst 타입)
     
     */
    func requestBaseTime() -> String {
        
        let dateFormatterHour: DateFormatter = DateFormatter()
        dateFormatterHour.dateFormat = "HH"
        
        let dateFormatterMinute: DateFormatter = DateFormatter()
        dateFormatterMinute.dateFormat = "mm"
        
        let currentDay: Date = Date()
        
        let currentHour: String = dateFormatterHour.string(from: currentDay)
        let currentMinute: Int = Int(dateFormatterMinute.string(from: currentDay)) ?? 0
        
        if currentMinute < 30 {
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
     
     - parameter baseTime: '단기예보 request 시간'
     */
    func requestBaseDate(baseTime: String) -> String {
        
        return Date().toString(
            byAdding: baseTime == "2330" ? -1 : 0,
            format: "yyyyMMdd"
        )
    }
}
