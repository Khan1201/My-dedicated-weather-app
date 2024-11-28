//
//  PrecipitationAmountType.swift
//
//
//  Created by 윤형석 on 11/3/24.
//

import Foundation

public enum PrecipitationAmountType: APIValue {
    case noRain, lightRain, normalRain, heavyRain, veryHeavyRain, none
    
    public var toDescription: String {
        switch self {
        case .noRain:
            return "비 없음"
        case .lightRain:
            return "약한 비"
        case .normalRain:
            return "보통 비"
        case .heavyRain:
            return "강한 비"
        case .veryHeavyRain:
            return "매우 강한 비"
        case .none:
            return "알 수 없음"
        }
    }
}
