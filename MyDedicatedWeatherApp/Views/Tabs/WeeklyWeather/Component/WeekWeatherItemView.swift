//
//  WeekWeatherItemView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/08/12.
//

import SwiftUI

struct WeekWeatherItemView: View {
    let item: Weather.WeeklyInformation
    let day: String
    @State var recWidth: CGFloat = 0
    
    @State private var twoDigitTempSize: CGSize = CGSize()

    var body: some View {

        HStack(alignment: .center, spacing: 0) {
            Text(day)
                .fontSpoqaHanSansNeo(size: 16, weight: .medium)
                .foregroundColor(Color.white)
            
            Image("\(item.weatherImage)")
                .resizable()
                .frame(width: 35, height: 35)
                .if(item.rainfallPercent != "0") { view in
                    view
                        .overlay(alignment: .bottom) {
                            Text(item.rainfallPercent + "%")
                                .fontSpoqaHanSansNeo(size: 11, weight: .bold)
                                .foregroundColor(CustomColor.lightBlue.toColor)
                                .offset(y: 4)
                        }
                }
                .padding(.leading, 25)
            
            Text("\(item.minTemperature)°")
                .fontSpoqaHanSansNeo(size: 18, weight: .bold)
                .foregroundColor(Color.white.opacity(0.5))
                .frame(maxWidth: twoDigitTempSize.width)
                .padding(.leading, 12)
                        
            VStack(alignment: .leading, spacing: 0) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(colors: [Color(hexCode: "CDCF5C"), Color(hexCode: "EF8835")], startPoint: .leading, endPoint: .trailing))
                    .frame(width: recWidth, height: 5)
                    .padding(.leading, 12)
            }
            .frame(width: 112, alignment: .leading)
            
            Text("\(item.maxTemperature)°")
                .fontSpoqaHanSansNeo(size: 18, weight: .bold)
                .foregroundColor(Color.white)
                .frame(maxWidth: twoDigitTempSize.width)
                .padding(.leading, 12)
            
        }
        /// 2자리수 온도  width get 위해
        .overlay {
            Text("00°")
                .fontSpoqaHanSansNeo(size: 18, weight: .bold)
                .getSize(size: $twoDigitTempSize)
                .opacity(0)
        }
        .frame(maxWidth: UIScreen.screenWidth - 70)
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background {
            Color.defaultAreaColor
        }
        .cornerRadius(14)
        .onAppear {
            recWidth = 0
            withAnimation(.easeInOut(duration: 0.8)) {
                recWidth = CGFloat(item.maxTemperature.toInt) * 3
            }
        }
    }
}

struct WeekWeatherItemView_Previews: PreviewProvider {
    static var previews: some View {
        WeekWeatherItemView(item: Dummy.shared.weeklyWeatherInformation(), day: "월요일")
    }
}
