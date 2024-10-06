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
    func requestDustForecastStationXY(serviceKey: String, subLocality: String) async -> Result<PublicDataRes<DustForecastStationXY>, APIError>
    func requestDustForecastStation(serviceKey: String, tmXAndtmY: (String, String)) async -> Result<PublicDataRes<DustForecastStation>, APIError>
    func requestRealTimeFindDustForecastItems(serviceKey: String, stationName: String) async -> Result<PublicDataRes<RealTimeFindDustForecast>, APIError>
}

public struct DustForecastService: DustForecastRequestable {
    
    public init() {}
    
    public func requestDustForecastStationXY(serviceKey: String, subLocality: String) async -> Result<PublicDataRes<DustForecastStationXY>, APIError> {
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
        
        return result
    }
    
    public func requestDustForecastStation(serviceKey: String, tmXAndtmY: (String, String)) async -> Result<PublicDataRes<DustForecastStation>, APIError> {
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
        
        return result
    }
    
    public func requestRealTimeFindDustForecastItems(serviceKey: String, stationName: String) async -> Result<PublicDataRes<RealTimeFindDustForecast>, APIError> {
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
        
        return result
    }
}
