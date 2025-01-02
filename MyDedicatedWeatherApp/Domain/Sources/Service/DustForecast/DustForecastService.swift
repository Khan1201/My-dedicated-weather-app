//
//  DustForecastService.swift
//
//
//  Created by 윤형석 on 12/12/24.
//

import Foundation

public protocol DustForecastService {
    func getXYOfStation(subLocality: String) async -> Result<[DustForecastStationXY], APIError>
    func getStationInfo(tmXAndtmY: (String, String)) async -> Result<[DustForecastStation], APIError>
    func getRealTimeDustItems(stationName: String) async -> Result<[RealTimeFindDustForecast], APIError>
}
