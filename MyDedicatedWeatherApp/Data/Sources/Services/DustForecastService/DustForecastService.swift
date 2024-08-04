//
//  DustForecastService.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 3/17/24.
//

import Foundation
import Core
import Domain

public protocol DustForecastRequestable {
    func requestDustForecastStationXY(subLocality: String) async -> Result<PublicDataRes<DustForecastStationXYBase>, APIError>
    func requestDustForecastStation(tmXAndtmY: (String, String)) async -> Result<PublicDataRes<DustForecastStationBase>, APIError>
    func requestRealTimeFindDustForecastItems(stationName: String) async -> Result<PublicDataRes<RealTimeFindDustForecastBase>, APIError>
}

public struct DustForecastService: DustForecastRequestable {
    
    public init() {}
    
    public func requestDustForecastStationXY(subLocality: String) async -> Result<PublicDataRes<DustForecastStationXYBase>, APIError> {
        let parameters: DustForecastStationXYReq = DustForecastStationXYReq(
            umdName: subLocality
        )
        
        let result = await ApiRequester.request(
            url: Route.GET_DUST_FORECAST_STATION_XY.val,
            method: .get,
            parameters: parameters,
            headers: nil,
            resultType: PublicDataRes<DustForecastStationXYBase>.self
        )
        
        return result
    }
    
    public func requestDustForecastStation(tmXAndtmY: (String, String)) async -> Result<PublicDataRes<DustForecastStationBase>, APIError> {
        let parameters: DustForecastStationReq = DustForecastStationReq(
            tmX: tmXAndtmY.0,
            tmY: tmXAndtmY.1
        )
        
        let result = await ApiRequester.request(
            url: Route.GET_DUST_FORECAST_STATION.val,
            method: .get,
            parameters: parameters,
            headers: nil,
            resultType: PublicDataRes<DustForecastStationBase>.self
        )
        
        return result
    }
    
    public func requestRealTimeFindDustForecastItems(stationName: String) async -> Result<PublicDataRes<RealTimeFindDustForecastBase>, APIError> {
        let parameters: RealTimeFindDustForecastReq = RealTimeFindDustForecastReq(
            stationName: stationName
        )
        
        let result = await ApiRequester.request(
            url: Route.GET_REAL_TIME_FIND_DUST_FORECAST.val,
            method: .get,
            parameters: parameters,
            headers: nil,
            resultType: PublicDataRes<RealTimeFindDustForecastBase>.self
        )
        
        return result
    }
}
