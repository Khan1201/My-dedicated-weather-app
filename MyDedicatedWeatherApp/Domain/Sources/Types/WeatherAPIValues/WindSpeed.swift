//
//  WindSpeed.swift
//
//
//  Created by 윤형석 on 11/29/24.
//

import Foundation

public enum WindSpeed: WeatherAPIValue {
    case weak, littleStrong, strong, veryStrong, none
    
    public var toDescription: String {
        switch self {
        case .weak:
            return "약한 바람"
        case .littleStrong:
            return "약간 강한 바람"
        case .strong:
            return "강한 바람"
        case .veryStrong:
            return "매우 강한 바람"
        case .none:
            return "알 수 없음"
        }
    }
}
