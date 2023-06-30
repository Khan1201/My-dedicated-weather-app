//
//  SpoqaHanSansNeoFont.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/06/30.
//

import SwiftUI

struct SpoqaHanSansNeoFont: ViewModifier {
    
    let size: CGFloat
    let weight: Font.Weight
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Spoqa Han Sans Neo", size: size).weight(weight))
    }
}

extension View {
    
    func fontSpoqaHanSansNeo(size: CGFloat, weight: Font.Weight) -> some View {
        modifier(SpoqaHanSansNeoFont(size: size, weight: weight))
    }
}

