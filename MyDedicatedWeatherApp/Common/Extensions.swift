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

extension UIScreen {
    
    static let screenWidth: CGFloat = UIScreen.main.bounds.size.width
    static let screenHeight: CGFloat = UIScreen.main.bounds.size.height
}

extension Color {
    
    init(hexCode: String, alpha: CGFloat = 1.0) {
        
        self.init(uiColor: UIColor(hexCode: hexCode, alpha: alpha))
    }
    
    init(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) {
        self.init(red: CGFloat(red/255.0), green: CGFloat(green/255.0), blue: CGFloat(blue/255.0))
    }
    
    /// 기본 묶음 view background
    static var defaultAreaColor: Color {
        return Color.white.opacity(0.08)
    }
}

extension UIColor {
    
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}

extension Date {
    
    /**
     day를 더하여 format 형식으로 String 반환
     
     - parameter byAdding: 더할  값
     - parameter format: format 형식 (ex: "yyyy")
     */
    func toString(byAdding day: Int, format: String) -> String {
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
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "ko")
        
        return dateFormatter.string(from: self)
    }
}

extension String {
    
    var toInt: Int {
        return Int(self) ?? 0
    }
    
    /**
     hhMM  -> h시 m분 으로 변환
     
     - parameter isSunset: 일몰인지 (오전, 오후 구분 위해)
     */
    func hhMMtoKRhhMM(isSunset: Bool) -> String {
        guard let _ = Int(self), self.count == 4 else {
            CommonUtil.shared.printError(funcTitle: "hhMMtoKRhhMM(isSunset:)", description: "hhMM 형태가 아닙니다.")
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
    
    var toString: String {
        return String(self)
    }
}

extension CGFloat {
    
    var toInt: Int {
        return Int(self)
    }
}

extension View {
    @ViewBuilder func `if`<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

extension UserDefaults {
    
    func setUserDefaultsStringArray(value: String, key: String) {
        guard var arrays = self.array(forKey: key) as? [String] else {
            self.set([value], forKey: key)
            return
        }
        arrays.append(value)
        self.set(arrays, forKey: key)
    }
    
    func removeStringElementInArray(index: Int, key: String) {
        guard var arrays = self.array(forKey: key) as? [String] else {
            return
        }
        guard arrays.count - 1 >= index else { return }
        arrays.remove(at: index)
        self.set(arrays, forKey: key)
    }
}
