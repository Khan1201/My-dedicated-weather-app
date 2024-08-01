//
//  LoadingProgressLottie.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/07/30.
//

import SwiftUI

public struct LoadingProgressLottie: ViewModifier {
    
    let isLoadingCompleted: Bool
    var width: CGFloat?
    var height: CGFloat?
    
    @State private var size: CGSize = CGSize()
    @State private var isGetSize: Bool = false
    
    public init(isLoadingCompleted: Bool, width: CGFloat? = nil, height: CGFloat? = nil) {
        self.isLoadingCompleted = isLoadingCompleted
        self.width = width
        self.height = height
    }
    
    public func body(content: Content) -> some View {
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
                return LottieView(jsonName: "LoadingLottie", loopMode: .loop, speed: 1.5)
                    .frame(width: width == nil ? size.width : width,
                           height: height == nil ? size.height : height
                    )
            }
    }
}

extension View {
    public func loadingProgressLottie(
        isLoadingCompleted: Bool,
        width: CGFloat? = nil,
        height: CGFloat? = nil
    ) -> some View {
        modifier(
            LoadingProgressLottie(
                isLoadingCompleted: isLoadingCompleted,
                width: width,
                height: height
            )
        )
    }
}
