//
//  Dummy.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/05/01.
//

import Foundation

struct Dummy {
    
    func midTermForecastModel() -> MidTermForecastBase {
        
        return MidTermForecastBase(
            regId: "",
            taMin3: 0,
            taMax3: 0,
            taMin4: 0,
            taMax4: 0,
            taMin5: 0,
            taMax5: 0,
            taMin6: 0,
            taMax6: 0,
            taMin7: 0,
            taMax7: 0,
            taMin8: 0,
            taMax8: 0,
            taMin9: 0,
            taMax9: 0,
            taMin10: 0,
            taMax10: 0
        )
    }
    
    func currentWeatherInformation() -> Weather.CurrentWeatherInformation {
        
        return Weather.CurrentWeatherInformation(
            temperature: "",
            windSpeed: ("", ""),
            wetPercent: ("", ""),
            oneHourPrecipitation: ("", ""),
            weatherImage: ""
        )
    }
}
