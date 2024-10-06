//
//  MidTermForecastSkyState.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/08/09.
//

import Foundation

public struct MidTermForecastSkyState: Decodable {
    public let rnSt3Am: Int // 강수 확률
    public let rnSt4Am: Int
    public let rnSt5Am: Int
    public let rnSt6Am: Int
    public let rnSt7Am: Int
    public let rnSt8: Int
    public let rnSt9: Int
    public let rnSt10: Int
    public let wf3Am: String // 하늘 상태 정보
    public let wf4Am: String
    public let wf5Am: String
    public let wf6Am: String
    public let wf7Am: String
    public let wf8: String
    public let wf9: String
    public let wf10: String
    
    enum CodingKeys: String, CodingKey {
        case rnSt3Am,
             rnSt4Am,
             rnSt5Am,
             rnSt6Am,
             rnSt7Am,
             rnSt8,
             rnSt9,
             rnSt10,
             wf3Am,
             wf4Am,
             wf5Am,
             wf6Am,
             wf7Am,
             wf8,
             wf9,
             wf10
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rnSt3Am = try container.decode(Int.self, forKey: .rnSt3Am)
        self.rnSt4Am = try container.decode(Int.self, forKey: .rnSt4Am)
        self.rnSt5Am = try container.decode(Int.self, forKey: .rnSt5Am)
        self.rnSt6Am = try container.decode(Int.self, forKey: .rnSt6Am)
        self.rnSt7Am = try container.decode(Int.self, forKey: .rnSt7Am)
        self.rnSt8 = try container.decode(Int.self, forKey: .rnSt8)
        self.rnSt9 = try container.decode(Int.self, forKey: .rnSt9)
        self.rnSt10 = try container.decode(Int.self, forKey: .rnSt10)
        self.wf3Am = try container.decode(String.self, forKey: .wf3Am)
        self.wf4Am = try container.decode(String.self, forKey: .wf4Am)
        self.wf5Am = try container.decode(String.self, forKey: .wf5Am)
        self.wf6Am = try container.decode(String.self, forKey: .wf6Am)
        self.wf7Am = try container.decode(String.self, forKey: .wf7Am)
        self.wf8 = try container.decode(String.self, forKey: .wf8)
        self.wf9 = try container.decode(String.self, forKey: .wf9)
        self.wf10 = try container.decode(String.self, forKey: .wf10)
    }
}
