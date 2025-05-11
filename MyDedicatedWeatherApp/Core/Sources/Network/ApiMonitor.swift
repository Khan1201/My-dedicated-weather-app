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
    private var isRequestFailed: Bool = false
    
//    func requestDidResume(_ request: Request) {
//        if let url = request.request?.url?.absoluteString {
//            print("----------------------------------------------------------------------------------")
//            print("➡️ [REQUEST] \(request.description)")
//            print("📚 [DESCRIPTION] -> \(urlToDescription(url))")
//        }
//    }
    
    /// 서버의 Response 데이터를 받아서 파싱이 불가능한경우 실패로 처리
    /// 서버에서 Data를 조각으로 주기때문에, 한 API가 여러번 호출될수도 있음
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
            if let url = dataTask.response?.url?.absoluteString {
                if let rawString = String(data: data, encoding: .utf8) {
                    if !isParsingSucceeded(rawString) {
                        isRequestFailed = true
                        print("----------------------------------------------------------------------------------")
                        print("❌❌❌ [REQUEST FAIL] ❌❌❌")
                        print("🌐 [URL] -> \(url)")
                        print("📚 [DESCRIPTION] -> \(urlToDescription(url))")
                        print("📊 [DATA] -> \(rawString)")
                    }
                }
            }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse) {
        if let url = dataTask.response?.url?.absoluteString {
            if !isRequestFailed {
                print("----------------------------------------------------------------------------------")
                print("✅✅✅ [REQUEST SUCCESS] ✅✅✅")
                print("🌐 [URL] -> \(url)")
                print("📚 [DESCRIPTION] -> \(urlToDescription(url))")
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
