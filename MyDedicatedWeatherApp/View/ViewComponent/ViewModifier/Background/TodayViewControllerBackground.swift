//
//  TodayViewControllerBackground.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/07/27.
//

import SwiftUI

struct TodayViewControllerBackground: ViewModifier {
    let isDayMode: Bool
    let isAllLoadCompleted: Bool
    let skyType: Weather.SkyType
    
    @State private var height: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .background {
                VStack(alignment: .leading, spacing: 0) {
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
                        .getHeight(height: $height)
                    }
                }
                .if(isAllLoadCompleted) { view in
                                        
                    view
                        .overlay(alignment: .top) {
                            LottieView(
                                jsonName: skyType.lottieName,
                                loopMode: .loop,
                                speed: skyType == .sunnyDay ? 1.8 : 1.0
                            )
                                .frame(width: UIScreen.screenWidth, height: height)
                                .offset(y: skyType == .sunnyDay ? 50 : 0)
                        }
                }
            }
    }
}

extension View {
    func todayViewControllerBackground(
        isDayMode: Bool,
        isAllLoadCompleted: Bool,
        skyType: Weather.SkyType
    ) -> some View {
        modifier(TodayViewControllerBackground(
            isDayMode: isDayMode,
            isAllLoadCompleted: isAllLoadCompleted,
            skyType: skyType)
        )
    }
}
