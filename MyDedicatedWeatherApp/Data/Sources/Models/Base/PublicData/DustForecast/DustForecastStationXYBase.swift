//
//  DustForecastStationXYBase.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/06/18.
//

import Foundation

struct DustForecastStationXYBase: Decodable {
    
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
