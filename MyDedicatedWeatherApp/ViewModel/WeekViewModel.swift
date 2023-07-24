//
//  WeekViewModel.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/07/24.
//

import Foundation

final class WeekViewModel: ObservableObject {
    
    @Published var errorMessage: String = ""
    
    private let util = Util()
    private let env = Env()
    private let jsonRequest = JsonRequest()
    
    /**
     Request 단기예보 Items
     
     - parameter xy: 공공데이터 값으로 변환된 X, Y
     */
    func requestShortForecastItems(xy: Util.LatXLngY) async {
        
        let parameters = VeryShortOrShortTermForecastReq(
            serviceKey: env.openDataApiResponseKey,
            baseDate: util.shortTermForcastBaseDate(),
            baseTime: util.shortTermForecastBaseTime(),
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
}
