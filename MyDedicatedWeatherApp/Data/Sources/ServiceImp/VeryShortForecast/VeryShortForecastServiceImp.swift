//
//  VeryShortForecastServiceImp.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 3/13/24.
//

import Foundation
import Core
import Domain

public struct VeryShortForecastServiceImp: VeryShortForecastService {
    public init() { }

    public func getCurrentItems(xy: Gps2XY.LatXLngY) async -> Result<[VeryShortOrShortTermForecast<VeryShortTermForecastCategory>], APIError>
    {
        let parameters: VeryShortOrShortTermForecastReq = VeryShortOrShortTermForecastReq(
            serviceKey: APIKey.publicApiKey,
            numOfRows: "300",
            baseDate: ReqParameters.veryShortForecastBaseDate,
            baseTime: ReqParameters.veryShortForecastBaseTime,
            nx: String(xy.x),
            ny: String(xy.y)
        )
        
        let result = await ApiRequester.request(
            url: Route.GET_WEATHER_VERY_SHORT_TERM_FORECAST.val,
            method: .get,
            parameters: parameters,
            headers: nil,
            resultType: PublicDataRes<VeryShortOrShortTermForecast<VeryShortTermForecastCategory>>.self
        )
        return result.map { $0.item ?? [] }
    }
}
