//
//  CustomHapticGenerator.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 1/21/24.
//

import Foundation
import UIKit

public struct CustomHapticGenerator {
    
    public init() {}
    
    public static func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
