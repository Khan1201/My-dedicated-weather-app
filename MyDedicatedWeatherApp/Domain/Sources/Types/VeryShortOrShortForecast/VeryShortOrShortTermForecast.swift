//
//  VeryShortOrShortTermForecast.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/05/03.
//

import Foundation

public struct VeryShortOrShortTermForecast<T: Decodable>: Decodable {
    
    public init(baseDate: String, baseTime: String, category: T, fcstDate: String, fcstTime: String, fcstValue: String) {
        self.baseDate = baseDate
        self.baseTime = baseTime
        self.category = category
        self.fcstDate = fcstDate
        self.fcstTime = fcstTime
        self.fcstValue = fcstValue
    }
    
    public let baseDate: String
    public let baseTime: String
    public let category: T
    public let fcstDate: String
    public let fcstTime: String
    public let fcstValue: String
    
    enum CodingKeys: String, CodingKey {
        
        case baseDate, baseTime, category,
             fcstDate, fcstTime, fcstValue
    }
}

extension VeryShortOrShortTermForecast {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.baseDate = try container.decode(String.self, forKey: .baseDate)
        self.baseTime = try container.decode(String.self, forKey: .baseTime)
        self.category = try container.decode(T.self, forKey: .category)
        self.fcstDate = try container.decode(String.self, forKey: .fcstDate)
        self.fcstTime = try container.decode(String.self, forKey: .fcstTime)
        self.fcstValue = try container.decode(String.self, forKey: .fcstValue)
    }
}
