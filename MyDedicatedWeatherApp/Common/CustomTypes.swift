//
//  CustomTypes.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/06/18.
//

import Foundation
import SwiftUI


// MARK: - 날씨 관련 Types

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
    
    struct TodayInformation: Identifiable {
        let id = UUID()
        let time: String
        let weatherImage: String
        let precipitation: String
        let temperature: String
    }

    struct CurrentInformation {
        let temperature: String
        let windSpeed: (String, String)
        let wetPercent: (String, String)
        let oneHourPrecipitation: (String, String)
        let weatherImage: String
        let skyType: SkyType
    }
    
    struct WeeklyInformation: Identifiable {
        let id = UUID()
        let weatherImage: String
        let rainfallPercent: String
        let minTemperature: String
        let maxTemperature: String
    }
    
    struct WeeklyChartInformation {
        let minTemps: [CGFloat]
        let maxTemps: [CGFloat]
        let xList: [(String, String)] // x축 = (요일, 날짜)
        let yList: [Int] // y축 = 온도 범위
        let imageAndRainPercents: [(String, String)]
    }
    
    struct WeatherImageAndMinMax {
        let weatherImage: String
        let currentTemp: String
        let minMaxTemp: (String, String)
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

// MARK: - 위도, 경도 -> x, y 좌표 (초단기, 단기 예보에 필요한 x,y)

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

// MARK: - 탭바 Types

enum TabBarType: CaseIterable {
    case current,
        week,
        setting
}

// MARK: - 중기 예보 Req types

enum MidtermReqType {
    case temperature, skystate, news
}

// MARK: - 초단기예보, 단기예보 값 types

enum VeryShortTermForecastCategory: String, Codable {
    
    case T1H, // 기온
         RN1, // 1시간 강수량
         PTY, // 강수 형태
         SKY, // 하늘 상태
         REH, // 습도
         WSD,// 풍속
         UUU, // 동서 바람 성분 (사용 x)
         VVV, // 남북 바람 성분 (사용 x),
         LGT, // 낙뢰 (사용 x)
         VEC // 풍향 (사용 x)
}

enum ShortTermForecastCategory: String, Codable {
    
    case POP, // 강수 확률
         PTY, // 강수 형태
         PCP, // 1시간 강수량
         REH, // 습도
         SNO, // 1시간 신적설 (사용 x)
         SKY, // 하늘상태
         TMP, // 1시간 기온
         TMN, // 일 최저기온
         TMX, // 일 최고기온
         UUU, // 동서 바람 성분 (사용 x)
         VVV, // 남북 바람 성분 (사용 x),
         WAV, // 파고 (사용 x)
         VEC, // 풍향 (사용 x)
         WSD // 풍속
}

// MARK: - 추가 위치 설정 진행 상태 State

enum AdditionalLocationProgress {
    case loading, completed, notFound, none
}

// MARK: - 위젯 공유 사항

enum WidgetShared: String {
    case x, y, latitude, longitude, locality, subLocality, fullAddress, dustStationName
}

struct AllLocality {
    let fullAddress: String
    let locality: String
    let subLocality: String
}
