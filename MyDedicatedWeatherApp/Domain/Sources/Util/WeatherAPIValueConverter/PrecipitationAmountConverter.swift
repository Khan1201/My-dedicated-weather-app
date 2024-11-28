//
// PrecipitationAmountConverter.swift
//
//
//  Created by 윤형석 on 11/3/24.
//

import Foundation

public struct PrecipitationAmountConverter: WeatherAPIValueConverter {
    static public func convert(rawValue: String) -> any WeatherAPIValue {
        if rawValue == "강수없음" {
            return PrecipitationAmount.noRain
            
        } else if rawValue == "30.0~50.0mm" || rawValue == "50.0mm 이상" {
            return PrecipitationAmount.heavyRain
            
        } else {
            let stringToDouble: Double = Double(rawValue.replacingOccurrences(of: "mm", with: "")) ?? 0
            
            switch stringToDouble {
            case 1.0...2.9:
                return PrecipitationAmount.lightRain
            case 3.0...14.9:
                return PrecipitationAmount.normalRain
            case 15.0...29.9:
                return PrecipitationAmount.heavyRain
            default:
                return PrecipitationAmount.none
            }
        }
    }
    
    static public func toShortValue(_ rawValue: String) -> String {
        if rawValue == "강수없음" {
            return ""
        }
        if rawValue == "30.0~50.0mm" || rawValue == "50.0mm 이상" {
            return "30mm 이상"
        }
        return rawValue
    }
}
