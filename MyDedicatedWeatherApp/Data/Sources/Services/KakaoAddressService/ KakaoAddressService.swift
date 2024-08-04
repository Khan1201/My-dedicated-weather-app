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
    func requestKaKaoAddressBy(longitude: String, latitude: String) async -> Result<KakaoAddressBase.DocumentsBase, APIError>
}

public struct KakaoAddressService: KakaoAddressRequestable {
    private let validate: Validate
    
    public init(validate: Validate = Validate()) {
        self.validate = validate
    }
    
    public func requestKaKaoAddressBy(longitude: String, latitude: String) async
    -> Result<KakaoAddressBase.DocumentsBase, APIError> {
        let parameters = KakaoAddressReq(x: longitude, y: latitude)
        let header = validate.kakaoHeader()

        let result = await ApiRequester.request(
            url: Route.GET_KAKAO_ADDRESS.val,
            method: .get,
            parameters: parameters,
            headers: header,
            resultType: KakaoAddressBase.DocumentsBase.self
        )
        
        return result
    }
}
