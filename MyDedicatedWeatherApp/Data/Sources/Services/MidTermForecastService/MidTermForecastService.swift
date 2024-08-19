//
//  MidTermForecastService.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 3/13/24.
//

import Foundation
import Core
import Domain

public protocol MidtermForecastRequestable {
    func requestMidTermForecastTempItems(serviceKey: String, fullAddress: String) async -> Result<PublicDataRes<MidTermForecastTemperatureBase>, APIError>
    
    func requestMidTermForecastSkyStateItems(serviceKey: String, fullAddress: String) async -> Result<PublicDataRes<MidTermForecastSkyStateBase>, APIError>
}

public struct MidTermForecastService: MidtermForecastRequestable {
    private let util: MidTermForecastUtil
    
    public init(util: MidTermForecastUtil = MidTermForecastUtil()) {
        self.util = util
    }
    
    public func requestMidTermForecastTempItems(serviceKey: String, fullAddress: String) async -> Result<PublicDataRes<MidTermForecastTemperatureBase>, APIError> {
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
            resultType: PublicDataRes<MidTermForecastTemperatureBase>.self
        )
        
        return result
    }
    
    public func requestMidTermForecastSkyStateItems(serviceKey: String, fullAddress: String) async -> Result<PublicDataRes<MidTermForecastSkyStateBase>, APIError> {
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
            resultType: PublicDataRes<MidTermForecastSkyStateBase>.self
        )
        
        return result
    }
}
