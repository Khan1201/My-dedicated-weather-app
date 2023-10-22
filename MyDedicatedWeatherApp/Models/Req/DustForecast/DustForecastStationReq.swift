//
//  DustForecastStationReq.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 10/22/23.
//

import Foundation

struct DustForecastStationReq: Encodable {
    
    let serviceKey: String
    let returnType: String = "json"
    let tmX: String
    let tmY: String
    let ver: String = "1.1"
    
    enum CodingKeys: String, CodingKey {
        case serviceKey, returnType, tmX, tmY, ver
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(serviceKey, forKey: .serviceKey)
        try container.encode(returnType, forKey: .returnType)
        try container.encode(tmX, forKey: .tmX)
        try container.encode(tmY, forKey: .tmY)
        try container.encode(ver, forKey: .ver)
    }
}
