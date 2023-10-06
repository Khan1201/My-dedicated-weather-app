//
//  WeatherWidgetSmallView.swift
//  WeatherWidgetExtension
//
//  Created by 윤형석 on 2023/10/06.
//

import SwiftUI

struct WeatherWidgetSmallView: View {
    var body: some View {
        ZStack {
            Color.init(hexCode: "#000080")
                .opacity(0.3)
            
            VStack(alignment: .leading, spacing: 10) {
                CurrentWeatherTemperatureView(
                    location: "서울특별시",
                    updatedDate: Date(),
                    weatherImage: "weather_rain",
                    currentTemperature: "22",
                    minTemperature: "14",
                    maxTemperature: "23"
                )
                
                CurrentWeatherInformationView(
                    precipitation: "비 없음",
                    wind: "약한 바람",
                    wet: "50",
                    dust: ("좋음", "좋음")
                )
            }
        }
    }
}

struct WeatherWidgetSmallView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherWidgetSmallView()
    }
}
