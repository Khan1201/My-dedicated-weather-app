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
    
    struct WeeklyWeatherInformation: Identifiable {
        let id = UUID()
        let weatherImage: String
        let rainfallPercent: String
        let minTemperature: String
        let maxTemperature: String
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

/// 위도, 경도 -> x, y 좌표 (초단기, 단기 예보에 필요한 x,y)
struct Gps2XY {
    
    struct LatXLngY {
        public var lat: Double
        public var lng: Double
        
        public var x: Int
        public var y: Int
    }
    
    enum LocationConvertMode: String {
        case toXY
        case toGPS
    }
}

enum TabBarType: CaseIterable {
    case current,
        forecast,
        search,
        setting
}

enum MidtermReqType {
    case temperature, skystate, news
}

struct TemperatureChartInf {
    let minTemps: [CGFloat]
    let maxTemps: [CGFloat]
    let xList: [String] // x축 -> 요일
    let yList: [Int] // y축 -> 온도 범위
}


