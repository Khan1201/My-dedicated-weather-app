//
//  Dummy.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/05/01.
//

import Foundation

final class Dummy {
    static let shared = Dummy()
    
    func currentWeatherInformation() -> Weather.CurrentInformation {
        
        return Weather.CurrentInformation(
            temperature: "",
            windSpeed: ("", ""),
            wetPercent: ("", ""),
            oneHourPrecipitation: ("", ""),
            weatherImage: "",
            skyType: .cloudy
        )
    }
    
    func SunAndMoonriseBase() -> SunAndMoonriseBase {
        return .init(
            sunrise: "",
            sunset: "",
            moonrise: "",
            moonset: ""
        )
    }
    
    func todayWeatherInformations() -> [Weather.TodayInformation] {
        return [
            .init(
                time: "0000",
                weatherImage: "weather_sunny",
                precipitation: "00",
                temperature: "00"
            ),
            .init(
                time: "0000",
                weatherImage: "weather_sunny",
                precipitation: "00",
                temperature: "00"
            ),
            .init(
                time: "0000",
                weatherImage: "weather_sunny",
                precipitation: "00",
                temperature: "00"
            ),
            .init(
                time: "0000",
                weatherImage: "weather_sunny",
                precipitation: "00",
                temperature: "00"
            ),
            .init(
                time: "0000",
                weatherImage: "weather_sunny",
                precipitation: "00",
                temperature: "00"
            ),
            .init(
                time: "0000",
                weatherImage: "weather_sunny",
                precipitation: "00",
                temperature: "00"
            ),
        ]
    }
    
    func weeklyWeatherInformation() -> Weather.WeeklyInformation {
        return .init(
            weatherImage: "weather_cloud_many",
            rainfallPercent: "40",
            minTemperature: "23",
            maxTemperature: "32"
        )
    }
    
    func weeklyWeatherInformations() -> [Weather.WeeklyInformation] {
        return [
            .init(
                weatherImage: "weather_cloud_many",
                rainfallPercent: "40",
                minTemperature: "23",
                maxTemperature: "32"
            ),
            .init(
                weatherImage: "weather_blur",
                rainfallPercent: "40",
                minTemperature: "23",
                maxTemperature: "32"
            ),
            .init(
                weatherImage: "weather_cloud_many",
                rainfallPercent: "40",
                minTemperature: "23",
                maxTemperature: "32"
            ),
            .init(
                weatherImage: "weather_sunny",
                rainfallPercent: "40",
                minTemperature: "23",
                maxTemperature: "32"
            ),
            .init(
                weatherImage: "weather_rain",
                rainfallPercent: "40",
                minTemperature: "23",
                maxTemperature: "32"
            ),
            .init(
                weatherImage: "weather_snow",
                rainfallPercent: "40",
                minTemperature: "23",
                maxTemperature: "32"
            ),
            .init(
                weatherImage: "weather_sunny",
                rainfallPercent: "40",
                minTemperature: "23",
                maxTemperature: "32"
            ),
            .init(
                weatherImage: "weather_sunny",
                rainfallPercent: "40",
                minTemperature: "23",
                maxTemperature: "32"
            ),
            
        ]
    }
    
    func weeklyChartInformation() -> Weather.WeeklyChartInformation {
        return .init(
            minTemps: [22, 20, 23, 20, 23, 21, 22],
            maxTemps: [27, 25, 27, 30, 32, 27, 28],
            xList: [("월", "8/24"), ("화", "8/25"), ("수", "8/26"), ("목", "8/27"), ("금", "8/28"), ("토", "8/29"), ("일", "8/30")],
            yList: [15, 20, 25, 30, 35].reversed(),
            imageAndRainPercents: [("weather_sunny", "70"), ("weather_blur", "50"), ("weather_snow", "20"), ("weather_sunny", "70"), ("weather_rain", "0"), ("weather_sunny", "0"), ("weather_cloud_many", "30")]
        )
    }
}
