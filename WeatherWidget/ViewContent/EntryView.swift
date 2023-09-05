//
//  EntryView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/08/31.
//


import SwiftUI

struct WeatherWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 4) {
                Image(systemName: "mappin.and.ellipse")
                    .resizable()
                    .frame(width: 17, height: 17)
                    .padding(.top, 10)
                    .padding(.leading, 6)
                
                Text("서울특별시")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(Color.white)
                    .padding(.top, 10)
            }
            .padding(.leading, 10)
            .padding(.top, 5)
            
            
            HStack(alignment: .bottom, spacing: 15) {
                Image("weather_rain")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding(.top, 10)
                    .padding(.leading, 20)
                
                Text("26°")
                    .font(.system(size: 35, weight: .bold))
                    .foregroundColor(Color.white)
            }
            .padding(.top, 5)
            
            
            HStack(alignment: .center, spacing: 4) {
                Spacer()
                Text("최저: 24° /")
                Text("최고: 30°")
                Spacer()
            }
            .font(.system(size: 12, weight: .regular))
            .foregroundColor(Color.white)
            .padding(.top, 8)
            
            HStack(alignment: .center, spacing: 0) {
                Spacer()
                VStack(alignment: .leading, spacing: 1) {
                    Text("Updated")
                    Text(entry.date, style: .time)
                }
                .font(.system(size: 7, weight: .regular))
                .foregroundColor(Color.white)
            }
            .padding(.top, 10)
            .padding(.trailing, 8)
            
            Spacer()

        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
}
