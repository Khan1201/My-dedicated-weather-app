//
//  WeatherWidgetLargeView.swift
//  WeatherWidgetExtension
//
//  Created by 윤형석 on 2023/10/06.
//

import SwiftUI

struct WeatherWidgetLargeView: View {
    var body: some View {
        ZStack {
            Color.init(hexCode: "#000080")
                .opacity(0.3)
            
            VStack(alignment: .leading, spacing: 0) {
                
                HStack(alignment: .center, spacing: 0) {
                    
                    CurrentWeatherTemperatureView(
                        location: "서울특별시",
                        updatedDate: Date(),
                        weatherImage: "weather_rain",
                        currentTemperature: "22",
                        minTemperature: "13",
                        maxTemperature: "26"
                    )
                    Rectangle()
                        .frame(width: 1, height: 55)
                        .foregroundColor(Color.white.opacity(0.7))
                        .padding(.horizontal, 15)
                    
                   CurrentWeatherInformationView(
                    precipitation: "비 없음",
                    wind: "약한 바람",
                    wet: "50",
                    dust: ("좋음", "좋음")
                   )
                }
                .padding(.leading, 10)
                
                HStack(alignment: .center, spacing: 25) {
                    TodayWeatherItemView(
                        time: "11PM",
                        image: "weather_sunny_night",
                        temperature: "23"
                    )
                    
                    TodayWeatherItemView(
                        time: "11PM",
                        image: "weather_sunny_night",
                        temperature: "23"
                    )
                    
                    TodayWeatherItemView(
                        time: "11PM",
                        image: "weather_sunny_night",
                        temperature: "23"
                    )
                    
                    TodayWeatherItemView(
                        time: "11PM",
                        image: "weather_sunny_night",
                        temperature: "23"
                    )
                    
                    TodayWeatherItemView(
                        time: "11PM",
                        image: "weather_sunny_night",
                        temperature: "23"
                    )
                    
                    TodayWeatherItemView(
                        time: "11PM",
                        image: "weather_sunny_night",
                        temperature: "23"
                    )
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 14)
                
                Rectangle()
                    .fill(Color.white.opacity(0.7))
                    .frame(maxWidth: .infinity, maxHeight: 0.7, alignment: .center)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 14)
                
                VStack(alignment: .leading, spacing: 10) {
                    WeeklyWeatherItemView(
                        weekDay: "월요일",
                        dateString: "10/6",
                        image: "weather_rain",
                        precipitation: "20",
                        minTemperature: "13",
                        maxTemperature: "20"
                    )
                    
                    WeeklyWeatherItemView(
                        weekDay: "월요일",
                        dateString: "10/6",
                        image: "weather_rain",
                        precipitation: "20",
                        minTemperature: "13",
                        maxTemperature: "20"
                    )
                    
                    WeeklyWeatherItemView(
                        weekDay: "월요일",
                        dateString: "10/6",
                        image: "weather_rain",
                        precipitation: "20",
                        minTemperature: "13",
                        maxTemperature: "20"
                    )
                    
                    WeeklyWeatherItemView(
                        weekDay: "월요일",
                        dateString: "10/6",
                        image: "weather_rain",
                        precipitation: "20",
                        minTemperature: "13",
                        maxTemperature: "20"
                    )
                    
                    WeeklyWeatherItemView(
                        weekDay: "월요일",
                        dateString: "10/6",
                        image: "weather_rain",
                        precipitation: "20",
                        minTemperature: "13",
                        maxTemperature: "20"
                    )
                }
                .padding(.top, 5)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct WeatherWidgetLargeView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherWidgetLargeView()
    }
}
