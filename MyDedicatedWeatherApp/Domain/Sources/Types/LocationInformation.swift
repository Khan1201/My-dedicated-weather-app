//
//  File.swift
//  
//
//  Created by 윤형석 on 12/17/24.
//

import Foundation

public struct LocationInformation {
    public let longitude: String
    public let latitude: String
    public let xy: (String, String)
    public let locality: String
    public let subLocality: String
    public let fullAddress: String
    
    public init(longitude: String, latitude: String, xy: (String, String), locality: String, subLocality: String, fullAddress: String) {
        self.longitude = longitude
        self.latitude = latitude
        self.xy = xy
        self.locality = locality
        self.subLocality = subLocality
        self.fullAddress = fullAddress
    }
}
