//
//  VeryShortForecastService.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 3/13/24.
//

import Foundation

public protocol VeryShortForecastService {
    func getCurrentItems(xy: Gps2XY.LatXLngY) async -> Result<[VeryShortOrShortTermForecast<VeryShortTermForecastCategory>], APIError>
}
