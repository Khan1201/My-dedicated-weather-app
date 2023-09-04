//
//  Extensions.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/09/04.
//

import Foundation

extension UserDefaults {
    static var shared: UserDefaults {
        let appGroupId = "group.weatherProject"
        return UserDefaults(suiteName: appGroupId)!
    }
}
