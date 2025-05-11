//
//  DustForecastStationReq.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 10/22/23.
//

import Foundation

struct DustForecastStationReq: Encodable {
    let serviceKey: String
    let returnType: String = "json"
    let tmX: String
    let tmY: String
    let ver: String = "1.1"
}
