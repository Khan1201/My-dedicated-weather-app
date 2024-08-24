//
//  Validate.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/06/28.
//

import Foundation
import Alamofire

public struct Validate {
    
    public init() {}
    
    public func kakaoHeader(apiKey: String) -> HTTPHeaders? {
        
        return HTTPHeaders(["Authorization": "KakaoAK \(apiKey)"])
    }
}
