//
//  WeatherWidgetMediumView.swift
//  WeatherWidgetExtension
//
//  Created by 윤형석 on 2023/10/06.
//

import SwiftUI

struct WeatherWidgetMediumView: View {
    let entry: SimpleEntry
    let location: String
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            HStack(alignment: .center, spacing: 0) {
                CurrentWeatherTemperatureView(
                    location: location,
                    updatedDate: Date(),
                    weatherImage: entry.smallFamilyData.currentWeatherItem.weatherImage,
                    currentTemperature: entry.smallFamilyData.currentWeatherItem.currentTemperature,
                    minTemperature: entry.smallFamilyData.currentWeatherItem.minMaxTemperature.0,
                    maxTemperature: entry.smallFamilyData.currentWeatherItem.minMaxTemperature.1
                )
                
                Rectangle()
                    .frame(width: 1, height: 55)
                    .foregroundColor(Color.white.opacity(0.7))
                    .padding(.horizontal, 15)
                
                CurrentWeatherInformationView(
                    precipitation: entry.smallFamilyData.currentWeatherItem.precipitation,
                    wind: entry.smallFamilyData.currentWeatherItem.wind,
                    wet: entry.smallFamilyData.currentWeatherItem.wetPercent,
                    dust: entry.smallFamilyData.currentWeatherItem.findDust
                )
            }
            .padding(.leading, 10)
            
            HStack(alignment: .center, spacing: 25) {
                ForEach(entry.mediumFamilyData.todayWeatherItems, id: \.time) { item in
                    TodayWeatherItemView(
                        time: item.time,
                        image: item.image,
                        temperature: item.temperature,
                        rainPercent: item.precipitation
                    )
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 14)
        }
    }
}

struct WeatherWidgetMediumView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherWidgetMediumView(entry: Dummy.simpleEntry(), location: "")
    }
}
