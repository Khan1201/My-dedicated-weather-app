//
//   KakaoAddressService.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 3/17/24.
//

import Foundation
import Core
import Domain

public protocol KakaoAddressRequestable {
    func requestKaKaoAddressBy(apiKey: String, longitude: String, latitude: String) async -> Result<KakaoAddress.DocumentsBase, APIError>
}

public struct KakaoAddressService: KakaoAddressRequestable {
    private let validate: Validate
    
    public init(validate: Validate = Validate()) {
        self.validate = validate
    }
    
    public func requestKaKaoAddressBy(apiKey: String, longitude: String, latitude: String) async
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
