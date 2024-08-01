//
//  CustomTypes.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/06/18.
//

import Foundation
import SwiftUI


// MARK: - 날씨 관련 Types

public struct Weather {
    
    public init() { }
    
    public struct DescriptionAndSkyTypeAndImageString {
        public init(description: String, skyType: SkyType, imageString: String) {
            self.description = description
            self.skyType = skyType
            self.imageString = imageString
        }
        
        public let description: String
        public let skyType: SkyType
        public let imageString: String
    }
    
    public struct DescriptionAndColor: Equatable {
        public init(description: String, color: Color) {
            self.description = description
            self.color = color
        }
        
        public let description: String
        public  let color: Color
    }
    
    public struct TodayInformation: Identifiable {
        public init(time: String, weatherImage: String, precipitation: String, temperature: String) {
            self.time = time
            self.weatherImage = weatherImage
            self.precipitation = precipitation
            self.temperature = temperature
        }
        
        public let id = UUID()
        public let time: String
        public let weatherImage: String
        public let precipitation: String
        public let temperature: String
    }

    public struct CurrentInformation {
        public init(temperature: String, windSpeed: (String, String), wetPercent: (String, String), oneHourPrecipitation: (String, String), weatherImage: String, skyType: SkyType) {
            self.temperature = temperature
            self.windSpeed = windSpeed
            self.wetPercent = wetPercent
            self.oneHourPrecipitation = oneHourPrecipitation
            self.weatherImage = weatherImage
            self.skyType = skyType
        }
        
        public let temperature: String
        public let windSpeed: (String, String)
        public let wetPercent: (String, String)
        public let oneHourPrecipitation: (String, String)
        public let weatherImage: String
        public let skyType: SkyType
    }
    
    public struct WeeklyInformation: Identifiable {
        public init(weatherImage: String, rainfallPercent: String, minTemperature: String, maxTemperature: String, date: String) {
            self.weatherImage = weatherImage
            self.rainfallPercent = rainfallPercent
            self.minTemperature = minTemperature
            self.maxTemperature = maxTemperature
            self.date = date
        }
        
        public let id = UUID()
        public var weatherImage: String
        public var rainfallPercent: String
        public var minTemperature: String
        public var maxTemperature: String
        public var date: String // yyyyMMdd (Sorting 위해)
    }
    
    public struct WeeklyChartInformation {
        public init(minTemps: [CGFloat], maxTemps: [CGFloat], xList: [(String, String)], yList: [Int], imageAndRainPercents: [(String, String)]) {
            self.minTemps = minTemps
            self.maxTemps = maxTemps
            self.xList = xList
            self.yList = yList
            self.imageAndRainPercents = imageAndRainPercents
        }
        
        public var minTemps: [CGFloat]
        public var maxTemps: [CGFloat]
        public var xList: [(String, String)] // x축 = (요일, 날짜)
        public var yList: [Int] // y축 = 온도 범위
        public var imageAndRainPercents: [(String, String)]
    }
    
    public struct WeatherImageAndMinMax {
        public init(weatherImage: String, currentTemp: String, minMaxTemp: (String, String)) {
            self.weatherImage = weatherImage
            self.currentTemp = currentTemp
            self.minMaxTemp = minMaxTemp
        }
        
        public let weatherImage: String
        public let currentTemp: String
        public let minMaxTemp: (String, String)
    }

    public enum SkyType: String {
        
        case sunny,
             cloudy,
             blur,
             rainy,
             snow,
             thunder,
             none
        
        public var backgroundImageKeyword: String {
            
            switch self {
                
            case .sunny:
                return "sunny"
                
            case .cloudy, .blur, .rainy, .snow, .thunder:
                return "blur"
                
            case .none:
                return ""
            }
        }
        
        public var backgroundLottieKeyword: String {
            
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

public struct Gps2XY {
    public init() {}
    
    public  struct LatXLngY {
        public init(lat: Double, lng: Double, x: Int, y: Int) {
            self.lat = lat
            self.lng = lng
            self.x = x
            self.y = y
        }
        
        public var lat: Double
        public var lng: Double
        
        public var x: Int
        public var y: Int
    }
    
    public enum LocationConvertMode: String {
        case toXY
        case toGPS
    }
}

// MARK: - 탭바 Types

public enum TabBarType: CaseIterable {
    case current,
        week,
        setting
}

// MARK: - 중기 예보 Req types

public enum MidtermReqType {
    case temperature, skystate, news
}

// MARK: - 초단기예보, 단기예보 값 types

public enum VeryShortTermForecastCategory: String, Codable {
    
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

public enum ShortTermForecastCategory: String, Codable {
    
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

public enum AdditionalLocationProgress {
    case loading, completed, notFound, none
}

// MARK: - 위젯 공유 사항

public enum WidgetShared: String {
    case x, y, latitude, longitude, locality, subLocality, fullAddress, dustStationName
}

public struct AllLocality {
    public init(fullAddress: String, locality: String, subLocality: String) {
        self.fullAddress = fullAddress
        self.locality = locality
        self.subLocality = subLocality
    }
    
    public let fullAddress: String
    public let locality: String
    public let subLocality: String
}

// MARK: - 일출, 일몰

public struct SunAndMoonriseBase: Decodable {
    public var sunrise: String
    public var sunset: String
    public var moonrise: String
    public var moonset: String
    
    enum TagType: String, CaseIterable {
        case sunrise, sunset, moonrise, moonset, none
    }
}
