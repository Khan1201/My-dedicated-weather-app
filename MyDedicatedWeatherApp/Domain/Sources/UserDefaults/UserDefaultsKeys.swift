//
//  UserDefaultsKeys.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 12/4/23.
//

import Foundation

extension UserDefaults {
    static var shared: UserDefaults {
        let appGroupId = "group.weatherProject"
        return UserDefaults(suiteName: appGroupId)!
    }
}

struct UserDefaultsKeys {
    
    static let additionalFullAddresses: String = "additionalFullAddresses"
    static let additionalLocalities: String = "additionalLocalities"
    static let additionalSubLocalities: String = "additionalSubLocalities"
    static let locality: String = "locality"
    static let subLocality: String = "subLocality"
    static let fullAddress: String = "fullAddress"
    static let dustStationName: String = "dustStationName"
    static let latitude: String = "latitude"
    static let longitude: String = "longitude"
    static let x: String = "x"
    static let y: String = "y"
}
