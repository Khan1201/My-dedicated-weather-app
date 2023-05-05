//
//  HomeViewModel.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/04/30.
//

import Foundation

final class HomeViewModel: ObservableObject {
    
    @Published var threeToTenDaysTemperature: [temperatureMinMax] = []
    @Published var 
    @Published var errorMessage: String = ""
    
    func requestMidTermForecastItems() async {
        
        let parameters: MidTermForecastReq = MidTermForecastReq(
            serviceKey: Env().midTermForecastApiResponseKey,
            regId: MidTermLocationID.daegu.val,
            tmFc: Util().midTermForecastRequestDate()
        )
        do {
            let result = try await JsonRequest().newRequest(
                url: Route.GET_WHEATER_MID_TERM_FORECAST.val,
                method: .get,
                parameters: parameters,
                headers: nil,
                resultType: OpenDataRes<MidTermForecastModel>.self
            )
            DispatchQueue.main.async {
                self.setMidTermForecastItemToArray(item: result.item.first ?? Dummy().midTermForecastModel())
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
    
    
    func setMidTermForecastItemToArray(item: MidTermForecastModel) {
        
        threeToTenDaysTemperature.append(temperatureMinMax.init(minMax:(item.taMin3, item.taMax3), day: 3))
        threeToTenDaysTemperature.append(temperatureMinMax.init(minMax:(item.taMin4, item.taMax4), day: 4))
        threeToTenDaysTemperature.append(temperatureMinMax.init(minMax:(item.taMin5, item.taMax5), day: 5))
        threeToTenDaysTemperature.append(temperatureMinMax.init(minMax:(item.taMin6, item.taMax6), day: 6))
        threeToTenDaysTemperature.append(temperatureMinMax.init(minMax:(item.taMin7, item.taMax7), day: 7))
        threeToTenDaysTemperature.append(temperatureMinMax.init(minMax:(item.taMin8, item.taMax8), day: 8))
        threeToTenDaysTemperature.append(temperatureMinMax.init(minMax:(item.taMin9, item.taMax9), day: 9))
        threeToTenDaysTemperature.append(temperatureMinMax.init(minMax:(item.taMin10, item.taMax10), day: 10))
    }
}
