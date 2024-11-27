//
//  SunTime.swift
//
//
//  Created by 윤형석 on 11/3/24.
//

import Foundation

public struct SunTime {
    public let currentHHmm: String
    public let sunriseHHmm: String
    public let sunsetHHmm: String
    
    public init(currentHHmm: String, sunriseHHmm: String, sunsetHHmm: String) {
        self.currentHHmm = currentHHmm
        self.sunriseHHmm = sunriseHHmm
        self.sunsetHHmm = sunsetHHmm
    }
}

extension SunTime {
    public var isDayMode: Bool {
        if currentHHmm.toInt > sunriseHHmm.toInt && currentHHmm.toInt < sunsetHHmm.toInt {
            return true
            
        } else  {
            return false
        }
    }
}
