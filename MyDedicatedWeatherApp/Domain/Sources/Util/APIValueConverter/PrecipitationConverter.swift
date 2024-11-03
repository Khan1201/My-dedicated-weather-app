//
// PrecipitationConverter.swift
//
//
//  Created by 윤형석 on 11/3/24.
//

import Foundation

public struct PrecipitationConverter: APIValueConverter {
    
    static public func convert(rawValue: String) -> String {
        if rawValue == "강수없음" {
            return ("비 없음")
            
        } else if rawValue == "30.0~50.0mm" || rawValue == "50.0mm 이상" {
            return ("매우 강한 비")
            
        } else {
            let stringToDouble: Double = Double(rawValue.replacingOccurrences(of: "mm", with: "")) ?? 0
            
            switch stringToDouble {
                
            case 1.0...2.9:
                return ("약한 비")
                
            case 3.0...14.9:
                return ("보통 비")
                
            case 15.0...29.9:
                return ("강한 비")
                
            default:
                return ("알 수 없음")
            }
        }
    }
    
    static public func toShortValue(_ rawValue: String) -> String {
        if rawValue == "강수없음" {
            return ""
        }
        
        if rawValue == "30.0~50.0mm" || rawValue == "50.0mm 이상" {
            return "30mm 이상"
        }
        
        return rawValue
    }
}
