//
//  SunOrMoonRiseBase.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/07/02.
//

import Foundation

struct SunAndMoonriseBase: Decodable {
    var sunrise: String
    var sunset: String
    var moonrise: String
    var moonset: String 
    
    enum TagType: String, CaseIterable {
        case sunrise, sunset, moonrise, moonset, none
    }
}
