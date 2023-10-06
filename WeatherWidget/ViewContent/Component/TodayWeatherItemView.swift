//
//  TodayWeatherItemView.swift
//  WeatherWidgetExtension
//
//  Created by 윤형석 on 2023/10/06.
//

import SwiftUI

struct TodayWeatherItemView: View {
    let time: String
    let image: String
    let temperature: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Text(time)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(Color.white.opacity(0.7))
            
            Image(image)
                .resizable()
                .frame(width: 24, height: 24)
            
            Text(temperature + "°")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color.white)
                .padding(.leading, 2)
        }
    }
}

struct TodayWeatherItemView_Previews: PreviewProvider {
    static var previews: some View {
        TodayWeatherItemView(
            time: "11PM",
            image: "weather_sunny_night",
            temperature: "23"
        )
    }
}
