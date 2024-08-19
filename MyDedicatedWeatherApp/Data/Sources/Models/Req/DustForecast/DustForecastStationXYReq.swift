//
//  DustForecastStationXYReq.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 10/22/23.
//

import Foundation

struct DustForecastStationXYReq: Encodable {
    
    let serviceKey: String 
    let returnType: String = "json"
    let numOfRows: String = "100"
    let pageNo: String = "1"
    let umdName: String
    
    enum CodingKeys: String, CodingKey {
        case serviceKey, returnType, numOfRows, pageNo, umdName
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(serviceKey.self, forKey: .serviceKey)
        try container.encode(returnType.self, forKey: .returnType)
        try container.encode(numOfRows.self, forKey: .numOfRows)
        try container.encode(pageNo.self, forKey: .pageNo)
        try container.encode(umdName, forKey: .umdName)
    }
}
