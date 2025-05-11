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
}
