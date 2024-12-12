//
//  DustForecastService.swift
//
//
//  Created by 윤형석 on 12/12/24.
//

import Foundation

public protocol DustForecastService {
    func getXYOfStation(serviceKey: String, subLocality: String) async -> Result<[DustForecastStationXY], APIError>
    func getStationInfo(serviceKey: String, tmXAndtmY: (String, String)) async -> Result<[DustForecastStation], APIError>
    func getRealTimeDustItems(serviceKey: String, stationName: String) async -> Result<[RealTimeFindDustForecast], APIError>
}
