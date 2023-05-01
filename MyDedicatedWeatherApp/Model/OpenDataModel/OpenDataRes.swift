//
//  OpenDataRes.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/04/30.
//

import Foundation

struct OpenDataRes<T>: Decodable where T: Decodable {
    
    let item: [T]
    
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
        let itemsKeys = try bodyKeys.nestedContainer(keyedBy: ItemsKeys.self, forKey: .items)
        self.item = try itemsKeys.decode([T].self, forKey: .item)
    }
}
