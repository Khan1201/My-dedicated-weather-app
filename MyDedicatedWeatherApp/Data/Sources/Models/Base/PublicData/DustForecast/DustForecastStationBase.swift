//
//  DustForecastStationBase.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/06/18.
//

import Foundation

struct DustForecastStationBase: Codable {
    
    let addr: String
    let stationName: String
    
    enum CodingKeys: String, CodingKey {
        case addr, stationName
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(addr, forKey: .addr)
        try container.encode(stationName, forKey: .stationName)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.addr = try container.decode(String.self, forKey: .addr)
        self.stationName = try container.decode(String.self, forKey: .stationName)
    }
}
