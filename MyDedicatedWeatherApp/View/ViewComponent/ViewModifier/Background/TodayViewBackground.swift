//
//  TodayViewBackground.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/07/27.
//

import SwiftUI

struct TodayViewBackground: ViewModifier {
    let isDayMode: Bool
    
    func body(content: Content) -> some View {
        content
            .background {
                if isDayMode {
                    Image("background_sunny")
                        .overlay {
                            Color.black.opacity(0.1)
                        }
                    
                } else {
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.07, green: 0.1, blue: 0.14), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.17, green: 0.19, blue: 0.26), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0, y: 0),
                        endPoint: UnitPoint(x: 1, y: 1)
                    )
                    .ignoresSafeArea()
                    .overlay {
                        Image("background_star")
                            .resizable()
                            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
                    }
                    .overlay(alignment: .topTrailing) {
                        Image("background_cloud")
                            .resizable()
                            .frame(width: 400, height: 400)
                    }
                }
            }
    }
}

extension View {
    func todayViewBackground(isDayMode: Bool) -> some View {
        modifier(TodayViewBackground(isDayMode: isDayMode))
    }
}
