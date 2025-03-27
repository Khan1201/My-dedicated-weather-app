//
//  Extension.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/05/14.
//

import Foundation
import UIKit
import CoreLocation
import SwiftUI

extension Date {
    
    /**
     day를 더하여 format 형식으로 String 반환
     
     - parameter byAdding: 더할  값
     - parameter format: format 형식 (ex: "yyyy")
     */
    public func toString(byAdding day: Int, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "ko")
        
        let addedDate: Date = Calendar.current.date(byAdding: .day, value: day, to: self) ?? self
        
        return dateFormatter.string(from: addedDate)
    }
    /**
     format 형식으로 String 반환
     
     - parameter dateFormat: dateFormat String
     */
    public func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "ko")
        
        return dateFormatter.string(from: self)
    }
    
    /**
     format 형식으로 String 반환
     timeZone 반영
     
     - parameter dateFormat: dateFormat String
     - parameter timeZone: time zone
     */
    public func toString(format: String, timeZone: TimeZone?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timeZone
        
        return dateFormatter.string(from: self)
    }
}

extension String {
    public var toInt: Int {
        return Int(self) ?? 0
    }
    
    public var toDouble: Double {
        return Double(self) ?? 0
    }
}

extension Int {
    public var toString: String {
        return String(self)
    }
}

extension Double {
    public var toInt: Int {
        return Int(self)
    }
}
