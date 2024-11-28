//
//  WindSpeedConverter.swift
//
//
//  Created by 윤형석 on 11/29/24.
//

import Foundation

public class WindSpeedConverter: APIValueConverter {
    static func convert(rawValue: String) -> any APIValue {
        let toDouble = Double(rawValue) ?? 0.0
        switch toDouble {
        case 0.0...3.9:
            return WindSpeedType.weak
            
        case 4.0...8.9:
            return WindSpeedType.littleStrong

        case 9.0...13.9:
            return WindSpeedType.strong

        case _ where toDouble > 13.9:
            return WindSpeedType.veryStrong

        default:
            return WindSpeedType.none
        }
    }
}
