//
//  RealTimeFindDustForecastReq.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 10/22/23.
//

import Foundation

public struct RealTimeFindDustForecastReq: Encodable {
    
    public let serviceKey: String
    public let returnType: String = "JSON"
    public let numOfRows: String = "100"
    public let pageNo: String = "1"
    public let stationName: String
    public let dataTerm: String = "DAILY"
    public let ver: String = "1.0"
    
    public init(serviceKey: String, stationName: String) {
        self.serviceKey = serviceKey
        self.stationName = stationName
    }
    
    enum CodingKeys: String, CodingKey {
        case serviceKey,
             returnType,
             numOfRows,
             pageNo,
             stationName,
             dataTerm,
             ver
    }
    
    public func encode(to encoder: Encoder) throws {
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
