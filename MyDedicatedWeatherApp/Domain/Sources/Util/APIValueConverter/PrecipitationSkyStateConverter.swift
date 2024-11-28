//
//  PrecipitationSkyStateConverter.swift
//
//
//  Created by 윤형석 on 11/3/24.
//

import Foundation

public struct PrecipitationSkyStateConverter: APIValueConverter {
    static func convert(rawValue: String) -> any APIValue {
        switch rawValue {
        case "0":
            return SkyState.none
        case "1":
            return SkyState.rainy
        case "2":
            return SkyState.rainyAndSnow
        case "3", "7":
            return SkyState.snow
        case "4":
            return SkyState.shower
        case "5":
            return SkyState.rainDrop
        case "6":
            return SkyState.rainDropAndSnow
        default:
            return SkyState.none
        }
    }
}
