//
//  File.swift
//  
//
//  Created by 윤형석 on 3/2/25.
//

import Foundation
import SwiftUI

public protocol DustPresentable {
    var description: String { get }
    var backgroundColor: Color { get }
}

public struct FineDust: DustPresentable {
    public init(description: String, backgroundColor: Color) {
        self.description = description
        self.backgroundColor = backgroundColor
    }
    
    public let description: String
    public let backgroundColor: Color
}

public struct UltraFineDust: DustPresentable {
    public init(description: String, backgroundColor: Color) {
        self.description = description
        self.backgroundColor = backgroundColor
    }
    
    public let description: String
    public let backgroundColor: Color
}
