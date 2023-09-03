//
//  GetHeight.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/07/13.
//

import SwiftUI

struct GetHeight: ViewModifier {
    
    @Binding var height: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background {
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            height = proxy.size.height
                        }
                }
            }
    }
}

extension View {
    
    func getHeight(height: Binding<CGFloat>) -> some View {
        modifier(GetHeight(height: height))
    }
}
