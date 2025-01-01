//
//  SkyStateConverter.swift
//
//
//  Created by 윤형석 on 1/1/25.
//

import Foundation

public struct SkyStateConverter: WeatherAPIValueConverter {
    static func convert(rawValue: String) -> any WeatherAPIValue {
        if rawValue == "맑음" {
            return SkyState.sunny
            
        } else if rawValue == "구름많음" {
            return SkyState.cloudy
            
        } else if rawValue == "흐림" {
            return SkyState.blur
            
        } else if rawValue == "구름많고 비" || rawValue == "구름많고 소나기" || rawValue == "흐리고 비" || rawValue == "흐리고 소나기" {
            return SkyState.rainy
            
        } else if rawValue == "구름많고 눈" || rawValue == "구름많고 비/눈" || rawValue == "흐리고 눈" || rawValue == "흐리고 비/눈" {
            return SkyState.snow
            
        } else {
            return SkyState.none
        }
    }
}
