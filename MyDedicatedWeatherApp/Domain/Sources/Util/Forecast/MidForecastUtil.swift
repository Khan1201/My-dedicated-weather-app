//
//  MidForecastUtil.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/08/04.
//

import Foundation

public struct MidForecastUtil {
    private init() { }

    public static let shared = MidForecastUtil()
    
    public func convertSkyState(rawValue: String) -> WeatherAPIValue {
        SkyStateConverter.convert(rawValue: rawValue)
    }
}
