//
//  Gps2XY.swift
//
//
//  Created by 윤형석 on 10/6/24.
//

import Foundation

// MARK: - 위도, 경도 -> x, y 좌표 (초단기, 단기 예보에 필요한 x,y)

public struct Gps2XY {
    public init() {}
    
    public  struct LatXLngY {
        public init(lat: Double, lng: Double, x: Int, y: Int) {
            self.lat = lat
            self.lng = lng
            self.x = x
            self.y = y
        }
        
        public var lat: Double
        public var lng: Double
        
        public var x: Int
        public var y: Int
    }
    
    public enum LocationConvertMode: String {
        case toXY
        case toGPS
    }
}
