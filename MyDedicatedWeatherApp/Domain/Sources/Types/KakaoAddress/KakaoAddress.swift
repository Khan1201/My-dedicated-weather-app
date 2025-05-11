//
//  KakaoAddress.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/06/29.
//

import Foundation

public struct KakaoAddress {
    public let fullAddress: String
    public let subLocality: String // 성수동 1가
    
    enum CodingKeys: String, CodingKey {
        case address_name
        case region_3depth_name
    }
    
    // Nested
    public struct DocumentsBase: Decodable {
        public init(documents: [AddressBase]) {
            self.documents = documents
        }
        
        public let documents: [AddressBase]
    }
    
    public struct AddressBase: Decodable {
        public init(road_address: KakaoAddress?, address: KakaoAddress) {
            self.road_address = road_address
            self.address = address
        }
        
        public let road_address: KakaoAddress?
        public let address: KakaoAddress
    }
}

extension KakaoAddress: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.fullAddress = try container.decode(String.self, forKey: .address_name)
        self.subLocality = try container.decode(String.self, forKey: .region_3depth_name)
    }
}
