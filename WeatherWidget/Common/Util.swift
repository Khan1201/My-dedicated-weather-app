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
        skyState: String
    ) -> String {
        if rainState != "0" {
            return remakeRainStateForWeatherImage(rainState)
            
        } else {
            return remakeSkyStateForWeatherImage(skyState)
        }
    }
    
    /**
     초단기예보 or 단기예보의 강수량 값 -> 날씨 image
     
     - parameter value: 예보 조회 response 강수 값
     */
    public static func remakeRainStateForWeatherImage(
        _ value: String
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
        _ value: String
    ) -> String {
        
        switch value {
        case "1":
            return "weather_sunny"
            
        case "3":
            return "weather_cloud_many"
            
        case "4":
            return "weather_blur"
            
        default:
            return "load_fail"
        }
    }
}
