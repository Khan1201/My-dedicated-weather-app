//
//  UserDefaultsKeys.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 12/4/23.
//

import Foundation

extension UserDefaults {
    public static var shared: UserDefaults {
        let appGroupId = "group.weatherProject"
        return UserDefaults(suiteName: appGroupId)!
    }
}

public struct UserDefaultsKeys {
    
    public static let additionalFullAddresses: String = "additionalFullAddresses"
    public static let additionalLocalities: String = "additionalLocalities"
    public static let additionalSubLocalities: String = "additionalSubLocalities"
    public static let locality: String = "locality"
    public static let subLocality: String = "subLocality"
    public static let fullAddress: String = "fullAddress"
    public static let dustStationName: String = "dustStationName"
    public static let latitude: String = "latitude"
    public static let longitude: String = "longitude"
    public static let x: String = "x"
    public static let y: String = "y"
}
