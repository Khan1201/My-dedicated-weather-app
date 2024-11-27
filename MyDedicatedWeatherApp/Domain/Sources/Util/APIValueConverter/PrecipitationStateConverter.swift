//
//  PrecipitationStateConverter.swift
//
//
//  Created by 윤형석 on 11/3/24.
//

import Foundation

public struct PrecipitationStateConverter: APIValueConverter {
    static func convert(rawValue: String) -> any APIValue {
        switch rawValue {
        case "0":
            return SkyType.none
        case "1":
            return SkyType.rainy
        case "2":
            return SkyType.rainyAndSnow
        case "3", "7":
            return SkyType.snow
        case "4":
            return SkyType.shower
        case "5":
            return SkyType.rainDrop
        case "6":
            return SkyType.rainDropAndSnow
        default:
            return SkyType.none
        }
    }
}
