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
        let maxTemperatureIsMinus: Bool = item.maxTemperature.toInt <= 0
        let imageWidth: CGFloat = UIScreen.screenWidth / 11.718
        let baseRecWidth: CGFloat = UIScreen.screenWidth / 3.947
        let oneTemperatureWidth: CGFloat = baseRecWidth / 35

        HStack(alignment: .center, spacing: 0) {
            Text(day)
                .fontSpoqaHanSansNeo(size: 15, weight: .medium)
                .foregroundColor(Color.white)
            
            Spacer(minLength: 20)
            
            Image("\(item.weatherImage)")
                .resizable()
                .frame(width: imageWidth, height: imageWidth)
                .if(item.rainfallPercent != "0") { view in
                    view
                        .overlay(alignment: .bottom) {
                            Text(item.rainfallPercent + "%")
                                .fontSpoqaHanSansNeo(size: 11, weight: .bold)
                                .foregroundColor(CustomColor.lightBlue.toColor)
                                .offset(y: 4)
                        }
                }
            
            Spacer(minLength: 12)
            
            Text("\(item.minTemperature)°")
                .fontSpoqaHanSansNeo(size: 17, weight: .bold)
                .foregroundColor(Color.white.opacity(0.5))
                .frame(maxWidth: twoDigitTempSize.width)
            
            Spacer(minLength: 8)
                        
            VStack(alignment: .leading, spacing: 0) {
                
                ZStack(alignment: .leading) {
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 16)
                            .frame(width: 95, height: 5)
                            .opacity(0)
                        
                        RoundedRectangle(cornerRadius: 16)
                            .fill(LinearGradient(colors: [Color(hexCode: "CDCF5C"), Color(hexCode: "EF8835")], startPoint: .leading, endPoint: .trailing))
                            .frame(width: recWidth, height: 5)
                            .opacity(maxTemperatureIsMinus ? 0 : 1)
                    }
                    
                    ZStack(alignment: .trailing) {
                        RoundedRectangle(cornerRadius: 16)
                            .frame(width: 95, height: 5)
                            .opacity(0)
                        
                        RoundedRectangle(cornerRadius: 16)
                            .fill(LinearGradient(colors: [Color(hexCode: "56CCF2"), Color(hexCode: "2F80ED")], startPoint: .trailing, endPoint: .leading))
                            .frame(width: recWidth, height: 5)
                            .opacity(maxTemperatureIsMinus ? 1 : 0)
                    }
                }
            }
            
            Spacer(minLength: 8)
            
            Text("\(item.maxTemperature)°")
                .fontSpoqaHanSansNeo(size: 17, weight: .bold)
                .foregroundColor(Color.white)
                .frame(maxWidth: twoDigitTempSize.width)
            
        }
        /// 2자리수 온도  width get 위해
        .overlay {
            Text("-10°")
                .fontSpoqaHanSansNeo(size: 17, weight: .bold)
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
                recWidth = maxTemperatureIsMinus ? -(CGFloat(item.minTemperature.toInt) * oneTemperatureWidth) : CGFloat(item.maxTemperature.toInt) * oneTemperatureWidth
            }
        }
    }
}

struct WeekWeatherItemView_Previews: PreviewProvider {
    static var previews: some View {
        WeekWeatherItemView(item: Dummy.shared.weeklyWeatherInformation(), day: "월요일")
    }
}
