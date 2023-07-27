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
                Image("sunrise")
                    .resizable()
                    .frame(width: 24, height: 24)
                
                Text("AM \(sunsetTime)")
                    .fontSpoqaHanSansNeo(size: 14, weight: .regular)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.bottom, 5)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.white.opacity(0.3))  // Day
            }
            
            HStack(alignment: .center, spacing: 4) {
                Image("sunset")
                    .resizable()
                    .frame(width: 24, height: 24)
                
                Text("PM \(sunsetTime)")
                    .fontSpoqaHanSansNeo(size: 14, weight: .medium)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.top, 5)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 12)
        .background(Color.red.opacity(isDayMode ? 0.3 : 0.2))
        .cornerRadius(14)
    }
}

struct TodaySunriseSunsetView_Previews: PreviewProvider {
    static var previews: some View {
        TodaySunriseSunsetView(sunriseTime: "", sunsetTime: "", isDayMode: true)
    }
}
