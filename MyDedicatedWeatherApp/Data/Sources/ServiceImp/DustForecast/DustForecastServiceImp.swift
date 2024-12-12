//
//  DustForecastServiceImp.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 3/17/24.
//

import Foundation
import Core
import Domain

public struct DustForecastServiceImp: DustForecastService {
    public init() {}
    
    public func getXYOfStation(serviceKey: String, subLocality: String) async -> Result<[DustForecastStationXY], APIError> {
        let parameters: DustForecastStationXYReq = DustForecastStationXYReq(
            serviceKey: serviceKey,
            umdName: subLocality
        )
        
        let result = await ApiRequester.request(
            url: Route.GET_DUST_FORECAST_STATION_XY.val,
            method: .get,
            parameters: parameters,
            headers: nil,
            resultType: PublicDataRes<DustForecastStationXY>.self
        )
        return result.map { $0.items ?? [] }
    }
    
    public func getStationInfo(serviceKey: String, tmXAndtmY: (String, String)) async -> Result<[DustForecastStation], APIError> {
        let parameters: DustForecastStationReq = DustForecastStationReq(
            serviceKey: serviceKey,
            tmX: tmXAndtmY.0,
            tmY: tmXAndtmY.1
        )
        
        let result = await ApiRequester.request(
            url: Route.GET_DUST_FORECAST_STATION.val,
            method: .get,
            parameters: parameters,
            headers: nil,
            resultType: PublicDataRes<DustForecastStation>.self
        )
        return result.map { $0.items ?? [] }
    }
    
    public func getRealTimeDustItems(serviceKey: String, stationName: String) async -> Result<[RealTimeFindDustForecast], APIError> {
        let parameters: RealTimeFindDustForecastReq = RealTimeFindDustForecastReq(
            serviceKey: serviceKey,
            stationName: stationName
        )
        
        let result = await ApiRequester.request(
            url: Route.GET_REAL_TIME_FIND_DUST_FORECAST.val,
            method: .get,
            parameters: parameters,
            headers: nil,
            resultType: PublicDataRes<RealTimeFindDustForecast>.self
        )
        return result.map { $0.items ?? [] }
    }
}
