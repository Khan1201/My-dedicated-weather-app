//
//  File.swift
//  
//
//  Created by 윤형석 on 12/28/24.
//

import Foundation

public struct FineDustStateConverter: WeatherAPIValueConverter {
    static func convert(rawValue: String) -> any WeatherAPIValue {
        let valueToInt: Int = Int(rawValue) ?? 0
        
        switch valueToInt {
        case 0...30:
            return FineDustState.good
        case 31...81:
            return FineDustState.normal
        case 81...150:
            return FineDustState.bad
        case _ where valueToInt >= 151:
            return FineDustState.veryBad
        default:
            return FineDustState.none
        }
    }
}
