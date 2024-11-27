//
//  WeekViewControllerBackground.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/08/15.
//

import SwiftUI
import Domain

public struct WeekViewControllerBackground: ViewModifier {
    let isDayMode: Bool
    let skyType: APIValue?
    
    public init(isDayMode: Bool, skyType: APIValue?) {
        self.isDayMode = isDayMode
        self.skyType = skyType
    }
    
    public func body(content: Content) -> some View {
        content
            .background {
                VStack(alignment: .leading, spacing: 0) {
                    if let skyType = skyType, isDayMode {
                        Image(skyType.backgroundImage)
                            .resizable()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .overlay {
                                Color.black.opacity(0.2)
                            }
                            .ignoresSafeArea()
                        
                    } else {
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
                    }
                }
            }
    }
}

extension View {
    public func weekViewControllerBackground(isDayMode: Bool, skyType: APIValue?) -> some View {
        modifier(WeekViewControllerBackground(isDayMode: isDayMode, skyType: skyType))
    }
}
