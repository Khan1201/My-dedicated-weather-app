//
//  CustomTypes.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/06/18.
//

import Foundation
import SwiftUI

struct Weather {
    
    struct DescriptionAndSkyTypeAndImageString {
        let description: String
        let skyType: SkyType
        let imageString: String
    }
    
    struct DescriptionAndColor: Equatable {
        let description: String
        let color: Color
    }
    
    struct TodayWeatherInformation {
        let time: String
        let weatherImage: String
        let precipitation: String
        let temperature: String
    }

    struct CurrentWeatherInformation {
        let temperature: String
        let windSpeed: (String, String)
        let wetPercent: (String, String)
        let oneHourPrecipitation: (String, String)
        let weatherImage: String
        let skyType: SkyType
    }

    enum SkyType: String {
        case sunny,
             cloudy,
             blur,
             rainy,
             snow,
             thunder,
             none
        
        var backgroundImageKeyword: String {
            
            switch self {
                
            case .sunny:
                return "sunny"
                
            case .cloudy, .blur, .rainy, .snow, .thunder:
                return "blur"
                
            case .none:
                return ""
            }
        }
        
        var backgroundLottieKeyword: String {
            
            switch self {
                
            case .sunny:
                return "Sunny"
                
            case .cloudy:
                return "Cloudy"
                
            case .blur:
                return ""
            
            case .rainy:
                return "Rainy"
                
            case .snow:
                return "Snow"
                
            case .thunder:
                return "Thunder"
                
            case .none:
                return ""
            }
        }
    }
}

enum TabBarType: CaseIterable {
    
    case current,
        forecast,
        search,
        setting
}
