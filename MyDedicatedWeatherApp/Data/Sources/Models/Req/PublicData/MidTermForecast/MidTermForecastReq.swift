//
//  MidTermForecastReq.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 10/22/23.
//

import Foundation

public struct MidTermForecastReq: Encodable {
    public init(serviceKey: String, regId: String?, stnId: String?, tmFc: String) {
        self.serviceKey = serviceKey
        self.regId = regId
        self.stnId = stnId
        self.tmFc = tmFc
    }
    
    public let serviceKey: String
    public let pageNo: Int = 1
    public let numOfRows: Int = 10
    public let dataType: String = "JSON"
    public let regId: String? // For 중기 기온, 중기 육상 예보
    public let stnId: String? // For 중기 전망
    public let tmFc: String
}
