//
//  DustForecastStation.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/06/18.
//

import Foundation

public struct DustForecastStation: Decodable {
    public init(addr: String, stationName: String) {
        self.addr = addr
        self.stationName = stationName
    }
    
    public let addr: String
    public let stationName: String
}
