//
//  Weather.swift
//
//
//  Created by 윤형석 on 10/6/24.
//

import Foundation
import SwiftUI

// MARK: - 날씨 관련 Types

public struct Weather {
    
    public init() { }
    
    public struct DescriptionAndSkyTypeAndImageString {
        public init(description: String, skyType: SkyState, imageString: String) {
            self.description = description
            self.skyType = skyType
            self.imageString = imageString
        }
        
        public let description: String
        public let skyType: SkyState
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
        public init(temperature: String, windSpeed: (String, String), wetPercent: (String, String), oneHourPrecipitation: (String, String), weatherImage: String, skyType: APIValue) {
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
        public let skyType: APIValue
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
}
