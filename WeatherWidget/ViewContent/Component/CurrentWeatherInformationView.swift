//
//  CurrentWeatherInformationView.swift
//  WeatherWidgetExtension
//
//  Created by 윤형석 on 2023/10/06.
//

import SwiftUI

struct CurrentWeatherInformationView: View {
    let precipitation: String
    let wind: String
    let wet: String
    let dust: (String, String)
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            VStack(alignment: .leading, spacing: 5) {
                HStack(alignment: .center, spacing: 10) {
                    Image("precipitation")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color.blue.opacity(0.5))
                        .frame(width: 15, height: 15)
                    
                    Text(precipitation)
                        .font(.system(size: 9, weight: .medium))
                        .foregroundColor(Color.white)
                }
                
                HStack(alignment: .center, spacing: 10) {
                    Image("wind")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color.red.opacity(0.5))
                        .frame(width: 15, height: 15)
                    
                    Text(wind)
                        .font(.system(size: 9, weight: .medium))
                        .foregroundColor(Color.white)
                }
                
                HStack(alignment: .center, spacing: 10) {
                    Image("wet")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color.blue.opacity(0.3))
                        .frame(width: 15, height: 15)
                    
                    Text("\(wet)%")
                        .font(.system(size: 9, weight: .medium))
                        .foregroundColor(Color.white)
                }
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .background(Color.white.opacity(0.1))
            .cornerRadius(8)
            
            VStack(alignment: .center, spacing: 10) {
                HStack(alignment: .center, spacing: 8) {
                    Image("fine_dust")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color.gray)
                        .frame(width: 16, height: 16)
                    
                    Text("좋음")
                        .font(.system(size: 9, weight: .medium))
                        .foregroundColor(Color.white)
                        .padding(.top, 1)
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(Color.green.opacity(0.2))
                .cornerRadius(10)
                                            
                HStack(alignment: .center, spacing: 8) {
                    Image("fine_dust")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color.red.opacity(0.5))
                        .frame(width: 16, height: 16)
                    
                    Text("좋음")
                        .font(.system(size: 9, weight: .medium))
                        .foregroundColor(Color.white)
                        .padding(.top, 1)
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(Color.green.opacity(0.2))
                .cornerRadius(10)
            }
        }
    }
}

struct CurrentWeatherInformationView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherInformationView(
            precipitation: "비 없음",
            wind: "약한 바람",
            wet: "50%",
            dust: ("좋음", "좋음")
        )
    }
}
