//
//  Dummy.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/09/14.
//

import Foundation

final class Dummy {
    
    public static func weeklyChartInformation() -> Weather.WeeklyChartInformation {
        return .init(
            minTemps: [22, 20, 23, 20, 23, 21],
            maxTemps: [27, 25, 27, 30, 32, 27],
            xList: [("월", "8/24"), ("화", "8/25"), ("수", "8/26"), ("목", "8/27"), ("금", "8/28"), ("토", "8/29")],
            yList: [15, 20, 25, 30, 35].reversed(),
            imageAndRainPercents: [("weather_sunny", "70"), ("weather_blur", "50"), ("weather_snow", "20"), ("weather_sunny", "70"), ("weather_rain", "0"), ("weather_sunny", "0")]
        )
    }
}
