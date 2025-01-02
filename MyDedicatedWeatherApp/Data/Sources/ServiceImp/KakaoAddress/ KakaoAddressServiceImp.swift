//
//  KakaoAddressServiceImp.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 3/17/24.
//

import Foundation
import Core
import Domain

public struct KakaoAddressServiceImp: KakaoAddressService {
    public init() {}
    
    public func getKaKaoAddressBy(longitude: String, latitude: String) async
    -> Result<KakaoAddress.DocumentsBase, APIError> {
        let parameters = KakaoAddressReq(x: longitude, y: latitude)
        let header = HttpHeader.make(dic: ReqParameters.kakaoHeaderDic(apiKey: APIKey.kakaoApiKey))

        let result = await ApiRequester.request(
            url: Route.GET_KAKAO_ADDRESS.val,
            method: .get,
            parameters: parameters,
            headers: header,
            resultType: KakaoAddress.DocumentsBase.self
        )        
        return result
    }
}
