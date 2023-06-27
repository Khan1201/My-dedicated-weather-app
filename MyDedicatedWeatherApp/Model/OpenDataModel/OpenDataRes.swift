//
//  OpenDataRes.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/04/30.
//

import Foundation

struct OpenDataRes<T>: Decodable where T: Decodable {
    
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
        
        // 초단기 or 단기 예보
        if T.Type.self == VeryShortOrShortTermForecastModel<VeryShortTermForecastCategory>.Type.self ||
            T.Type.self == VeryShortOrShortTermForecastModel<ShortTermForecastCategory>.Type.self
        {
            let itemsKeys = try bodyKeys.nestedContainer(keyedBy: ItemsKeys.self, forKey: .items)
            self.item = try itemsKeys.decodeIfPresent([T].self, forKey: .item)
            
        } else {
            self.items = try bodyKeys.decodeIfPresent([T].self, forKey: .items)
        }
    }
}
