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
    
    /**
     Request sublocality(성수동 1가) by kakao address
     - parameter longitude: 경도
     - parameter latitude: 위도
     
     Apple이 제공하는.reverseGeocodeLocation 에서 특정 기기에서 sublocality가 nil로 할당되므로
     kakao address request 에서 가져오도록 결정함.
     */
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
