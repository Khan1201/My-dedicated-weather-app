//
//  RealTimeFindDustForecastReq.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 10/22/23.
//

import Foundation

struct RealTimeFindDustForecastReq: Encodable {
    
    let serviceKey: String = Env.shared.openDataApiResponseKey
    let returnType: String = "JSON"
    let numOfRows: String = "100"
    let pageNo: String = "1"
    let stationName: String
    let dataTerm: String = "DAILY"
    let ver: String = "1.0"
    
    enum CodingKeys: String, CodingKey {
        case serviceKey,
             returnType,
             numOfRows,
             pageNo,
             stationName,
             dataTerm,
             ver
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(serviceKey, forKey: .serviceKey)
        try container.encode(returnType, forKey: .returnType)
        try container.encode(numOfRows, forKey: .numOfRows)
        try container.encode(pageNo, forKey: .pageNo)
        try container.encode(stationName, forKey: .stationName)
        try container.encode(dataTerm, forKey: .dataTerm)
        try container.encode(ver, forKey: .ver)
    }
}
