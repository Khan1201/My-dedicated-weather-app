//
//  LoadingProgress.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/06/22.
//

import SwiftUI

public struct LoadingProgress: ViewModifier {
    
    let isLoadCompleted: Bool
    
    public init(isLoadCompleted: Bool) {
        self.isLoadCompleted = isLoadCompleted
    }
    
    public func body(content: Content) -> some View {
        content
            .if(!isLoadCompleted) { _ in
                return ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(2)
            }
    }
}

extension View {
    
    public func loadingProgress(isLoadCompleted: Bool) -> some View {
        modifier(LoadingProgress(isLoadCompleted: isLoadCompleted))
    }
}
