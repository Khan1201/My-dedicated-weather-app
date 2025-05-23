//
//  CurrentWeatherViewBackground.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/07/27.
//

import SwiftUI
import Domain

public struct CurrentWeatherViewBackground: ViewModifier {
    let isDayMode: Bool
    let isSunriseSunsetLoadCompleted: Bool
    let isAllLoadCompleted: Bool
    let isLocationUpdated: Bool
    let skyType: WeatherAPIValue?
    
    public init(isDayMode: Bool, isSunriseSunsetLoadCompleted: Bool, isAllLoadCompleted: Bool, isLocationUpdated: Bool, skyType: WeatherAPIValue?) {
        self.isDayMode = isDayMode
        self.isSunriseSunsetLoadCompleted = isSunriseSunsetLoadCompleted
        self.isAllLoadCompleted = isAllLoadCompleted
        self.isLocationUpdated = isLocationUpdated
        self.skyType = skyType
    }
    
    @State private var isRefreshed: Bool = true
    
    public func body(content: Content) -> some View {
        content
            .background {
                VStack(alignment: .leading, spacing: 0) {
                    if isDayMode && isSunriseSunsetLoadCompleted {
                        Image(skyType?.backgroundImage ?? "")
                            .resizable()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                .if(isAllLoadCompleted && isRefreshed) { view in
                    view
                        .overlay(alignment: .top) {
                            LottieView(
                                jsonName: skyType?.backgroundLottie(isDayMode: isDayMode) ?? "",
                                loopMode: .loop,
                                speed: 1.8
                            )
                            .offset(y: skyType?.lottieOffset(isDayMode: isDayMode) ?? 0)
                        }
                }
            }
            .onChange(of: isLocationUpdated) { newValue in
                if newValue {
                    isRefreshed = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.isRefreshed = true
                    }
                }
            }
    }
}

extension View {
    public func currentWeatherViewBackground(
        isDayMode: Bool,
        isSunriseSunsetLoadCompleted: Bool,
        isAllLoadCompleted: Bool,
        isLocationUpdated: Bool,
        skyType: WeatherAPIValue?
    ) -> some View {
        modifier(CurrentWeatherViewBackground(
            isDayMode: isDayMode, 
            isSunriseSunsetLoadCompleted: isSunriseSunsetLoadCompleted,
            isAllLoadCompleted: isAllLoadCompleted, 
            isLocationUpdated: isLocationUpdated,
            skyType: skyType)
        )
    }
}
