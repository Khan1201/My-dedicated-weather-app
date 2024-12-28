//
//  File.swift
//  
//
//  Created by 윤형석 on 12/28/24.
//

import Foundation
import SwiftUI

public enum FineDustState: WeatherAPIValue {
    case good, normal, bad, veryBad, none
    
    public var toDescription: String {
        switch self {
        case .good:
            return "좋음"
        case .normal:
            return "보통"
        case .bad:
            return "나쁨"
        case .veryBad:
            return "매우 나쁨"
        default:
            return "알 수 없음"
        }
    }
    
    public var color: Color {
        switch self {
        case .good:
            return .blue
        case .normal:
            return .green
        case .bad:
            return .orange
        case .veryBad:
            return .red
        default:
            return .clear
        }
    }
}
