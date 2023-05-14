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
        
        if T.Type.self == VeryShortOrShortTermForecastModel<VeryShortTermForecastCategory>.Type.self { // 초단기 or 단기 예보
            let itemsKeys = try bodyKeys.nestedContainer(keyedBy: ItemsKeys.self, forKey: .items)
            self.item = try itemsKeys.decodeIfPresent([T].self, forKey: .item)
            
        } else if T.Type.self == RealTimeFindDustForecastModel.Type.self { // 미세먼지 예보
            self.items = try bodyKeys.decodeIfPresent([T].self, forKey: .items)
        }
    }
}
