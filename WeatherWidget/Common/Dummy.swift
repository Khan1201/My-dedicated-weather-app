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
            minTemps: [22, 20, 23, 20, 17, 21],
            maxTemps: [27, 25, 27, 30, 32, 27],
            xList: [("월", "8/24"), ("화", "8/25"), ("수", "8/26"), ("목", "8/27"), ("금", "8/28"), ("토", "8/29")],
            yList: [15, 20, 25, 30, 35].reversed(),
            imageAndRainPercents: [("weather_sunny", "70"), ("weather_blur", "50"), ("weather_snow", "20"), ("weather_sunny", "70"), ("weather_rain", "0"), ("weather_sunny", "0")]
        )
    }
    
    public static func simpleEntry() -> SimpleEntry {
        .init(
            date: Date(),
            smallFamilyData: SmallFamilyData.init(
                currentWeatherItem: .init(
                    location: "서울특별시",
                    weatherImage: "weather_sunny",
                    currentTemperature: "15",
                    minMaxTemperature: ("10", "20"),
                    precipitation: "비 없음",
                    wind: "약한 바람",
                    wetPercent: "50",
                    findDust: ("좋음", "나쁨")
                )
            ),
            mediumFamilyData: .init(
                todayWeatherItems:
                    [
                        .init(
                            time: "1AM",
                            image: "weather_sunny",
                            precipitation: "20",
                            temperature: "15"
                        ),
                        .init(
                            time: "2AM",
                            image: "weather_rain",
                            precipitation: "20",
                            temperature: "16"
                        ),
                        .init(
                            time: "3AM",
                            image: "weather_blur",
                            precipitation: "0",
                            temperature: "17"
                        ),
                        .init(
                            time: "4AM",
                            image: "weather_snow",
                            precipitation: "0",
                            temperature: "18"
                        ),
                        .init(
                            time: "5AM",
                            image: "weather_sunny",
                            precipitation: "0",
                            temperature: "19"
                        ),
                        .init(
                            time: "6AM",
                            image: "weather_sunny",
                            precipitation: "40%",
                            temperature: "20"
                        )
                    ]
            ),
            largeFamilyData: .init(
                weeklyWeatherItems: [
                    .init(
                        weekDay: "월요일",
                        dateString: "1/1",
                        image: "weather_sunny",
                        rainPercent: "30",
                        minMaxTemperature: ("15", "20")
                    ),
                    .init(
                        weekDay: "화요일",
                        dateString: "1/2",
                        image: "weather_rain",
                        rainPercent: "0",
                        minMaxTemperature: ("15", "20")
                    ),
                    .init(
                        weekDay: "수요일",
                        dateString: "1/3",
                        image: "weather_blur",
                        rainPercent: "0",
                        minMaxTemperature: ("15", "20")
                    ),
                    .init(
                        weekDay: "목요일",
                        dateString: "1/4",
                        image: "weather_snow",
                        rainPercent: "40",
                        minMaxTemperature: ("15", "20")
                    ),
                    .init(
                        weekDay: "금요일",
                        dateString: "1/5",
                        image: "weather_sunny",
                        rainPercent: "00",
                        minMaxTemperature: ("15", "20")
                    )
                ]
            )
        )
    }
}
