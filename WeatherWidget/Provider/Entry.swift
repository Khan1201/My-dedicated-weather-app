//
//  Entry.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/08/31.
//

import WidgetKit

struct SimpleEntry: TimelineEntry {
    var date: Date
    var isDayMode: Bool
    var smallFamilyData: SmallFamilyData
    var mediumFamilyData: MediumFamilyData
    var largeFamilyData: LargeFamilyData
}

struct SmallFamilyData {
    var currentWeatherItem: CurrentWeatherItem
    
    struct CurrentWeatherItem {
        var location: String
        var weatherImage: String
        var currentTemperature: String
        var minMaxTemperature: (String, String)
        var precipitation: String
        var wind: String
        var wetPercent: String
        var findDust: (String, String) // 미세먼지, 초미세먼지
    }
}

struct MediumFamilyData {
    var todayWeatherItems: [TodayWeatherItem]
    
    struct TodayWeatherItem {
        var time: String
        var image: String
        var precipitation: String
        var temperature: String
    }
}

struct LargeFamilyData {
    var weeklyWeatherItems: [WeeklyWeatherItem]
    
    struct WeeklyWeatherItem {
        var weekDay: String
        var dateString: String
        var image: String
        var rainPercent: String
        var minMaxTemperature: (String, String)
    }
}
