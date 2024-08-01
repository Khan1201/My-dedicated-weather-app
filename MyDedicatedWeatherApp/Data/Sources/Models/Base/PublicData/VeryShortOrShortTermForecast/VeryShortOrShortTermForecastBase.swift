//
//  VeryShortOrShortTermForecastBase.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/05/03.
//

import Foundation

struct VeryShortOrShortTermForecastBase<T: Decodable>: Decodable {
    
    let baseDate: String
    let baseTime: String
    let category: T
    let fcstDate: String
    let fcstTime: String
    let fcstValue: String
    
    enum CodingKeys: String, CodingKey {
        
        case baseDate, baseTime, category,
             fcstDate, fcstTime, fcstValue
    }
}

extension VeryShortOrShortTermForecastBase {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.baseDate = try container.decode(String.self, forKey: .baseDate)
        self.baseTime = try container.decode(String.self, forKey: .baseTime)
        self.category = try container.decode(T.self, forKey: .category)
        self.fcstDate = try container.decode(String.self, forKey: .fcstDate)
        self.fcstTime = try container.decode(String.self, forKey: .fcstTime)
        self.fcstValue = try container.decode(String.self, forKey: .fcstValue)
    }
}
