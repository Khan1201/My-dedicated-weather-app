//
//  DustForecastStationXY.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/06/18.
//

import Foundation

public struct DustForecastStationXY: Decodable {
    public init(sggName: String, umdName: String, tmX: String, tmY: String, sidoName: String) {
        self.sggName = sggName
        self.umdName = umdName
        self.tmX = tmX
        self.tmY = tmY
        self.sidoName = sidoName
    }
    
    public let sggName: String
    public let umdName: String
    public let tmX: String
    public let tmY: String
    public let sidoName: String
}
