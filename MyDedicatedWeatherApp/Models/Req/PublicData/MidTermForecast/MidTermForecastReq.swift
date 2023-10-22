//
//  MidTermForecastReq.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 10/22/23.
//

import Foundation

struct MidTermForecastReq: Encodable {
    
    let serviceKey: String
    let pageNo: Int = 1
    let numOfRows: Int = 10
    let dataType: String = "JSON"
    let regId: String? // For 중기 기온, 중기 육상 예보
    let stnId: String? // For 중기 전망
    let tmFc: String
    
    enum Codingkeys: String, CodingKey {
        case serviceKey, pageNo, numOfRows, dataType, regId, stnId, tmFc
    }
    
    func encode(to encoder: Encoder) throws {
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
