//
//  SunOrMoonTimeReq.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 10/22/23.
//

import Foundation

struct SunOrMoonTimeReq: Encodable {
    let serviceKey: String
    let locdate: String
    let longitude: String
    let latitude: String
    let dnYn: String = "Y"
    
    enum CodingKeys: String, CodingKey {
        case serviceKey, locdate, longitude, latitude, dnYn
    }
        
    func encode(to encoder: Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(serviceKey, forKey: .serviceKey)
        try container.encode(locdate, forKey: .locdate)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(dnYn, forKey: .dnYn)
    }
}
