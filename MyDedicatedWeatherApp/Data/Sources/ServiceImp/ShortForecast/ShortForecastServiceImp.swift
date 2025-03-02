//
//  ShortForecastServiceImp.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 3/13/24.
//

import Foundation
import Core
import Domain

public struct ShortForecastServiceImp: ShortForecastService {
    public init() {}
    
    /**
     Request 단기예보 Items
     - parameter xy: 공공데이터 값으로 변환된 X, Y
     
     Response:
     - 1시간 별 데이터 12개 (13:00 -> 12개, 14:00 -> 12개)
     - 요청 basetime 별 response 값이 다름
     
     시간 별 Index:
     - 0: TMP (온도)
     - 1: UUU (풍속 동서성분)
     - 2: VVV (풍속 남북성분)
     - 3: VEC (풍향)
     - 4: WSD (풍속)
     - 5: SKY (하늘 상태)
     - 6: PTY (강수 형태)
     - 7: POP (강수 확률)
     - 8: WAV (파고)
     - 9: PCP (1시간 강수량)
     - 10: REH (습도)
     - 11: SNO (1시간 신적설)
     
     요청 basetime 별 데이터 크기:
     - 0200: '+1시간' ~ '+70시간'
     - 0500: '+1시간' ~ '+67시간'
     - 0800: '+1시간' ~ '+64시간'
     - 1100: '+1시간' ~ '+61시간'
     - 1400: '+1시간' ~ '+58시간' (0200 ~ 1400 : 오늘 ~ 모레까지)
     - 1700: '+1시간' ~ '+79시간'
     - 2000: '+1시간' ~ '+76시간'
     - 2300: '+1시간' ~ '+73시간' (17:00 ~ 2300: 오늘 ~ 모레+1일 까지)
     */
    public func getTodayItems(xy: Gps2XY.LatXLngY, reqRow: String) async -> Result<[VeryShortOrShortTermForecast<ShortTermForecastCategory>], APIError> {
        let parameters = VeryShortOrShortTermForecastReq(
            serviceKey: APIKey.publicApiKey,
            numOfRows: reqRow,
            baseDate: ReqParameters.shortForecastBaseDate,
            baseTime: ReqParameters.shortForecastBaseTime,
            nx: String(xy.x),
            ny: String(xy.y)
        )
        
        let result = await ApiRequester.request(
            url: Route.GET_WEATHER_SHORT_TERM_FORECAST.val,
            method: .get,
            parameters: parameters,
            headers: nil,
            resultType: PublicDataRes<VeryShortOrShortTermForecast<ShortTermForecastCategory>>.self
        )
        return result.map { $0.item ?? [] }
    }
    
    public func getTodayMinMaxItems(xy: Gps2XY.LatXLngY) async -> Result<[VeryShortOrShortTermForecast<ShortTermForecastCategory>], APIError> {
        let parameters = VeryShortOrShortTermForecastReq(
            serviceKey: APIKey.publicApiKey,
            numOfRows: "300",
            baseDate: ReqParameters.shortForecastForTodayMinMaxBaseDate,
            baseTime: ReqParameters.shortForecastForTodayMinMaxBaseTime,
            nx: String(xy.x),
            ny: String(xy.y)
        )
        
        let result = await ApiRequester.request(
            url: Route.GET_WEATHER_SHORT_TERM_FORECAST.val,
            method: .get,
            parameters: parameters,
            headers: nil,
            resultType: PublicDataRes<VeryShortOrShortTermForecast<ShortTermForecastCategory>>.self
        )
        return result.map { $0.item ?? [] }
    }
}
