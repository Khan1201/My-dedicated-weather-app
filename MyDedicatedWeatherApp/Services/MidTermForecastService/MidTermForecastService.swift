//
//  MidTermForecastService.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 3/13/24.
//

import Foundation

protocol MidtermForecastRequestable {
    func requestMidTermForecastTempItems(fullAddress: String) async -> Result<PublicDataRes<MidTermForecastTemperatureBase>, APIError>
    
    func requestMidTermForecastSkyStateItems(fullAddress: String) async -> Result<PublicDataRes<MidTermForecastSkyStateBase>, APIError>
}

struct MidTermForecastService: MidtermForecastRequestable {
    private let util: MidTermForecastUtil
    
    init(util: MidTermForecastUtil = MidTermForecastUtil()) {
        self.util = util
    }
    
    func requestMidTermForecastTempItems(fullAddress: String) async -> Result<PublicDataRes<MidTermForecastTemperatureBase>, APIError> {
        let parameters: MidTermForecastReq = MidTermForecastReq(
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
    
    func requestMidTermForecastSkyStateItems(fullAddress: String) async -> Result<PublicDataRes<MidTermForecastSkyStateBase>, APIError> {
        let parameters: MidTermForecastReq = MidTermForecastReq(
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
