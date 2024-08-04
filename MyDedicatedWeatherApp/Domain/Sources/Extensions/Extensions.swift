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
    
    /**
     hhMM  -> h시 m분 으로 변환
     
     - parameter isSunset: 일몰인지 (오전, 오후 구분 위해)
     */
    public func hhMMtoKRhhMM(isSunset: Bool) -> String {
        guard let _ = Int(self), self.count == 4 else {
            CommonUtil.shared.printError(
                funcTitle: "hhMMtoKRhhMM(isSunset:)",
                description: "hhMM 형태가 아닙니다.",
                value: self
            )
            return self
        }
        var result = ""
        let mmIndex = self.index(self.startIndex, offsetBy: 2)
        let mm = self[mmIndex...]
        
        if isSunset {
            let hhIndex = self.index(self.startIndex, offsetBy: 1)
            let hh = self[...hhIndex]
            let hhMinus12 = String(hh).toInt - 12
            
            result = "\(hhMinus12)시 \(String(mm))분"
            
        } else {
            let hhIndex = self.index(self.startIndex, offsetBy: 1)
            let h = self[hhIndex]
            
            result = "\(h)시 \(String(mm))분"
        }
        
        return result
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

extension UserDefaults {
    
    public func setUserDefaultsStringArray(value: String, key: String) {
        guard var arrays = self.array(forKey: key) as? [String] else {
            self.set([value], forKey: key)
            return
        }
        arrays.append(value)
        self.set(arrays, forKey: key)
    }
    
    public func appendAdditionalAllLocality(_ allLocality: AllLocality) {
        
        /// fullAddresses가 없을때 append
        guard let fullAddresses = UserDefaults.standard.array(forKey: UserDefaultsKeys.additionalFullAddresses) as? [String] else {
            setUserDefaultsStringArray(value: allLocality.fullAddress, key: UserDefaultsKeys.additionalFullAddresses)
            setUserDefaultsStringArray(value: allLocality.locality, key: UserDefaultsKeys.additionalLocalities)
            setUserDefaultsStringArray(value: allLocality.subLocality, key: UserDefaultsKeys.additionalSubLocalities)
            return
        }
        
        /// 중복 존재시 return
        guard !fullAddresses.contains(allLocality.fullAddress) else {
            CommonUtil.shared.printError(
                funcTitle: "appendAdditionalAllLocality()",
                description: "이미 존재하는 fullAddress 입니다."
            )
            return
        }
        
        setUserDefaultsStringArray(value: allLocality.fullAddress, key: UserDefaultsKeys.additionalFullAddresses)
        setUserDefaultsStringArray(value: allLocality.locality, key: UserDefaultsKeys.additionalLocalities)
        setUserDefaultsStringArray(value: allLocality.subLocality, key: UserDefaultsKeys.additionalSubLocalities)
    }
    
    public func removeStringElementInArray(index: Int, key: String) {
        guard var arrays = self.array(forKey: key) as? [String] else {
            return
        }
        guard arrays.count - 1 >= index else { return }
        arrays.remove(at: index)
        self.set(arrays, forKey: key)
    }
    
    public static func setWidgetShared(_ value: String, to: WidgetShared) {
        
        switch to {
            
        case .x:
            UserDefaults.shared.set(value, forKey: UserDefaultsKeys.x)

        case .y:
            UserDefaults.shared.set(value, forKey: UserDefaultsKeys.y)
            
        case .latitude:
            UserDefaults.shared.set(value, forKey: UserDefaultsKeys.latitude)
            
        case .longitude:
            UserDefaults.shared.set(value, forKey: UserDefaultsKeys.longitude)

        case .locality:
            UserDefaults.shared.set(value, forKey: UserDefaultsKeys.locality)
            
        case .subLocality:
            UserDefaults.shared.set(value, forKey: UserDefaultsKeys.subLocality)
            
        case .fullAddress:
            UserDefaults.shared.set(value, forKey: UserDefaultsKeys.fullAddress)
            
        case .dustStationName:
            UserDefaults.shared.set(value, forKey: UserDefaultsKeys.dustStationName)
        }
    }
}
