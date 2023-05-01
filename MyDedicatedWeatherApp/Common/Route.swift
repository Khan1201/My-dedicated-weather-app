//
//  Route.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/04/30.
//

import Foundation

enum Route {
    
    case GET_WHEATER_MID_TERM_FORECAST
    
    var val: String {
        
        switch self {
            
        case .GET_WHEATER_MID_TERM_FORECAST:
            return "http://apis.data.go.kr/1360000/MidFcstInfoService/getMidTa"
        }
    }
}
