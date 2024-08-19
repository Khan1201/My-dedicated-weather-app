//
//  VeryShortOrShortTermForecastReq.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 10/22/23.
//

import Foundation

public struct VeryShortOrShortTermForecastReq: Encodable {
    public let serviceKey: String
    public let pageNo: String = "1"
    public let numOfRows: String
    public let dataType: String = "JSON"
    public let baseDate: String
    public let baseTime: String
    public let nx: String
    public let ny: String
    
    public init(serviceKey: String, numOfRows: String, baseDate: String, baseTime: String, nx: String, ny: String) {
        self.serviceKey = serviceKey
        self.numOfRows = numOfRows
        self.baseDate = baseDate
        self.baseTime = baseTime
        self.nx = nx
        self.ny = ny
    }
    
    enum CodingKeys: String, CodingKey {
        case serviceKey, pageNo,
             numOfRows, dataType,
             baseDate = "base_date",
             baseTime = "base_time",
             nx, ny
    }
    
    public func encode(to encoder: Encoder) throws {
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
