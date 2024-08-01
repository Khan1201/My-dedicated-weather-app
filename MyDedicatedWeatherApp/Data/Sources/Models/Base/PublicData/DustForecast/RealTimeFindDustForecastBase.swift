//
//  RealTimeFindDustForecastBase.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/05/14.
//

import Foundation

struct RealTimeFindDustForecastBase: Encodable {
    let pm10Value: String
    let pm25Value: String
    
    enum CodingKeys: String, CodingKey {
        
        case pm10Value,
            pm25Value
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(pm10Value, forKey: .pm10Value)
        try container.encode(pm25Value, forKey: .pm25Value)
    }
}

extension RealTimeFindDustForecastBase: Decodable {
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.pm10Value = try container.decode(String.self, forKey: .pm10Value)
        self.pm25Value = try container.decode(String.self, forKey: .pm25Value)
    }
}
