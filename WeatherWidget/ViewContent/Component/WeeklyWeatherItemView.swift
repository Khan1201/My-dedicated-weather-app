//
//  WeeklyWeatherItemView.swift
//  WeatherWidgetExtension
//
//  Created by 윤형석 on 2023/10/06.
//

import SwiftUI
import WidgetKit

struct WeeklyWeatherItemView: View {
    let weekDay: String
    let dateString: String
    let image: String
    let precipitation: String
    let minTemperature: String
    let maxTemperature: String
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 0) {
            
            HStack(alignment: .center, spacing: 25) {
                Text(weekDay)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color.white)
                
                Text(dateString)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color.white.opacity(0.8))
            }
            
            Spacer()
            
            Image(image)
                .resizable()
                .frame(width: 23, height: 23)
                .overlay(alignment: .topTrailing) {
                    Text("\(precipitation)%")
                        .font(.system(size: 8))
                        .foregroundColor(Color.init(hexCode: "81CFFA"))
                        .offset(x: 15)
                }
            
            Spacer()
            
            HStack(alignment: .center, spacing: 15) {
                Text("\(minTemperature)°")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color.white.opacity(0.7))
                
                Text("\(maxTemperature)°")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color.white)
                
            }
        }
        .padding(.horizontal, 24)
        
    }
}

struct WeeklyWeatherItemView_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyWeatherItemView(
            weekDay: "월요일",
            dateString: "10/7",
            image: "weather_rain",
            precipitation: "20",
            minTemperature: "13",
            maxTemperature: "22"
        )
        .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
