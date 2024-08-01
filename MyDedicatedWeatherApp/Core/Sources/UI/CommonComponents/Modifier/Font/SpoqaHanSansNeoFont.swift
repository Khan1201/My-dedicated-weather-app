//
//  SpoqaHanSansNeoFont.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/06/30.
//

import SwiftUI

public struct SpoqaHanSansNeoFont: ViewModifier {
    
    let size: CGFloat
    let weight: Font.Weight
    
    public init(size: CGFloat, weight: Font.Weight) {
        self.size = size
        self.weight = weight
    }
    
    public func body(content: Content) -> some View {
        content
            .font(.custom("Spoqa Han Sans Neo", size: size).weight(weight))
    }
}

extension View {
    
    public func fontSpoqaHanSansNeo(size: CGFloat, weight: Font.Weight) -> some View {
        modifier(SpoqaHanSansNeoFont(size: size, weight: weight))
    }
}

