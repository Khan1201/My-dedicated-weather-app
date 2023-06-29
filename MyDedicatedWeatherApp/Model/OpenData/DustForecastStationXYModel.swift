//
//  DustForecastStationXYModel.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/06/18.
//

import Foundation

struct DustForecastStationXYModel: Decodable {
    
    let sggName: String
    let umdName: String
    let tmX: String
    let tmY: String
    let sidoName: String
    
    enum CodingKeys: CodingKey {
        case sggName
        case umdName
        case tmX
        case tmY
        case sidoName
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sggName = try container.decode(String.self, forKey: .sggName)
        self.umdName = try container.decode(String.self, forKey: .umdName)
        self.tmX = try container.decode(String.self, forKey: .tmX)
        self.tmY = try container.decode(String.self, forKey: .tmY)
        self.sidoName = try container.decode(String.self, forKey: .sidoName)
    }
}

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
