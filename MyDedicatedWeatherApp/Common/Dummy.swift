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
}
