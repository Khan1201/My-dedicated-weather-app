//
//  Validate.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/06/28.
//

import Foundation
import Alamofire

struct Validate {
    
    func kakaoHeader() -> HTTPHeaders? {
        
        return HTTPHeaders(["Authorization": "KakaoAK \(Env.shared.kakaoRestAPIKey)"])
    }
}
