//
//  MidTermForecastServiceImp.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 3/13/24.
//

import Foundation
import Core
import Domain

public struct MidTermForecastServiceImp: MidtermForecastService {
    private let util: MidTermForecastUtil
    
    public init(util: MidTermForecastUtil = MidTermForecastUtil()) {
        self.util = util
    }
    
    public func getTempItems(serviceKey: String, fullAddress: String) async -> Result<[MidTermForecastTemperature], APIError> {
        let parameters: MidTermForecastReq = MidTermForecastReq(
            serviceKey: serviceKey,
            regId: util.regOrStnIdPar(fullAddress: fullAddress, reqType: .temperature),
            stnId: nil,
            tmFc: util.tmFcPar
        )
        
        let result = await ApiRequester.request(
            url: Route.GET_WEATHER_MID_TERM_FORECAST_TEMP.val,
            method: .get,
            parameters: parameters,
            headers: nil,
            resultType: PublicDataRes<MidTermForecastTemperature>.self
        )
        return result.map { $0.items ?? [] }
    }
    
    public func getSkyStateItems(serviceKey: String, fullAddress: String) async -> Result<[MidTermForecastSkyState], APIError> {
        let parameters: MidTermForecastReq = MidTermForecastReq(
            serviceKey: serviceKey,
            regId: util.regOrStnIdPar(fullAddress: fullAddress, reqType: .skystate),
            stnId: nil,
            tmFc: util.tmFcPar
        )
        
        let result = await ApiRequester.request(
            url: Route.GET_WEATHER_MID_TERM_FORECAST_SKYSTATE.val,
            method: .get,
            parameters: parameters,
            headers: nil,
            resultType: PublicDataRes<MidTermForecastSkyState>.self
        )
        return result.map { $0.items ?? [] }
    }
}
