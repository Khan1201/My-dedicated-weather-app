//
//  WeeklyWeatherItemView.swift
//  WeatherWidgetExtension
//
//  Created by 윤형석 on 2023/10/06.
//

import SwiftUI
import WidgetKit
import Core

struct WeeklyWeatherItemView: View {
    let weekDay: String
    let dateString: String
    let image: String
    let precipitation: String
    let minTemperature: String
    let maxTemperature: String
    
    @State private var twoDigitTempSize: CGSize = CGSize()
    
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
            
            Image(image, bundle: .module)
                .resizable()
                .frame(width: 23, height: 23)
                .if(precipitation != "0") { view in
                    view
                        .overlay(alignment: .topTrailing) {
                            Text("\(precipitation)%")
                                .font(.system(size: 7, weight: .bold))
                                .foregroundColor(Color.init(hexCode: "81CFFA"))
                                .offset(x: 15)
                        }
                }
            
            Spacer()
            
            HStack(alignment: .center, spacing: 15) {
                Text("\(minTemperature)°")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color.white.opacity(0.7))
                    .frame(maxWidth: twoDigitTempSize.width)
                
                Text("\(maxTemperature)°")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color.white)
                    .frame(maxWidth: twoDigitTempSize.width)
                
            }
        }
        .padding(.horizontal, 24)
        /// 2자리수 온도  width get 위해
        .overlay {
            Text("-00°")
                .font(.system(size: 13, weight: .bold))
                .getSize(size: $twoDigitTempSize)
                .opacity(0)
        }
        
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
