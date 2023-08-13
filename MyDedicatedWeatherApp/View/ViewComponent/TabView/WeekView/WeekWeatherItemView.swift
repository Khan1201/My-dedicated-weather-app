//
//  WeekWeatherItemView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/08/12.
//

import SwiftUI

struct WeekWeatherItemView: View {
    
    let item: Weather.WeeklyWeatherInformation
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Text("일요일")
                .fontSpoqaHanSansNeo(size: 18, weight: .medium)
                .foregroundColor(Color.white)
            
            Image("\(item.weatherImage)")
                .resizable()
                .frame(width: 40, height: 40)
                .if(item.rainfallPercent != "0") { view in
                    view
                        .overlay(alignment: .bottom) {
                            Text(item.rainfallPercent + "%")
                                .fontSpoqaHanSansNeo(size: 10, weight: .bold)
                                .foregroundColor(CustomColor.lightBlue.toColor)
                                .offset(y: 4)
                        }
                }
                .padding(.leading, 25)
            
            Text("\(item.minTemperature)°")
                .fontSpoqaHanSansNeo(size: 18, weight: .bold)
                .foregroundColor(Color.gray)
                .padding(.leading, 12)
            
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.blue.opacity(0.3))
                .frame(width: 100, height: 5)
                .padding(.leading, 14)
            
            Text("\(item.maxTemperature)°")
                .fontSpoqaHanSansNeo(size: 18, weight: .bold)
                .foregroundColor(Color.white)
                .padding(.leading, 14)
            
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(Color.green.opacity(0.4))
        .cornerRadius(14)
    }
}

struct WeekWeatherItemView_Previews: PreviewProvider {
    static var previews: some View {
        WeekWeatherItemView(item: Dummy.shared.weeklyWeatherInformation())
    }
}
