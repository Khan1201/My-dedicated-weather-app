//
//  APIMonitor.swift
//
//
//  Created by 윤형석 on 5/8/25.
//

import Foundation
import Alamofire

final class APIMonitor: EventMonitor {
    let queue = DispatchQueue(label: "com.example.api-monitor")
    
//    func requestDidResume(_ request: Request) {
//        if let url = request.request?.url?.absoluteString {
//            print("----------------------------------------------------------------------------------")
//            print("➡️ [REQUEST] \(request.description)")
//            print("📚 [DESCRIPTION] -> \(urlToDescription(url))")
//        }
//    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
            if let url = dataTask.response?.url?.absoluteString {
                if let rawString = String(data: data, encoding: .utf8) {
                    print("----------------------------------------------------------------------------------")
                    print(isParsingSucceeded(rawString) ? "✅✅✅ [REQUEST SUCCESS] ✅✅✅" : "❌❌❌ [REQUEST FAIL] ❌❌❌")
                    print("🌐 [URL] -> \(url)")
                    print("📚 [DESCRIPTION] -> \(urlToDescription(url))")
                    if !isParsingSucceeded(rawString) {
                        print("📊 [DATA] -> \(rawString)")
                    }
                }
            }
    }
    
    private func urlToDescription(_ url: String) -> String {
        switch url {
        case _ where url.contains(Route.GET_WEATHER_SHORT_TERM_FORECAST.val):
            return "단기예보 조회"
        case _ where url.contains(Route.GET_WEATHER_VERY_SHORT_TERM_FORECAST.val):
            return "초단기예보 조회"
        case _ where url.contains(Route.GET_REAL_TIME_FIND_DUST_FORECAST.val):
            return "미세먼지 조회"
        case _ where url.contains(Route.GET_DUST_FORECAST_STATION_XY.val):
            return "미세먼지 지역 XY 좌표 조회"
        case _ where url.contains(Route.GET_DUST_FORECAST_STATION.val):
            return "미세먼지 지역 조회"
        case _ where url.contains(Route.GET_KAKAO_ADDRESS.val):
            return "카카오 Sublocality 조회"
        case _ where url.contains(Route.GET_WEATHER_MID_TERM_FORECAST_TEMP.val):
            return "중기예보 온도 조회"
        case _ where url.contains(Route.GET_WEATHER_MID_TERM_FORECAST_SKYSTATE.val):
            return "중기예보 하늘상태 조회"
        case _ where url.contains(Route.GET_WEATHER_MID_TERM_FORECAST_NEWS.val):
            return "중기예보 뉴스 조회"
        default:
            return ""
        }
    }
    
    private func dataToJsonString(_ data: Data) -> String? {
        var result: String?
        if let json = try? JSONSerialization.jsonObject(with: data, options: []),
           let prettyData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
           let jsonString = String(data: prettyData, encoding: .utf8) {
            result = jsonString
        }
        
        return result
    }
    
    private func isParsingSucceeded(_ rawString: String) -> Bool {
        let kakaoAddressComponent: String = "address_name"
        let publicWeatherDataComponent: String = "baseDate"
        let publicDustDataComponent: String = "body"
        return rawString.contains(kakaoAddressComponent) || rawString.contains(publicWeatherDataComponent) || rawString.contains(publicDustDataComponent)
    }
}
