//
//  SkyState.swift
//
//
//  Created by 윤형석 on 11/3/24.
//

import Foundation

public enum SkyState: String, WeatherAPIValue {
    case sunny,
         cloudy,
         blur,
         shower,
         rainDrop,
         rainy,
         rainyAndSnow,
         rainDropAndSnow,
         snow,
         thunder,
         none
    
    public var toDescription: String {
        switch self {
        case .sunny:
            return "맑음"
        case .cloudy:
            return "구름많음"
        case .blur:
            return "흐림"
        case .shower:
            return "소나기"
        case .rainDrop:
            return "빗방울"
        case .rainy:
            return "비"
        case .rainyAndSnow:
            return "비/눈"
        case .rainDropAndSnow:
            return "빗방울 / 눈날림"
        case .snow:
            return "눈"
        case .thunder:
            return "번개"
        case .none:
            return "알 수 없음"
        }
    }
    
    public var backgroundImage: String {
        switch self {
        case .sunny:
            return "background_weather_sunny"
        case .cloudy, .blur, .rainy, .snow, .thunder:
            return "background_weather_blur"
        default:
            return ""
        }
    }
    
    public func image(isDayMode: Bool) -> String {
        switch self {
        case .sunny:
            isDayMode ? "weather_sunny" : "weather_sunny_night"
        case .cloudy:
            isDayMode ? "weather_cloud_many" : "weather_cloud_many_night"
        case .blur:
            "weather_blur"
        case .shower, .rainDrop:
            "weather_rain_small"
        case .rainy:
            "weather_rain"
        case .rainyAndSnow, .rainDropAndSnow:
            "weather_rain_snow"
        case .snow:
            "weather_snow"
        default:
            "load_fail"
        }
    }
    
    public func lottie(isDayMode: Bool) -> String {
        switch self {
        case .sunny:
            isDayMode ? "SunnyLottie" : "SunnyNightLottie"
        case .cloudy:
            isDayMode ? "CloudManyLottie" : "CloudManyNightLottie"
        case .blur:
            "BlurLottie"
        case .rainDrop, .shower:
            isDayMode ? "RainShowerLottie" : "RainShowerNightLottie"        
        case .rainy:
            "RainManyLottie"
        case .rainyAndSnow, .rainDropAndSnow:
            "RainSnowLottie"
        case .snow:
            isDayMode ? "SnowLottie" : "SnowNightLottie"
        default:
            "LoadFailLottie"
        }
    }
    
    public func backgroundLottie(isDayMode: Bool) -> String {
        switch self {
        case .sunny:
            return isDayMode ? "BackgroundSunnyDayLottie" : "BackgroundSunnyNightLottie"
        case .cloudy:
            return "BackgroundCloudyLottie"
        case .rainy:
            return "BackgroundRainyLottie"
        case .snow:
            return "BackgroundSnowLottie"
        default:
            return ""
        }
    }
    
    public func lottieOffset(isDayMode: Bool) -> Double {
        switch self {
        case .sunny:
            return isDayMode ? -220 : 0
        case .cloudy:
            return -35
        default:
            return 0
        }
    }
}
