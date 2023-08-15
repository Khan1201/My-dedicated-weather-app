//
//  WeekWeatherItemView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/08/12.
//

import SwiftUI

struct WeekWeatherItemView: View {
    let item: Weather.WeeklyWeatherInformation
    @State var recWidth: CGFloat = 0
    
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
                        
            VStack(alignment: .leading, spacing: 0) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.blue.opacity(0.3))
                    .frame(width: recWidth, height: 5)
                    .padding(.leading, 14)
            }
            .frame(width: 122, alignment: .leading)
            
            Text("\(item.maxTemperature)°")
                .fontSpoqaHanSansNeo(size: 18, weight: .bold)
                .foregroundColor(Color.white)
                .padding(.leading, 14)
            
        }
        .frame(width: UIScreen.screenWidth - 48)
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.08))
        .cornerRadius(14)
        .task {
            withAnimation(.linear(duration: 0.8)) {
                recWidth = CGFloat(item.maxTemperature.toInt) * 3.3
            }
        }
    }
}

struct WeekWeatherItemView_Previews: PreviewProvider {
    static var previews: some View {
        WeekWeatherItemView(item: Dummy.shared.weeklyWeatherInformation())
    }
}
