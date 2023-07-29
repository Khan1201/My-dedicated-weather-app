//
//  Route.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/04/30.
//

import Foundation

enum Route {
    
    case GET_WEATHER_MID_TERM_FORECAST,
        GET_WEATHER_SHORT_TERM_FORECAST,
        GET_WEATHER_VERY_SHORT_TERM_FORECAST,
        GET_REAL_TIME_FIND_DUST_FORECAST,
        GET_DUST_FORECAST_STATION_XY,
        GET_DUST_FORECAST_STATION,
        GET_KAKAO_ADDRESS,
        GET_SUNRISE_SUNSET_TEMPERATURE
    
    var val: String {
        
        switch self {
        
        case .GET_WEATHER_SHORT_TERM_FORECAST:
            return "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst"
        
        case .GET_WEATHER_MID_TERM_FORECAST:
            return "https://apis.data.go.kr/1360000/MidFcstInfoService/getMidTa"
            
        case .GET_WEATHER_VERY_SHORT_TERM_FORECAST:
            return "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtFcst"
            
        case .GET_REAL_TIME_FIND_DUST_FORECAST:
            return "https://apis.data.go.kr/B552584/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty"
            
        case .GET_DUST_FORECAST_STATION_XY:
            return "https://apis.data.go.kr/B552584/MsrstnInfoInqireSvc/getTMStdrCrdnt"
            
        case .GET_DUST_FORECAST_STATION:
            return "https://apis.data.go.kr/B552584/MsrstnInfoInqireSvc/getNearbyMsrstnList"
            
        case .GET_KAKAO_ADDRESS:
            return "https://dapi.kakao.com/v2/local/geo/coord2address.json"
            
        case .GET_SUNRISE_SUNSET_TEMPERATURE:
            return "https://apis.data.go.kr/B090041/openapi/service/RiseSetInfoService/getLCRiseSetInfo"
            
        }
    }
}
