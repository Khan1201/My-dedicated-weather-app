//
//  KakaoAddressBase.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/06/29.
//

import Foundation

struct KakaoAddressBase: Encodable {
    let fullAddress: String
    let subLocality: String // 성수동 1가
    
    enum CodingKeys: String, CodingKey {
        case address_name
        case region_3depth_name
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fullAddress, forKey: .address_name)
        try container.encode(subLocality, forKey: .region_3depth_name)
    }
    
    // Nested
    struct DocumentsBase: Decodable {
        let documents: [AddressBase]
    }
    
    struct AddressBase: Decodable {
        let road_address: KakaoAddressBase?
        let address: KakaoAddressBase
    }
}

extension KakaoAddressBase: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.fullAddress = try container.decode(String.self, forKey: .address_name)
        self.subLocality = try container.decode(String.self, forKey: .region_3depth_name)
    }
}
