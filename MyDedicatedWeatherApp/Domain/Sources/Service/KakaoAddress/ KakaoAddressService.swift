//
//  KakaoAddressService.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 3/17/24.
//

import Foundation

public protocol KakaoAddressService {
    func getKaKaoAddressBy(apiKey: String, longitude: String, latitude: String) async -> Result<KakaoAddress.DocumentsBase, APIError>
}
