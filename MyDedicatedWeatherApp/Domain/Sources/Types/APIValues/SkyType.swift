//
//  SkyType.swift
//
//
//  Created by 윤형석 on 11/3/24.
//

import Foundation

public enum SkyType: String, APIValue {
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
            return "없음"
        }
    }
        
    public var backgroundImageKeyword: String {
        switch self {
        case .sunny:
            return "sunny"
        case .cloudy, .blur, .rainy, .snow, .thunder:
            return "blur"
        default:
            return ""
        }
    }
    
    public var backgroundLottieKeyword: String {
        switch self {
        case .sunny:
            return "Sunny"
        case .cloudy:
            return "Cloudy"
        case .rainy:
            return "Rainy"
        case .snow:
            return "Snow"
        case .thunder:
            return "Thunder"
        default:
            return ""
        }
    }
}
