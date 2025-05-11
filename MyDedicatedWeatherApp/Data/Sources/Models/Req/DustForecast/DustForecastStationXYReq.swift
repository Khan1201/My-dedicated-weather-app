//
//  DustForecastStationXYReq.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 10/22/23.
//

import Foundation

struct DustForecastStationXYReq: Encodable {
    let serviceKey: String 
    let returnType: String = "json"
    let numOfRows: String = "100"
    let pageNo: String = "1"
    let umdName: String
}
