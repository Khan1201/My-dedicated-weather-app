//
//  AllLocality.swift
//
//
//  Created by 윤형석 on 10/6/24.
//

import Foundation

public struct AllLocality {
    public init(fullAddress: String, locality: String, subLocality: String) {
        self.fullAddress = fullAddress
        self.locality = locality
        self.subLocality = subLocality
    }
    
    public let fullAddress: String
    public let locality: String
    public let subLocality: String
}
