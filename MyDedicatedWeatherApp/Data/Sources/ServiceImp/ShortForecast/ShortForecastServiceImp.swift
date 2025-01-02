//
//  ShortForecastServiceImp.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 3/13/24.
//

import Foundation
import Core
import Domain

public struct ShortForecastServiceImp: ShortForecastService {
    public init() {}
    
    public func getTodayItems(xy: Gps2XY.LatXLngY, reqRow: String) async -> Result<[VeryShortOrShortTermForecast<ShortTermForecastCategory>], APIError> {
        let parameters = VeryShortOrShortTermForecastReq(
            serviceKey: APIKey.publicApiKey,
            numOfRows: reqRow,
            baseDate: ReqParameters.shortForecastBaseDate,
            baseTime: ReqParameters.shortForecastBaseTime,
            nx: String(xy.x),
            ny: String(xy.y)
        )
        
        let result = await ApiRequester.request(
            url: Route.GET_WEATHER_SHORT_TERM_FORECAST.val,
            method: .get,
            parameters: parameters,
            headers: nil,
            resultType: PublicDataRes<VeryShortOrShortTermForecast<ShortTermForecastCategory>>.self
        )
        return result.map { $0.item ?? [] }
    }
    
    public func getTodayMinMaxItems(xy: Gps2XY.LatXLngY) async -> Result<[VeryShortOrShortTermForecast<ShortTermForecastCategory>], APIError> {
        let parameters = VeryShortOrShortTermForecastReq(
            serviceKey: APIKey.publicApiKey,
            numOfRows: "300",
            baseDate: ReqParameters.veryShortForecastBaseDate,
            baseTime: ReqParameters.veryShortForecastBaseTime,
            nx: String(xy.x),
            ny: String(xy.y)
        )
        
        let result = await ApiRequester.request(
            url: Route.GET_WEATHER_SHORT_TERM_FORECAST.val,
            method: .get,
            parameters: parameters,
            headers: nil,
            resultType: PublicDataRes<VeryShortOrShortTermForecast<ShortTermForecastCategory>>.self
        )
        return result.map { $0.item ?? [] }
    }
}
