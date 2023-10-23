//
//  TodayViewControllerBackground.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/07/27.
//

import SwiftUI

struct TodayViewControllerBackground: ViewModifier {
    let isDayMode: Bool
    let isSunriseSunsetLoadCompleted: Bool
    let isAllLoadCompleted: Bool
    let skyType: Weather.SkyType
    
    func body(content: Content) -> some View {
        
        let isSunnyDay: Bool = skyType == .sunny && isDayMode ? true : false
        
        var dayOrNightString: String {
            
            switch skyType {
                
            case .sunny:
                return isDayMode ? "Day" : "Night"
                
            case .cloudy:
                return ""
                
            case .blur:
                return ""
                
            case .rainy:
                return ""

            case .snow:
                return ""

            case .thunder:
                return ""
                
            case .none:
                return ""
            }
        }
        
        var lottieOffset: CGFloat {
            
            switch skyType {
                
            case .sunny:
                return isDayMode ? -220 : 0
                
            case .cloudy:
                return -35
                
            case .blur:
                return 0
                
            case .rainy:
                return 0
                
            case .snow:
                return 0
                
            case .thunder:
                return 0
                
            case .none:
                return 0
            }
        }
        
        content
            .background {
                VStack(alignment: .leading, spacing: 0) {
                    if isDayMode && isSunriseSunsetLoadCompleted {
                        Image("background_weather_\(skyType.backgroundImageKeyword)")
                            .resizable()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .overlay {
                                Color.black.opacity(0.3)
                            }
                            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 2)))
                        
                    } else if !isDayMode && isSunriseSunsetLoadCompleted {
                        LinearGradient(
                            colors: [Color(red: 0.07, green: 0.1, blue: 0.14),
                                     Color(red: 0.17, green: 0.19, blue: 0.26)],
                            startPoint: .top,
                            endPoint: .bottom
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
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .transition(AnyTransition.opacity.animation(.easeInOut(duration: 2)))

                    } else {
                        Color.blue.opacity(0.3)
                    }
                }
                .if(isAllLoadCompleted) { view in
                    view
                        .overlay(alignment: .top) {
                            LottieView(
                                jsonName: "Background\(skyType.backgroundLottieKeyword)\(dayOrNightString)Lottie",
                                loopMode: .loop,
                                speed: isSunnyDay ? 1.8 : 1.0
                            )
                            .offset(y: lottieOffset)
                        }
                }
            }
    }
}

extension View {
    func todayViewControllerBackground(
        isDayMode: Bool,
        isSunriseSunsetLoadCompleted: Bool,
        isAllLoadCompleted: Bool,
        skyType: Weather.SkyType
    ) -> some View {
        modifier(TodayViewControllerBackground(
            isDayMode: isDayMode, 
            isSunriseSunsetLoadCompleted: isSunriseSunsetLoadCompleted,
            isAllLoadCompleted: isAllLoadCompleted,
            skyType: skyType)
        )
    }
}
