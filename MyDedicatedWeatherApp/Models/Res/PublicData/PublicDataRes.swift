//
//  PublicDataRes.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/04/30.
//

import Foundation

struct PublicDataRes<T>: Decodable where T: Decodable {
    
    var item: [T]?
    var items: [T]?
    
    enum CodingKeys: String, CodingKey {
        
        case response
    }
    enum ResponseKeys: String, CodingKey {
        
        case body
    }
    
    enum BodyKeys: String, CodingKey {
        case items
    }
    
    enum ItemsKeys: String, CodingKey {
        case item
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let responseKeys = try container.nestedContainer(keyedBy: ResponseKeys.self, forKey: .response)
        let bodyKeys = try responseKeys.nestedContainer(keyedBy: BodyKeys.self, forKey: .body)
        
        self.item = nil
        self.items = nil
        
        // 초단기 or 단기 예보 or 중기 예보(온도, 하늘 상태) request 일 때, items가 아닌 item[]으로 result 들어옴
        if T.Type.self == VeryShortOrShortTermForecastBase<VeryShortTermForecastCategory>.Type.self ||
            T.Type.self == VeryShortOrShortTermForecastBase<ShortTermForecastCategory>.Type.self ||
            T.Type.self == MidTermForecastTemperatureBase.Type.self ||
            T.Type.self == MidTermForecastSkyStateBase.Type.self {
            let itemsKeys = try bodyKeys.nestedContainer(keyedBy: ItemsKeys.self, forKey: .items)
            self.item = try itemsKeys.decodeIfPresent([T].self, forKey: .item)
            
        } else {
            self.items = try bodyKeys.decodeIfPresent([T].self, forKey: .items)
        }
    }
}
