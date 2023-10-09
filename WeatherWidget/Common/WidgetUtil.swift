//
//  Util.swift
//  WeatherWidgetExtension
//
//  Created by 윤형석 on 2023/10/06.
//

import Foundation

struct Util {
    /**
     초단기예보 or 단기예보의 바람속도 값 -> (약한 바람, 3.5m/s)
     
     - parameter value: 예보 조회 response 바람속도 값
     */
    public static func remakeWindSpeedValueForToString(value: String) -> (String, String) {
        
        let stringToDouble = Double(value) ?? 0.0
        
        switch stringToDouble {
            
        case 0.0...3.9:
            return ("약한 바람", "\(value)m/s")
            
        case 4.0...8.9:
            return ("약간 강한 바람", "\(value)m/s")
            
        case 9.0...13.9:
            return ("강한 바람", "\(value)m/s")
            
        case _ where stringToDouble > 13.9:
            
            return ("매우 강한 바람", "\(value)m/s")
            
        default:
            return ("알 수 없음", "")
        }
    }
    
    /**
     초단기예보 or 단기예보의 1시간 강수량 값 -> (약한 비, 1.5)
     
     - parameter value: 예보 조회 response 1시간 강수량 값
     */
    public static func remakePrecipitationValueForToString(value: String) -> (String, String) {
        
        if value == "강수없음" {
            return ("비 없음", "")
            
        } else if value == "30.0~50.0mm" || value == "50.0mm 이상" {
            return ("매우 강한 비", "30mm 이상")
            
        } else {
            let stringToDouble: Double = Double(value.replacingOccurrences(of: "mm", with: "")) ?? 0
            
            switch stringToDouble {
                
            case 1.0...2.9:
                return ("약한 비", value)
                
            case 3.0...14.9:
                return ("보통 비", value)
                
            case 15.0...29.9:
                return ("강한 비", value)
                
            default:
                return ("알 수 없음", "")
            }
        }
    }
    
    /**
     초단기예보 or 단기예보의 비 상태 값, 하늘 상태 값 -> 날씨 image
     
     - parameter rainState: 예보 조회 response의 비 상태 값
     - parameter skyState: 예보 조회 response의 하늘 상태 값
     */
    public static func remakeRainStateAndSkyStateForWeatherImage(
        rainState: String,
        skyState: String,
        hhMM: String,
        sunrise: String,
        sunset: String
    ) -> String {
        if rainState != "0" {
            return remakeRainStateForWeatherImage(rainState, hhMM: hhMM, sunrise: sunrise, sunset: sunset)
            
        } else {
            return remakeSkyStateForWeatherImage(skyState, hhMM: hhMM, sunrise: sunrise, sunset: sunset)
        }
    }
    
    /**
     초단기예보 or 단기예보의 강수량 값 -> 날씨 image
     
     - parameter value: 예보 조회 response 강수 값
     */
    public static func remakeRainStateForWeatherImage(
        _ value: String,
        hhMM: String,
        sunrise: String,
        sunset: String
    ) -> String {
        
        switch value {
            
        case "0":
            return "load_fail"
            
        case "1":
            return "weather_rain"
            
        case "2":
            return "weather_rain_snow"
            
        case "3":
            return "weather_snow"
            
        case "4":
            return "weather_rain_small"
            
        case "5":
            return "weather_rain_small"
            
        case "6":
            return "weather_rain_snow"
            
        default:
            return "load_fail"
        }
    }
    
    /**
     초단기예보 or 단기예보의 하늘상태  값 -> 날씨 imge
     
     - parameter value: 예보 조회 response 하늘상태 값,
     */
    public static func remakeSkyStateForWeatherImage(
        _ value: String,
        hhMM: String,
        sunrise: String,
        sunset: String
    ) -> String {
        
        switch value {
        case "1":
            return isDayMode(targetHHmm: hhMM, sunrise: sunrise, sunset: sunset) ? "weather_sunny" : "weather_sunny_night"
            
        case "3":
            return isDayMode(targetHHmm: hhMM, sunrise: sunrise, sunset: sunset) ? "weather_cloud_many" : "weather_cloud_many_night"
            
        case "4":
            return "weather_blur"
            
        default:
            return "load_fail"
        }
    }
    
    /**
    타겟 시간과 일출, 일몰 시간을 비교 -> return day or night (`Bool`)
     */
    
    public static func isDayMode(targetHHmm: String, sunrise: String, sunset: String) -> Bool {
        let targetHHmmToInt = Int(targetHHmm) ?? 0
        let sunriseToInt = Int(sunrise) ?? 0
        let sunsetToInt = Int(sunset) ?? 0
        
        if targetHHmmToInt > sunriseToInt && targetHHmmToInt < sunsetToInt {
            return true
            
        } else  {
            return false
        }
    }
    
    /**
     미세먼지 api response value 값 ->  값 String (`String`)
     
     - parameter value: api response 미세먼지 값
     */
    public static func remakeFindDustValue(value: String) -> String { // 미세먼지
        
        let valueToInt: Int = Int(value) ?? 0
        
        switch valueToInt {
            
        case 0...30:
            return "좋음"
        case 31...81:
            return "보통"
        case 81...150:
            return "나쁨"
        case _ where valueToInt >= 151:
            return "매우 나쁨"
        default:
            return "알 수 없음"
        }
    }
    
    /**
     초 미세먼지 api response value 값 ->  값 String (`String`)

     - parameter value: api response 초미세먼지 값
     */
    public static func remakeUltraFindDustValue(value: String) -> String { // 초 미세먼지
        
        let valueToInt: Int = Int(value) ?? 0
        
        switch valueToInt {
            
        case 0...15:
            return "좋음"
        case 16...35:
            return "보통"
        case 36...75:
            return "나쁨"
        case _ where valueToInt >= 76:
            return "매우 나쁨"
        default:
            return "알 수 없음"
        }
    }
    
    public static func printError(funcTitle: String, description: String, value: Any? = nil, values: [Any]? = nil) {
        print("""
        ***********************************************************
        ⚠️ Error
        -----------------------------------------------------------
        ●Function Name: \(funcTitle)
        -----------------------------------------------------------
        ●Description:
        \(description)
        -----------------------------------------------------------
        ●Value(s):
          → Value: \(value ?? "")
          → Values: \(values ?? [])
        ***********************************************************
        """)
    }
    
    public static func printSuccess(funcTitle: String, value: Any? = nil, values: [Any]? = nil) {
        print("""
        ***********************************************************
        👍 Success
        -----------------------------------------------------------
        ●Function Name: \(funcTitle)
        -----------------------------------------------------------
        ●Value(s):
          → Value: \(value ?? "")
          → Values: \(values ?? [])
        ***********************************************************
        """)
    }
    
    /**
     ex) 현재시각 AM 10시
     1000 -> 10:00 변환
     
     - parameter HHmm: hour minute (HHmm) String
     */
    public static func convertHHmmToHHColonmm(HHmm: String) -> String {
        
        let lastIndex = HHmm.index(before: HHmm.endIndex)
        
        let hourIndex = HHmm.index(HHmm.startIndex, offsetBy: 1)
        let hour = HHmm[HHmm.startIndex...hourIndex]
        
        let minuteIndex = HHmm.index(HHmm.startIndex, offsetBy: 2)
        let minute = HHmm[minuteIndex...lastIndex]
        
        return hour + ":" + minute
    }
    
    /**
     Return AM or PM by 현재시간
     
     - parameter HH: Hour
     */
    public static func convertAMOrPMFromHHmm(_ HHmm: String) -> String {
        
        let hourEndIndex = HHmm.index(
            HHmm.startIndex, offsetBy: 1
        )
        let hour = String(HHmm[...hourEndIndex])
        let hourToInt = Int(hour) ?? 0
        
        if hourToInt - 12 > 0 {
            return "\(hourToInt - 12)PM"
            
        } else if hourToInt == 12 {
            return "12PM"
            
        } else if hourToInt == 00 {
            return "12AM"
            
        } else {
            
            if hourToInt < 10 { // 2 digit -> 1digit (remove 0)
                return "\(String(hourToInt).last ?? "0")AM"
                
            } else {
                return "\(hourToInt)AM"
            }
        }
    }
}
