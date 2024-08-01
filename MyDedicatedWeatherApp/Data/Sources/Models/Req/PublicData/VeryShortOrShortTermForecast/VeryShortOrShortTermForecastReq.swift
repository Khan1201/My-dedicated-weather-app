//
//  VeryShortOrShortTermForecastReq.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 10/22/23.
//

import Foundation

struct VeryShortOrShortTermForecastReq: Encodable {
    let serviceKey: String = Env.shared.openDataApiResponseKey
    let pageNo: String = "1"
    let numOfRows: String
    let dataType: String = "JSON"
    let baseDate: String
    let baseTime: String
    let nx: String
    let ny: String
    
    enum CodingKeys: String, CodingKey {
        case serviceKey, pageNo,
             numOfRows, dataType,
             baseDate = "base_date",
             baseTime = "base_time",
             nx, ny
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(serviceKey, forKey: .serviceKey)
        try container.encode(pageNo, forKey: .pageNo)
        try container.encode(numOfRows, forKey: .numOfRows)
        try container.encode(dataType, forKey: .dataType)
        try container.encode(baseDate, forKey: .baseDate)
        try container.encode(baseTime, forKey: .baseTime)
        try container.encode(nx, forKey: .nx)
        try container.encode(ny, forKey: .ny)
    }
}
