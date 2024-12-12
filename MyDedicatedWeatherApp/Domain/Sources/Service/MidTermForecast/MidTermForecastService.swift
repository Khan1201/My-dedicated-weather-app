//
//  MidTermForecastService.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 3/13/24.
//

import Foundation

public protocol MidtermForecastService {
    func getTempItems(serviceKey: String, fullAddress: String) async -> Result<[MidTermForecastTemperature], APIError>
    func getSkyStateItems(serviceKey: String, fullAddress: String) async -> Result<[MidTermForecastSkyState], APIError>
}
