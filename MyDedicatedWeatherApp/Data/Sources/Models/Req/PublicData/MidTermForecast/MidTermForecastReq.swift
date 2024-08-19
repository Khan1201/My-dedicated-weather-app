//
//  MidTermForecastReq.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 10/22/23.
//

import Foundation

public struct MidTermForecastReq: Encodable {
    
    public let serviceKey: String
    public let pageNo: Int = 1
    public let numOfRows: Int = 10
    public let dataType: String = "JSON"
    public let regId: String? // For 중기 기온, 중기 육상 예보
    public let stnId: String? // For 중기 전망
    public let tmFc: String
    
    public init(serviceKey: String, regId: String?, stnId: String?, tmFc: String) {
        self.serviceKey = serviceKey
        self.regId = regId
        self.stnId = stnId
        self.tmFc = tmFc
    }
    
    enum Codingkeys: String, CodingKey {
        case serviceKey, pageNo, numOfRows, dataType, regId, stnId, tmFc
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Codingkeys.self)
        try container.encode(serviceKey, forKey: .serviceKey)
        try container.encode(pageNo, forKey: .pageNo)
        try container.encode(numOfRows, forKey: .numOfRows)
        try container.encode(dataType, forKey: .dataType)
        try container.encodeIfPresent(regId, forKey: .regId)
        try container.encodeIfPresent(stnId, forKey: .stnId)
        try container.encode(tmFc, forKey: .tmFc)
    }
}
