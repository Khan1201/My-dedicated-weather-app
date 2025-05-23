//
//  TodaySunriseSunsetView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/07/28.
//

import SwiftUI
import Domain
import Core

struct TodaySunriseSunsetView: View {
    let sunriseTime: String
    let sunsetTime: String
    let isDayMode: Bool
    
    var body: some View {
        let isNotNocheDevice: Bool = CommonUtil.shared.isNotNocheDevice

        VStack(alignment: .leading, spacing: 0) {
            if let sunriseTime = CommonUtil.shared.hhMMtoKRHm(sunriseTime), let sunsetTime = CommonUtil.shared.hhMMtoKRHm(sunsetTime) {
                HStack(alignment: .center, spacing: 4) {
                    Image("sunrise")
                        .resizable()
                        .frame(width: 20, height: 20)
                    
                    Text("오전 \(sunriseTime)")
                        .fontSpoqaHanSansNeo(size: isNotNocheDevice ? 9 : 10, weight: .medium)
                        .foregroundStyle(Color.white)
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
                        .frame(width: 20, height: 20)
                    
                    Text("오후 \(sunsetTime)")
                        .fontSpoqaHanSansNeo(size: isNotNocheDevice ? 9 : 10, weight: .medium)
                        .foregroundStyle(Color.white)
                }
                .padding(.top, 5)
            }
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 12)
        .background {
            Color.defaultAreaColor
        }
        .cornerRadius(14)
    }
}

struct TodaySunriseSunsetView_Previews: PreviewProvider {
    static var previews: some View {
        TodaySunriseSunsetView(sunriseTime: "", sunsetTime: "", isDayMode: true)
    }
}
