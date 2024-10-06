//
//  ShortForecastService.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 3/13/24.
//

import Foundation
import Core
import Domain

public protocol ShortForecastRequestable {
    func requestShortForecastItems(serviceKey: String, xy: Gps2XY.LatXLngY, reqRow: String) async -> Result<PublicDataRes<VeryShortOrShortTermForecast<ShortTermForecastCategory>>, APIError>
    
    func requestTodayMinMaxTemp(serviceKey: String, xy: Gps2XY.LatXLngY) async -> Result<PublicDataRes<VeryShortOrShortTermForecast<ShortTermForecastCategory>>, APIError>
}

public struct ShortForecastService: ShortForecastRequestable {
    private let util: ShortTermForecastUtil
    
    public init(util: ShortTermForecastUtil = ShortTermForecastUtil()) {
        self.util = util
    }
    
    public func requestShortForecastItems(serviceKey: String, xy: Gps2XY.LatXLngY, reqRow: String) async -> Result<PublicDataRes<VeryShortOrShortTermForecast<ShortTermForecastCategory>>, APIError> {
        let parameters = VeryShortOrShortTermForecastReq(
            serviceKey: serviceKey,
            numOfRows: reqRow,
            baseDate: util.baseDatePar,
            baseTime: util.baseTimePar,
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
        
        return result
    }
    
    public func requestTodayMinMaxTemp(serviceKey: String, xy: Gps2XY.LatXLngY) async -> Result<PublicDataRes<VeryShortOrShortTermForecast<ShortTermForecastCategory>>, APIError> {
        let parameters = VeryShortOrShortTermForecastReq(
            serviceKey: serviceKey,
            numOfRows: "300",
            baseDate: util.baseDateForTodayMinMaxReq,
            baseTime: util.baseTimeForTodayMinMaxReq,
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
        
        return result
    }
}
