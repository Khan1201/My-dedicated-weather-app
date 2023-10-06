//
//  WeatherWidgetSmallView.swift
//  WeatherWidgetExtension
//
//  Created by 윤형석 on 2023/10/06.
//

import SwiftUI

struct WeatherWidgetSmallView: View {
    let entry: SimpleEntry
    
    var body: some View {
        ZStack {
            Color.init(hexCode: "#000080")
                .opacity(0.3)
            
            VStack(alignment: .leading, spacing: 10) {
                CurrentWeatherTemperatureView(
                    location: "서울특별시",
//                    location: test,
                    updatedDate: Date(),
                    weatherImage: entry.smallFamilyData.currentWeatherItem.weatherImage,
                    currentTemperature: entry.smallFamilyData.currentWeatherItem.currentTemperature,
                    minTemperature: entry.smallFamilyData.currentWeatherItem.minMaxTemperature.0,
                    maxTemperature: entry.smallFamilyData.currentWeatherItem.minMaxTemperature.1
                )
                
                CurrentWeatherInformationView(
                    precipitation: entry.smallFamilyData.currentWeatherItem.precipitation,
                    wind: entry.smallFamilyData.currentWeatherItem.wind,
                    wet: entry.smallFamilyData.currentWeatherItem.wetPercent,
                    dust: entry.smallFamilyData.currentWeatherItem.findDust
                )
            }
        }
    }
}

struct WeatherWidgetSmallView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherWidgetSmallView(entry: Dummy.simpleEntry())
    }
}
