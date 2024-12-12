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
    private let validate: Validate
    
    public init(validate: Validate = Validate()) {
        self.validate = validate
    }
    
    public func getKaKaoAddressBy(apiKey: String, longitude: String, latitude: String) async
    -> Result<KakaoAddress.DocumentsBase, APIError> {
        let parameters = KakaoAddressReq(x: longitude, y: latitude)
        let header = validate.kakaoHeader(apiKey: apiKey)

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
