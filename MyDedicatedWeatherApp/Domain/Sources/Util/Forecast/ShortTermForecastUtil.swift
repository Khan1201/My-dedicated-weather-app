//
//  ShortTermForecastUtil.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/08/04.
//

import Foundation

public struct ShortTermForecastUtil {
    
    public init() {
        
    }
 
    /**
     Return 현재시간 -> baseTime (단기예보 Requst 타입)
     
     */
    public var baseTimePar: String {
        
        let dateFormatterHourMinute = DateFormatter()
        dateFormatterHourMinute.dateFormat = "HHmm"
        
        let todayDate: Date = Date()
        let currentHourMinute: Int = Int(dateFormatterHourMinute.string(from: todayDate)) ?? 0
        
        switch currentHourMinute {
            
        case 0000...0159:
            return "2300"
            
        case 0200...0459:
            return "0200"
            
        case 0500...0759:
            return "0500"
            
        case 0800...1059:
            return "0800"
            
        case 1100...1359:
            return "1100"
            
        case 1400...1659:
            return "1400"
            
        case 1700...1959:
            return "1700"
            
        case 2000...2259:
            return "2000"
            
        case 2300...2359:
            return "2300"
            
        default:
            return "알 수 없음"
        }
    }
    
    public var baseDatePar: String {
        
        let currentDate: Date = Date()
        let currentYearMonthDay = currentDate.toString(format: "yyyyMMdd")
        let currentHour = currentDate.toString(format: "HH")
        
        let currentYearMonthDayToInt = Int(currentYearMonthDay) ?? 0
        let currentHourToInt = Int(currentHour) ?? 0
        
        switch currentHourToInt {
            
        case 00...01:
            return String(currentYearMonthDayToInt - 1)
        default:
            return currentYearMonthDay
        }
    }
    
    public var baseTimeForTodayMinMaxReq: String {
        let currentHHmm = Date().toString(format: "HHmm").toInt
        
        if currentHHmm >= 0200 {
            return "0200"
            
        } else {
            return "2300"
        }
    }
    
    public var baseDateForTodayMinMaxReq: String {
        let currentDate = Date()
        let currentYyyyMMdd = currentDate.toString(format: "yyyyMMdd").toInt
        let currentHHmm = currentDate.toString(format: "HHmm").toInt
        
        if currentHHmm >= 0200 {
            return currentYyyyMMdd.toString
            
        } else {
            return (currentYyyyMMdd - 1).toString
        }
    }
    
    public var todayWeatherIndexSkipValue: Int {
        let currentHH: Int = Date().toString(format: "HH").toInt
        let allBaseTimeHHs: [Int] = [02, 05, 08, 11, 14, 17, 20, 23]
        
        var result: Int = 0
        
        allBaseTimeHHs.forEach {
           
            // 현재 시각이 01이면, 23 + 1 = 24가 아닌 01로 나와야 하므로
            if $0 == 23 {
                if $0 + 1 == 24 && currentHH == 0 {
                    result += 12

                } else if $0 + 2 == 25 && currentHH == 1 {
                    result += 24
                }
                
            } else {
                if $0 + 1 == currentHH {
                    result += 12

                } else if $0 + 2 == currentHH {
                    result += 24
                }
            }
        }
        
        return result
    }
    
    public var todayWeatherLoopCount: Int {
        let currentHH: Int = Date().toString(format: "HH").toInt
        let allBaseTimeHHs: [Int] = [02, 05, 08, 11, 14, 17, 20, 23]
        
        var result: Int = 24
        
        allBaseTimeHHs.forEach {
            
            // 현재 시각이 01이면, 23 + 1 = 24가 아닌 01로 나와야 하므로
            if $0 == 23 {
                if $0 + 1 == 24 && currentHH == 0 {
                    result = result - 1
                    
                } else if $0 + 2 == 25 && currentHH == 1 {
                    result = result - 2
                }
                
            } else {
                if $0 + 1 == currentHH {
                    result = result - 1
                    
                } else if $0 + 2 == currentHH {
                    result = result - 2
                }
            }
        }
        
        return result
    }
}
