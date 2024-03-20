//
//  VeryShortForecastServiceMock.swift
//  MyDedicatedWeatherUnitTests
//
//  Created by 윤형석 on 3/20/24.
//

import Foundation
@testable import MyDedicatedWeatherApp

struct EmptyParameter: Encodable {
    
}

struct VeryShortForecastServiceMock: VeryShortForecastRequestable {
    let result: Data
    
    func requestVeryShortForecastItems(
        xy: MyDedicatedWeatherApp.Gps2XY.LatXLngY) async -> Result<MyDedicatedWeatherApp.PublicDataRes<MyDedicatedWeatherApp.VeryShortOrShortTermForecastBase<MyDedicatedWeatherApp.VeryShortTermForecastCategory>>, MyDedicatedWeatherApp.APIError> {
            ApiRequesterMock.jsonResult = result
            
            return await ApiRequesterMock.request(
                url: "",
                method: .get,
                parameters: EmptyParameter(),
                headers: nil,
                resultType: PublicDataRes<VeryShortOrShortTermForecastBase<VeryShortTermForecastCategory>>.self
            )
    }
}
