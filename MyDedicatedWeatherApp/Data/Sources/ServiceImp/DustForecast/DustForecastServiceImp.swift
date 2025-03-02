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
    
    /**
     Request 미세먼지 측정소가 위치한 X, Y 좌표
     
     - parameter subLocality: ex) 성수동 1가
     - parameter locality: ex) 서울특별시
     */
    public func getXYOfStation(subLocality: String) async -> Result<[DustForecastStationXY], APIError> {
        let parameters: DustForecastStationXYReq = DustForecastStationXYReq(
            serviceKey: APIKey.publicApiKey,
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
    
    /**
     Request 미세먼지 측정소 이름
     - parameter tmxAndtmY: 미세먼지 측정소 X, Y 좌표
     */
    public func getStationInfo(tmXAndtmY: (String, String)) async -> Result<[DustForecastStation], APIError> {
        let parameters: DustForecastStationReq = DustForecastStationReq(
            serviceKey: APIKey.publicApiKey,
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
    
    public func getRealTimeDustItems(stationName: String) async -> Result<[RealTimeFindDustForecast], APIError> {
        let parameters: RealTimeFindDustForecastReq = RealTimeFindDustForecastReq(
            serviceKey: APIKey.publicApiKey,
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
