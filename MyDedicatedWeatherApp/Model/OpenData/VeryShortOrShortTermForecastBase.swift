//
//  VeryShortOrShortTermForecastBase.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/05/03.
//

import Foundation

struct VeryShortOrShortTermForecastBase<T: Decodable>: Decodable {
    
    let baseDate: String
    let baseTime: String
    let category: T
    let fcstDate: String
    let fcstTime: String
    let fcstValue: String
    
    enum CodingKeys: String, CodingKey {
        
        case baseDate, baseTime, category,
             fcstDate, fcstTime, fcstValue
    }
}

extension VeryShortOrShortTermForecastBase {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.baseDate = try container.decode(String.self, forKey: .baseDate)
        self.baseTime = try container.decode(String.self, forKey: .baseTime)
        self.category = try container.decode(T.self, forKey: .category)
        self.fcstDate = try container.decode(String.self, forKey: .fcstDate)
        self.fcstTime = try container.decode(String.self, forKey: .fcstTime)
        self.fcstValue = try container.decode(String.self, forKey: .fcstValue)
    }
}

// MARK: - Relation ..

struct VeryShortOrShortTermForecastReq: Encodable {
    let serviceKey: String
    let pageNo: String = "1"
    let numOfRows: String = "1000"
    let dataType: String = "JSON"
    let baseDate: String
    let baseTime: String
    let nx: String
    let ny: String
    
    enum CodingKeys: String, CodingKey {
        case serviceKey, pageNo,
             numOfRows, dataType,
             baseDate = "base_date",
             baseTime = "base_time",
             nx, ny
    }
    
    func encode(to encoder: Encoder) throws {
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

enum VeryShortTermForecastCategory: String, Codable {
    
    case T1H, // 기온
         RN1, // 1시간 강수량
         PTY, // 강수 형태
         SKY, // 하늘 상태
         REH, // 습도
         WSD,// 풍속
         UUU, // 동서 바람 성분 (사용 x)
         VVV, // 남북 바람 성분 (사용 x),
         LGT, // 낙뢰 (사용 x)
         VEC // 풍향 (사용 x)
}

enum ShortTermForecastCategory: String, Codable {
    
    case POP, // 강수 확률
         PTY, // 강수 형태
         PCP, // 1시간 강수량
         REH, // 습도
         SNO, // 1시간 신적설 (사용 x)
         SKY, // 하늘상태
         TMP, // 1시간 기온
         TMN, // 일 최저기온
         TMX, // 일 최고기온
         UUU, // 동서 바람 성분 (사용 x)
         VVV, // 남북 바람 성분 (사용 x),
         WAV, // 파고 (사용 x)
         VEC, // 풍향 (사용 x)
         WSD // 풍속

}

struct TodayWeatherInformationBase {
    
    let weatherImage: String
    let time: String
    let temperature: String
}

struct CurrentWeatherInformationBase {
    
    let temperature: String
    let windSpeed: String
    let wetPercent: String
    let oneHourPrecipitation: String
    let weatherImage: String
}
