//
//  Dummy.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/05/01.
//

import Foundation

struct Dummy {
    
    func currentWeatherInformation() -> Weather.CurrentWeatherInformation {
        
        return Weather.CurrentWeatherInformation(
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
    
    func todayWeatherInformations() -> [Weather.TodayWeatherInformation] {
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
    
    func weeklyWeatherInformation() -> Weather.WeeklyWeatherInformation {
        return .init(
            weatherImage: "weather_cloud_many",
            rainfallPercent: "40",
            minTemperature: "23",
            maxTemperature: "32"
        )
    }
    
    func weeklyWeatherInformations() -> [Weather.WeeklyWeatherInformation] {
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
}
