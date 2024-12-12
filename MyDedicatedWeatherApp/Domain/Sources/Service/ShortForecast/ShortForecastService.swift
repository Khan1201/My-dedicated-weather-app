//
//  ShortForecastService.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 3/13/24.
//

import Foundation

public protocol ShortForecastService {
    func getTodayItems(serviceKey: String, xy: Gps2XY.LatXLngY, reqRow: String) async -> Result<[VeryShortOrShortTermForecast<ShortTermForecastCategory>], APIError>
    func getTodayMinMaxItems(serviceKey: String, xy: Gps2XY.LatXLngY) async -> Result<[VeryShortOrShortTermForecast<ShortTermForecastCategory>], APIError>
}
