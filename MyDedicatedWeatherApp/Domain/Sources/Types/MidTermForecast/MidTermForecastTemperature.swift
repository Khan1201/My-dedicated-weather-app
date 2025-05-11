//
//  MidTermForecastTemperature.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/04/30.
//

import Foundation

public struct MidTermForecastTemperature: Decodable {
    public init(regId: String, taMin5: Int, taMax5: Int, taMin6: Int, taMax6: Int, taMin7: Int, taMax7: Int, taMin8: Int, taMax8: Int, taMin9: Int, taMax9: Int, taMin10: Int, taMax10: Int) {
        self.regId = regId
        self.taMin5 = taMin5
        self.taMax5 = taMax5
        self.taMin6 = taMin6
        self.taMax6 = taMax6
        self.taMin7 = taMin7
        self.taMax7 = taMax7
        self.taMin8 = taMin8
        self.taMax8 = taMax8
        self.taMin9 = taMin9
        self.taMax9 = taMax9
        self.taMin10 = taMin10
        self.taMax10 = taMax10
    }
    
    public let regId: String
    public let taMin5: Int
    public let taMax5: Int
    public let taMin6: Int
    public let taMax6: Int
    public let taMin7: Int
    public let taMax7: Int
    public let taMin8: Int
    public let taMax8: Int
    public let taMin9: Int
    public let taMax9: Int
    public let taMin10: Int
    public let taMax10: Int
}
