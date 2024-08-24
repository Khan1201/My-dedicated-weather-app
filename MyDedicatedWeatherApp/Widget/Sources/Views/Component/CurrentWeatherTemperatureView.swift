//
//  CurrentWeatherTemperatureView.swift
//  WeatherWidgetExtension
//
//  Created by 윤형석 on 2023/10/06.
//

import SwiftUI

struct CurrentWeatherTemperatureView: View {
    let location: String
    let updatedDate: Date
    let weatherImage: String
    let currentTemperature: String
    let minTemperature: String
    let maxTemperature: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            
            HStack(alignment: .center, spacing: 0) {
                Image(systemName: "mappin.and.ellipse")
                    .resizable()
                    .frame(width: 11, height: 11)
                
                Text(location)
                    .font(.system(size: 10, weight: .medium))
                    .padding(.leading, 7)
                
                HStack(alignment: .center, spacing: 0) {
                    Text("Updated ")
                    Text(updatedDate, style: .time)
                }
                .font(.system(size: 8))
                .padding(.leading, 10)
            }
            .foregroundColor(Color.white)
            
            HStack(alignment: .bottom, spacing: 15) {
                Image(weatherImage, bundle: .module)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding(.leading, 10)
                
                VStack(alignment: .center, spacing: 4) {
                    Text("\(currentTemperature)°")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color.white)
                    
                    HStack(alignment: .bottom, spacing: 5) {
                        HStack(alignment: .center, spacing: 3) {
                            Image(systemName: "arrow.down")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 10, height: 10)
                                .foregroundColor(Color.blue.opacity(0.8))
                            
                            Text("\(minTemperature)°")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(Color.white)
                        }
                        
                        HStack(alignment: .center, spacing: 3) {
                            Image(systemName: "arrow.up")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 10, height: 10)
                                .foregroundColor(Color.red.opacity(0.8))
                            
                            Text("\(maxTemperature)°")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(Color.white)
                        }
                    }
                }
            }
        }
    }
}

struct CurrentWeatherTemperatureView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherTemperatureView(
            location: "서울특별시",
            updatedDate: Date(),
            weatherImage: "weather_rain",
            currentTemperature: "22",
            minTemperature: "13",
            maxTemperature: "26"
        )
    }
}
