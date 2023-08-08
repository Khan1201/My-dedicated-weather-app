//
//  WeekViewModel.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/07/24.
//

import Foundation

final class WeekViewModel: ObservableObject {
    
    @Published var weeklyWeatherInformations: [Weather.WeeklyWeatherInformation] = []
    @Published var errorMessage: String = ""
    
    var minMaxTemperatures: [(Int, Int)] = []
    var weatherImageAndRainfallPercents: [(String, Int)] = []
    
    private let commonUtil: CommonUtil = CommonUtil()
    private let shortTermForecastUtil: ShortTermForecastUtil = ShortTermForecastUtil()
    private let env: Env = Env()
    private let jsonRequest: JsonRequest = JsonRequest()
    private let midTermForecastUtil: MidTermForecastUtil = MidTermForecastUtil()
    
    /**
     Request 단기예보 Items
     
     - parameter xy: 공공데이터 값으로 변환된 X, Y
     */
    func requestShortForecastItems(xy: Gps2XY.LatXLngY) async {
        
        let parameters = VeryShortOrShortTermForecastReq(
            serviceKey: env.openDataApiResponseKey,
            baseDate: shortTermForecastUtil.requestBaseDate(),
            baseTime: shortTermForecastUtil.requestBaseTime(),
            /// baseTime != nil -> 앱 구동 시 호출이 아닌, 수동 호출
            nx: String(xy.x),
            ny: String(xy.y)
        )
        
        do {
            let result = try await jsonRequest.newRequest(
                url: Route.GET_WEATHER_SHORT_TERM_FORECAST.val,
                method: .get,
                parameters: parameters,
                headers: nil,
                resultType: OpenDataRes<VeryShortOrShortTermForecastBase<ShortTermForecastCategory>>.self,
                requestName: "requestShortForecastItems(xy:)"
            )
            
        } catch APIError.transportError {
            
            DispatchQueue.main.async {
                self.errorMessage = "API 통신 에러"
            }
            
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "알 수 없는 오류"
            }
        }
    }
    
    /**
     Request 중기예보 Items
     */
    func requestMidTermForecastTempItems() async {
        
        let parameters: MidTermForecastReq = MidTermForecastReq(
            serviceKey: env.openDataApiResponseKey,
            regId: MidTermLocationID.daegu.val,
            stnId: nil,
            tmFc: midTermForecastUtil.requestDate()
        )
        do {
            let result = try await jsonRequest.newRequest(
                url: Route.GET_WEATHER_MID_TERM_FORECAST_TEMP.val,
                method: .get,
                parameters: parameters,
                headers: nil,
                resultType: OpenDataRes<MidTermForecastTemperatureBase>.self,
                requestName: "requestMidTermForecastTempItems()"
            )
            DispatchQueue.main.async {
                if let item = result.item?.first {
                    print("조회 성공")
                }
                
            }
        } catch APIError.transportError {
            
            DispatchQueue.main.async {
                self.errorMessage = "API 통신 에러"
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "알 수 없는 오류"
            }
        }
    }
}
