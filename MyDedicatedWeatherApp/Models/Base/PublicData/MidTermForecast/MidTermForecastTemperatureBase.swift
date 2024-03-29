//
//  MidTermForecastTemperatureBase.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/04/30.
//

import Foundation

struct MidTermForecastTemperatureBase {
    
    let regId: String
    let taMin3: Int
    let taMax3: Int
    let taMin4: Int
    let taMax4: Int
    let taMin5: Int
    let taMax5: Int
    let taMin6: Int
    let taMax6: Int
    let taMin7: Int
    let taMax7: Int
    let taMin8: Int
    let taMax8: Int
    let taMin9: Int
    let taMax9: Int
    let taMin10: Int
    let taMax10: Int
    
    enum CodingKeys: CodingKey {
        case regId
        case taMin3
        case taMax3
        case taMin4
        case taMax4
        case taMin5
        case taMax5
        case taMin6
        case taMax6
        case taMin7
        case taMax7
        case taMin8
        case taMax8
        case taMin9
        case taMax9
        case taMin10
        case taMax10
    }
}

extension MidTermForecastTemperatureBase: Decodable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.regId = try container.decode(String.self, forKey: .regId)
        self.taMin3 = try container.decode(Int.self, forKey: .taMin3)
        self.taMax3 = try container.decode(Int.self, forKey: .taMax3)
        self.taMin4 = try container.decode(Int.self, forKey: .taMin4)
        self.taMax4 = try container.decode(Int.self, forKey: .taMax4)
        self.taMin5 = try container.decode(Int.self, forKey: .taMin5)
        self.taMax5 = try container.decode(Int.self, forKey: .taMax5)
        self.taMin6 = try container.decode(Int.self, forKey: .taMin6)
        self.taMax6 = try container.decode(Int.self, forKey: .taMax6)
        self.taMin7 = try container.decode(Int.self, forKey: .taMin7)
        self.taMax7 = try container.decode(Int.self, forKey: .taMax7)
        self.taMin8 = try container.decode(Int.self, forKey: .taMin8)
        self.taMax8 = try container.decode(Int.self, forKey: .taMax8)
        self.taMin9 = try container.decode(Int.self, forKey: .taMin9)
        self.taMax9 = try container.decode(Int.self, forKey: .taMax9)
        self.taMin10 = try container.decode(Int.self, forKey: .taMin10)
        self.taMax10 = try container.decode(Int.self, forKey: .taMax10)
    }
}
