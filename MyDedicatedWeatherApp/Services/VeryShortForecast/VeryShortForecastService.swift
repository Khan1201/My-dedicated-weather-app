//
//  VeryShortForecastService.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 3/13/24.
//

import Foundation

protocol VeryShortForecastRequestable {
    func requestVeryShortForecastItems(xy: Gps2XY.LatXLngY) async -> Result<PublicDataRes<VeryShortOrShortTermForecastBase<VeryShortTermForecastCategory>>, APIError>
}

struct VeryShortForecastService: VeryShortForecastRequestable {
    private let veryShortTermForecastUtil: VeryShortTermForecastUtil = VeryShortTermForecastUtil()

    func requestVeryShortForecastItems(xy: Gps2XY.LatXLngY) async -> Result<PublicDataRes<VeryShortOrShortTermForecastBase<VeryShortTermForecastCategory>>, APIError>
    {
        let parameters: VeryShortOrShortTermForecastReq = VeryShortOrShortTermForecastReq(
            numOfRows: "300",
            baseDate: veryShortTermForecastUtil.requestBaseDate,
            baseTime: veryShortTermForecastUtil.requestBaseTime,
            nx: String(xy.x),
            ny: String(xy.y)
        )
        
        let result = await ApiRequester.request(
            url: Route.GET_WEATHER_VERY_SHORT_TERM_FORECAST.val,
            method: .get,
            parameters: parameters,
            headers: nil,
            resultType: PublicDataRes<VeryShortOrShortTermForecastBase<VeryShortTermForecastCategory>>.self
        )
        
        return result
    }
}
