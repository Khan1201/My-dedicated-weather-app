//
//  WindSpeedConverter.swift
//
//
//  Created by 윤형석 on 11/29/24.
//

import Foundation

public class WindSpeedConverter: WeatherAPIValueConverter {
    static func convert(rawValue: String) -> any WeatherAPIValue {
        let toDouble = Double(rawValue) ?? 0.0
        switch toDouble {
        case 0.0...3.9:
            return WindSpeed.weak
            
        case 4.0...8.9:
            return WindSpeed.littleStrong

        case 9.0...13.9:
            return WindSpeed.strong

        case _ where toDouble > 13.9:
            return WindSpeed.veryStrong

        default:
            return WindSpeed.none
        }
    }
}
