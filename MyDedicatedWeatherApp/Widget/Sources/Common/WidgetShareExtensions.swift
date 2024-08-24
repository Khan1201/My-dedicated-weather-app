//
//  WidgetShareExtensions.swift
//  WeatherWidgetExtension
//
//  Created by 윤형석 on 10/9/23.
//

import Foundation

extension UserDefaults {
    static var shared: UserDefaults {
        let appGroupId = "group.weatherProject"
        return UserDefaults(suiteName: appGroupId)!
    }
}

