//
//  TodayWeatherItemView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/07/03.
//

import SwiftUI

struct TodayWeatherItemView: View {
    
    let time: String
    let weatherImage: String
    let percent: String
    let temperature: String
    let isDayMode: Bool
    
    var body: some View {
        let isNotNocheDevice: Bool = CommonUtil.shared.isNotNocheDevice

        let imageWidth: CGFloat = UIScreen.screenWidth / 12.5
        let imageHeight: CGFloat = UIScreen.screenHeight / 27.06
        
        VStack(alignment: .center, spacing: isNotNocheDevice ? 18 : 24) {
            Text(time)
                .fontSpoqaHanSansNeo(size: isNotNocheDevice ? 12 : 14, weight: .medium)
                .foregroundColor(.white)
            
            Image(weatherImage)
                .resizable()
                .frame(width: imageWidth, height: imageHeight)
                .if(percent != "0") { view in
                    view
                        .overlay(alignment: .bottom) {
                            Text(percent + "%")
                                .fontSpoqaHanSansNeo(size: isNotNocheDevice ? 8 : 10, weight: .bold)
                                .foregroundColor(CustomColor.lightBlue.toColor)
                                .offset(y: 12)
                        }
                }
            
            Text(temperature + "°")
                .fontSpoqaHanSansNeo(size: isNotNocheDevice ? 15 : 18, weight: .medium)
                .foregroundColor(.white)
        }
    }
}

struct TodayWeatherItem_Previews: PreviewProvider {
    static var previews: some View {
        TodayWeatherItemView(time: "1AM", weatherImage: "weather_sunny", percent: "20", temperature: "21", isDayMode: false)
    }
}
