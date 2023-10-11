//
//  Types.swift
//  WeatherWidgetExtension
//
//  Created by 윤형석 on 2023/09/12.
//

import Foundation
import SwiftUI

enum MidtermReqType {
    case temperature, skystate, news
}

//struct Weather {
//    
//    struct DescriptionAndSkyTypeAndImageString {
//        let description: String
//        let skyType: SkyType
//        let imageString: String
//    }
//
//    struct DescriptionAndColor: Equatable {
//        let description: String
//        let color: Color
//    }
//
//    struct TodayInformation {
//        let time: String
//        let weatherImage: String
//        let precipitation: String
//        let temperature: String
//    }
//
//    struct CurrentInformation {
//        let temperature: String
//        let windSpeed: (String, String)
//        let wetPercent: (String, String)
//        let oneHourPrecipitation: (String, String)
//        let weatherImage: String
//        let skyType: SkyType
//    }
//
//    struct WeeklyInformation: Identifiable {
//        let id = UUID()
//        let weatherImage: String
//        let rainfallPercent: String
//        let minTemperature: String
//        let maxTemperature: String
//    }
//
//    struct WeeklyChartInformation {
//        let minTemps: [CGFloat]
//        let maxTemps: [CGFloat]
//        let xList: [(String, String)] // x축 = (요일, 날짜)
//        let yList: [Int] // y축 = 온도 범위
//        let imageAndRainPercents: [(String, String)]
//    }
//
//    enum SkyType: String {
//        case sunny,
//             cloudy,
//             blur,
//             rainy,
//             snow,
//             thunder,
//             none
//
//        var backgroundImageKeyword: String {
//
//            switch self {
//
//            case .sunny:
//                return "sunny"
//
//            case .cloudy, .blur, .rainy, .snow, .thunder:
//                return "blur"
//
//            case .none:
//                return ""
//            }
//        }
//
//        var backgroundLottieKeyword: String {
//
//            switch self {
//
//            case .sunny:
//                return "Sunny"
//
//            case .cloudy:
//                return "Cloudy"
//
//            case .blur:
//                return ""
//
//            case .rainy:
//                return "Rainy"
//
//            case .snow:
//                return "Snow"
//
//            case .thunder:
//                return "Thunder"
//
//            case .none:
//                return ""
//            }
//        }
//    }
//}
