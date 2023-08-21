//
//  GetSize.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/08/21.
//

import SwiftUI

struct GetSize: ViewModifier {
    @Binding var size: CGSize
    
    func body(content: Content) -> some View {
        content
            .background {
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            size = proxy.size
                        }
                }
            }
    }
}

extension View {
    func getSize(size: Binding<CGSize>) -> some View {
        modifier(GetSize(size: size))
    }
}
