//
//  TodayWeatherItemScrollView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/07/27.
//

import SwiftUI

struct TodayWeatherItemScrollView: View {
    
    let todayWeatherInformations: [Weather.TodayInformation]
    let isDayMode: Bool
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: true) {
            
            HStack(alignment: .center, spacing: 24) {
                
                ForEach(todayWeatherInformations, id: \.time) { item in
                    TodayWeatherItemView(
                        time: item.time,
                        weatherImage: item.weatherImage,
                        percent: item.precipitation,
                        temperature: item.temperature,
                        isDayMode: isDayMode
                    )
                    .padding(.leading, todayWeatherInformations.first?.time == item.time ? 15 : 0)
                    .padding(.trailing, todayWeatherInformations.last?.time == item.time ? 15 : 0)
                }
            }
            .padding(.vertical, 10)
        }
        .background {
            isDayMode ? CustomColor.lightNavy.toColor.opacity(0.2) : .defaultAreaColor
        }
        .cornerRadius(16)
    }
}

struct TodayWeatherItemScrollView_Previews: PreviewProvider {
    static var previews: some View {
        TodayWeatherItemScrollView(
            todayWeatherInformations: [],
            isDayMode: true
        )
    }
}
