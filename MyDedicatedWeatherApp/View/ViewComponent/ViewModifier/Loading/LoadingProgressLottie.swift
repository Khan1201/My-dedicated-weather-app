//
//  LoadingProgressLottie.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/07/30.
//

import SwiftUI

struct LoadingProgressLottie: ViewModifier {
    
    let isLoadingCompleted: Bool
    
    @State private var size: CGSize = CGSize()
    @State private var isGetSize: Bool = false
    
    func body(content: Content) -> some View {
        content
            .background {
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            size = proxy.size
                            isGetSize = true
                        }
                }
            }
            .if(!isLoadingCompleted && isGetSize) { _ in
                return LottieView(jsonName: "LoadingLottie", loopMode: .loop)
                    .frame(width: size.width, height: size.height)
            }
        
    }
}

extension View {
    func loadingProgressLottie(isLoadingCompleted: Bool) -> some View {
        modifier(LoadingProgressLottie(isLoadingCompleted: isLoadingCompleted))
    }
}
