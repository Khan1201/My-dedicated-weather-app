//
//  File.swift
//  
//
//  Created by 윤형석 on 12/17/24.
//

import Foundation

public struct LocationInformation: Codable {
    public let longitude: String
    public let latitude: String
    public let x: String
    public let y: String
    public let locality: String
    public let subLocality: String
    public let fullAddress: String
    public var isGPSLocation: Bool
    
    public init(longitude: String = "", latitude: String = "", x: String = "", y: String = "", locality: String = "", subLocality: String = "", fullAddress: String = "", isGPSLocation: Bool = false) {
        self.longitude = longitude
        self.latitude = latitude
        self.x = x
        self.y = y
        self.locality = locality
        self.subLocality = subLocality
        self.fullAddress = fullAddress
        self.isGPSLocation = isGPSLocation
    }
}
