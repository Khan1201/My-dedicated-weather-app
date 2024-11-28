//
//  SkyStateConverter.swift
//
//
//  Created by 윤형석 on 11/13/24.
//

import Foundation

import Foundation

public struct SkyStateConverter: APIValueConverter {
    static func convert(rawValue: String) -> any APIValue {
        switch rawValue {
        case "1":
            return SkyState.sunny
        case "3":
            return SkyState.cloudy
        case "4":
            return SkyState.blur
        default:
            return SkyState.none
        }
    }
}
