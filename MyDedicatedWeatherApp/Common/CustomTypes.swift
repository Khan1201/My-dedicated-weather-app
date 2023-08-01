//
//  CustomTypes.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/06/18.
//

import Foundation
import SwiftUI

struct Weather {
    
    struct DescriptionAndImageString {
        let description: String
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
    }
    
    enum SkyType {
        case sunnyDay,
             sunnyNight,
             cloudy,
             rainy,
             snow,
             thunder
        
        var lottieName: String {
            
            switch self {
                
            case .sunnyDay:
                return "BackgroundSunnyDayLottie"
                
            case .sunnyNight:
                return "BackgroundSunnyNightLottie"

            case .cloudy:
                return "BackgroundSunnyLottie"
                
            case .rainy:
                return "BackgroundRainyLottie"
                
            case .snow:
                return "BackgroundSnowLottie"
                
            case .thunder:
                return "BackgroundSnowLottie"
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
