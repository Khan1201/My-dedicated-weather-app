//
//  File.swift
//  
//
//  Created by 윤형석 on 12/28/24.
//

import Foundation

public struct UltraFineDustStateConverter: WeatherAPIValueConverter {
    static func convert(rawValue: String) -> any WeatherAPIValue {
        let valueToInt: Int = Int(rawValue) ?? 0
        
        switch valueToInt {
        case 0...15:
            return FineDustState.good
        case 16...35:
            return FineDustState.normal
        case 36...75:
            return FineDustState.bad
        case _ where valueToInt >= 76:
            return FineDustState.veryBad
        default:
            return FineDustState.none
        }
    }
}
