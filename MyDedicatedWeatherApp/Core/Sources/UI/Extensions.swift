//
//  File.swift
//  
//
//  Created by 윤형석 on 8/1/24.
//

import Foundation
import SwiftUI

extension UIScreen {
    
    public static let screenWidth: CGFloat = UIScreen.main.bounds.size.width
    public static let screenHeight: CGFloat = UIScreen.main.bounds.size.height
}

extension Color {
    
    public init(hexCode: String, alpha: CGFloat = 1.0) {
        
        self.init(uiColor: UIColor(hexCode: hexCode, alpha: alpha))
    }
    
    public init(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) {
        self.init(red: CGFloat(red/255.0), green: CGFloat(green/255.0), blue: CGFloat(blue/255.0))
    }
    
    /// 기본 묶음 view background
    public static var defaultAreaColor: Color {
        return Color.white.opacity(0.08)
    }
}

extension UIColor {
    
    public convenience init(hexCode: String, alpha: CGFloat = 1.0) {
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

extension View {
    @ViewBuilder public func `if`<Content: View>(
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

extension CGFloat {
    
    public var toInt: Int {
        return Int(self)
    }
}
