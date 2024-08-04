//
//  KakaoAddressBase.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/06/29.
//

import Foundation

public struct KakaoAddressBase: Encodable {
    public let fullAddress: String
    public let subLocality: String // 성수동 1가
    
    enum CodingKeys: String, CodingKey {
        case address_name
        case region_3depth_name
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fullAddress, forKey: .address_name)
        try container.encode(subLocality, forKey: .region_3depth_name)
    }
    
    // Nested
    public struct DocumentsBase: Decodable {
        public init(documents: [AddressBase]) {
            self.documents = documents
        }
        
        public let documents: [AddressBase]
    }
    
    public struct AddressBase: Decodable {
        public init(road_address: KakaoAddressBase?, address: KakaoAddressBase) {
            self.road_address = road_address
            self.address = address
        }
        
        public let road_address: KakaoAddressBase?
        public let address: KakaoAddressBase
    }
}

extension KakaoAddressBase: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.fullAddress = try container.decode(String.self, forKey: .address_name)
        self.subLocality = try container.decode(String.self, forKey: .region_3depth_name)
    }
}
