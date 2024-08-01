//
//  CustomColor.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/06/30.
//

import Foundation
import SwiftUI

public enum CustomColor: String {
    
    case black, lightBlue, lightNavy
    
    public var toColor: Color {
        
        switch self {
            
        case .black:
            return Color(hexCode: "303345")
            
        case .lightBlue:
            return Color(hexCode: "81CFFA")
            
        case .lightNavy:
            return Color.init(hexCode: "254659")
        }
    }
}
