//
//  Util.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/04/30.
//

import Foundation

struct Util {
    
    //MARK: - For Mid Term Forecast.. (중기 예보)
    
    func midTermForecastRequestDate() -> String {
        
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
        let yesterdayDate1800ToString = dateToStringByAddingDay(
            currentDate: currentDate,
            day: -1,
            dateFormat: "yyyyMMddHHmm"
        )
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
    
    func dateToStringByAddingDay(currentDate: Date, day: Int, dateFormat: String) -> String {
        
        let calender: Calendar = Calendar.current
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        let dateComponent: DateComponents = DateComponents(day: day)
        
        let yesterdayDate: Date = calender.date(byAdding: dateComponent, to: currentDate) ?? Date()
        let yesterdayDateToString = dateFormatter.string(from: yesterdayDate)
        return yesterdayDateToString
    }
    
    // MARK: - For Very Short or Short Term Forecast.. (초 단기 예보, 단기 예보)
    
    func veryShortTermForecastCategoryValue(category: VeryShortTermForecastCategory, value: String) -> (String, String) {
        
        switch category {
            
        case .T1H: // 기온
            return ("\(value)°", "")
            
        case .RN1: // 1시간 강수량
            return (remakeOneHourPrecipitationValue(value: value), "")
            
        case .PTY: // 강수 형태
            return remakePrecipitaionTypeValue(value: value)
            
        case .SKY: // 하늘 상태
            return remakeSkyStateValue(value: value)
            
        case .REH: // 습도
            return ("\(value)%", "")
            
        case .WSD: // 풍속
            return (remakeWindSpeedValue(value: value), "")
        }
    }
    
    func shortTermForecastCategoryValue(category: ShortTermForecastCategory, value: String) -> (String, String) {
        
        switch category {
            
        case .POP: // 강수 확률
            return ("\(value)%", "")
            
        case .PTY: // 강수 형태
            return remakePrecipitaionTypeValue(value: value)
            
        case .PCP: // 1시간 강수량
            return (remakeOneHourPrecipitationValue(value: value), "")
            
        case .REH: // 습도
            return ("\(value)%", "")
            
        case .SKY: // 하늘 상태
            return remakeSkyStateValue(value: value)
            
        case .TMP: // 1시간 기온
            return ("\(value)°", "")
            
        case .TMN: // 일 최저기온
            return ("\(value)°", "")
            
        case .TMX: // 일 최고기온
            return ("\(value)°", "")
            
        case .WSD: // 풍속
            return (remakeWindSpeedValue(value: value), "")
        }
    }
    
    func remakeOneHourPrecipitationValue(value: String) -> String {
        
        if value == "강수없음" {
            return "비 없음"
            
        } else if value == "30.0~50.0mm" || value == "50.0mm 이상" {
            return "매우 강한 비"
            
        } else {
            
            let stringToDouble: Double = Double(value.replacingOccurrences(of: "mm", with: "")) ?? 0
            switch stringToDouble {
                
            case 1.0...2.9:
                return "약한 비"
            case 3.0...14.9:
                return "보통 비"
            case 15.0...29.9:
                return "강한 비"
            default:
                return "알 수 없음"
            }
        }
    }
    
    func remakePrecipitaionTypeValue(value: String) -> (String, String) {
        
        switch value {
            
        case "0":
            return ("없음", "")
        case "1":
            return ("비", "weather_rain")
        case "2":
            return ("비/눈", "weather_rain_snow")
        case "3":
            return ("눈", "weather_snow")
        case "5":
            return ("빗방울", "weather_rain_small")
        case "6":
            return ("빗방울 / 눈날림", "")
        default:
            return ("알 수 없음", "")
        }
    }
    
    func remakeSkyStateValue(value: String) -> (String, String) {
        
        switch value {
        case "1":
            return ("맑음", "weather_sunny")
        case "3":
            return ("구름많음", "weather_cloud_many")
        case "4":
            return ("흐림", "weather_blur")
        default:
            return ("알 수 없음", "")
        }
    }
    
    func remakeWindSpeedValue(value: String) -> String {
        
        let stringToDouble = Double(value) ?? 0.0
        
        switch stringToDouble {
        case 0.0...3.9:
            return "약한 바람"
        case 4.0...8.9:
            return "약간 강한 바람"
        case 9.0...13.9:
            return "강한 바람"
        case _ where stringToDouble > 13.9:
            return "매우 강한 바람"
            
        default:
            return "알 수 없음"
        }
    }
    
    func shortTermForecastBaseTime() -> String {
                
        let dateFormatterYearMonthDay = DateFormatter()
        dateFormatterYearMonthDay.dateFormat = "yyyyMMdd"
        
        let dateFormatterHourMinute = DateFormatter()
        dateFormatterHourMinute.dateFormat = "HHmm"
        
        let todayDate: Date = Date()
        
        let yesterdayYearMonthDay: String = dateToStringByAddingDay(currentDate: todayDate, day: -1, dateFormat: "yyyyMMdd")
        let currentYearMonthDay: String = dateFormatterYearMonthDay.string(from: todayDate)
        let currentHourMinute: Int = Int(dateFormatterHourMinute.string(from: todayDate)) ?? 0
        
        switch currentHourMinute {
            
        case 0000...0159:
            return yesterdayYearMonthDay + "2300"
        case 0200...0459:
            return currentYearMonthDay + "0200"
        case 0500...0759:
            return currentYearMonthDay + "0500"
        case 0800...1059:
            return currentYearMonthDay + "0800"
        case 1100...1359:
            return currentYearMonthDay + "1100"
        case 1400...1659:
            return currentYearMonthDay + "1400"
        case 1700...1959:
            return currentYearMonthDay + "1700"
        case 2000...2259:
            return currentYearMonthDay + "2000"
        case 2300...2359:
            return currentYearMonthDay + "2300"
            
        default:
            return "알 수 없음"
        }
    }
    
    //MARK: -
}




