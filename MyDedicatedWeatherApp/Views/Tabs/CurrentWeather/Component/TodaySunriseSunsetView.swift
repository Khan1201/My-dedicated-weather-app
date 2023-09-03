//
//  TodaySunriseSunsetView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/07/28.
//

import SwiftUI

struct TodaySunriseSunsetView: View {
    let sunriseTime: String
    let sunsetTime: String
    let isDayMode: Bool
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            HStack(alignment: .center, spacing: 4) {
                Image(systemName: "arrow.up")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 11, height: 11)
                    .foregroundColor(Color.red.opacity(0.7))
                
                Image("sunrise")
                    .resizable()
                    .frame(width: 20, height: 20)
                
                Text("오전 \(sunriseTime.hhMMtoKRhhMM(isSunset: false))")
                    .fontSpoqaHanSansNeo(size: 10, weight: .medium)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.bottom, 5)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.white.opacity(0.3))  // Day
            }
            
            HStack(alignment: .center, spacing: 4) {
                Image(systemName: "arrow.down")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 11, height: 11)
                    .foregroundColor(Color.red.opacity(0.7))

                Image("sunset")
                    .resizable()
                    .frame(width: 20, height: 20)
                
                Text("오후 \(sunsetTime.hhMMtoKRhhMM(isSunset: true))")
                    .fontSpoqaHanSansNeo(size: 10, weight: .medium)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.top, 5)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 12)
        .background {
            LinearGradient(colors: [Color.red.opacity(0.9), Color.black.opacity(0.5)], startPoint: .top, endPoint: .bottom)
                .opacity(isDayMode ? 0.6 : 0.4)
        }
        .cornerRadius(14)
    }
}

struct TodaySunriseSunsetView_Previews: PreviewProvider {
    static var previews: some View {
        TodaySunriseSunsetView(sunriseTime: "", sunsetTime: "", isDayMode: true)
    }
}
