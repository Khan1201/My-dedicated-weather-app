//
//  MidTermForecastTemperature.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/04/30.
//

import Foundation

public struct MidTermForecastTemperature {
    
    public init(regId: String, taMin4: Int, taMax4: Int, taMin5: Int, taMax5: Int, taMin6: Int, taMax6: Int, taMin7: Int, taMax7: Int, taMin8: Int, taMax8: Int, taMin9: Int, taMax9: Int, taMin10: Int, taMax10: Int) {
        self.regId = regId
        self.taMin4 = taMin4
        self.taMax4 = taMax4
        self.taMin5 = taMin5
        self.taMax5 = taMax5
        self.taMin6 = taMin6
        self.taMax6 = taMax6
        self.taMin7 = taMin7
        self.taMax7 = taMax7
        self.taMin8 = taMin8
        self.taMax8 = taMax8
        self.taMin9 = taMin9
        self.taMax9 = taMax9
        self.taMin10 = taMin10
        self.taMax10 = taMax10
    }
    
    public let regId: String
    public let taMin4: Int
    public let taMax4: Int
    public let taMin5: Int
    public let taMax5: Int
    public let taMin6: Int
    public let taMax6: Int
    public let taMin7: Int
    public let taMax7: Int
    public let taMin8: Int
    public let taMax8: Int
    public let taMin9: Int
    public let taMax9: Int
    public let taMin10: Int
    public let taMax10: Int
    
    enum CodingKeys: CodingKey {
        case regId
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

extension MidTermForecastTemperature: Decodable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.regId = try container.decode(String.self, forKey: .regId)
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
