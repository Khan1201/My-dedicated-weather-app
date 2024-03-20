//
//  VeryShortForecastUtilMock.swift
//  MyDedicatedWeatherUnitTests
//
//  Created by 윤형석 on 3/20/24.
//

import Foundation
@testable import MyDedicatedWeatherApp

struct VeryShortForecastUtilMock: VeryShortForecastRequestParam {
    var requestBaseTime: String
    var requestBaseDate: String
}
