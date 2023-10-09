//
//  Extensions.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/09/04.
//

import Foundation
import SwiftUI

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

extension Color {
    init(hexCode: String, alpha: CGFloat = 1.0) {
        
        self.init(uiColor: UIColor(hexCode: hexCode, alpha: alpha))
    }
    
    public static var dayBackground: Color {
        return Color("WidgetDayBackground")
    }
    
    public static var nightBackground: Color {
        return Color("WidgetNightBackground")
    }
}

extension Date {
    
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

extension Int {
    
    var toString: String {
        return String(self)
    }
}

extension String {
    
    var toInt: Int {
        return Int(self) ?? 0
    }
}

extension UIScreen {
    
    static let screenWidth: CGFloat = UIScreen.main.bounds.size.width
    static let screenHeight: CGFloat = UIScreen.main.bounds.size.height
}
