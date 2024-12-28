//
//  File.swift
//  
//
//  Created by 윤형석 on 12/28/24.
//

import Foundation
import Domain
import Core

struct ReqParameters {
    static var veryShortForecastBaseTime: String {
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
    
    static var veryShortForecastBaseDate: String {
        let currentDate = Date()
        let currentHHmm = currentDate.toString(format: "HHmm").toInt
        
        return currentDate.toString(
            byAdding: currentHHmm < 0030 ? -1 : 0,
            format: "yyyyMMdd"
        )
    }
    
    static var shortForecastBaseTime: String {
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
    
    static var shortForecastBaseDate: String {
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
    
    static var shortForecastForTodayMinMaxBaseTime: String {
        let currentHHmm = Date().toString(format: "HHmm").toInt
        if currentHHmm >= 0200 {
            return "0200"
            
        } else {
            return "2300"
        }
    }
    
    static var shortForecastForTodayMinMaxBaseDate: String {
        let currentDate = Date()
        let currentYyyyMMdd = currentDate.toString(format: "yyyyMMdd").toInt
        let currentHHmm = currentDate.toString(format: "HHmm").toInt
        
        if currentHHmm >= 0200 {
            return currentYyyyMMdd.toString
            
        } else {
            return (currentYyyyMMdd - 1).toString
        }
    }
    
    static func kakaoHeaderDic(apiKey: String) -> [String: String] {
        return ["Authorization": "KakaoAK \(apiKey)"]
    }
    
    static func midForecastRegId(fullAddress: String, reqType: MidtermReqType) -> String {
        if reqType == .temperature {
            return MidForecastRegionID.temperatureID(fullAddress: fullAddress)
        }
        return MidForecastRegionID.skyStateID(fullAddress: fullAddress)
    }
    
    /// 요청 날짜 (yyyyMMddHHmm 형식)
    static var midForecastTmFcPar: String {
        var result: String = ""
        
        let dateFormatter0600: DateFormatter = DateFormatter()
        dateFormatter0600.dateFormat = "yyyyMMdd0600"
        
        let dateFormatter1800: DateFormatter = DateFormatter()
        dateFormatter1800.dateFormat = "yyyyMMdd1800"
        
        let dateFormatterCurrent: DateFormatter = DateFormatter()
        dateFormatterCurrent.dateFormat = "yyyyMMddHHmm"
        
        let currentDate: Date = Date()
        
        let currentDate0600ToString = dateFormatter0600.string(from: currentDate)
        let currentDate1800ToString = dateFormatter1800.string(from: currentDate)
        let yesterdayDate1800ToString = currentDate.toString(byAdding: -1, format: "yyyyMMdd1800")
        let currentDateToString = dateFormatterCurrent.string(from: currentDate)
        
        
        if currentDateToString < currentDate0600ToString {
            result = yesterdayDate1800ToString
            
        } else if (currentDateToString > currentDate0600ToString) &&
                    (currentDateToString < currentDate1800ToString) {
            result = currentDate0600ToString
            
        } else if (currentDateToString > currentDate0600ToString) &&
                    (currentDateToString > currentDate1800ToString) {
            result = currentDate1800ToString
        }
        
        return result
    }
}

public enum MidtermReqType {
    case temperature, skystate, news
}
