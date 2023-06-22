//
//  LoadingProgress.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/06/22.
//

import SwiftUI

struct LoadingProgress: ViewModifier {
    
    @Binding var isLoadCompleted: Bool
    
    func body(content: Content) -> some View {
        
        content
            .if(!isLoadCompleted) { _ in
                return ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(2)
            }
    }
}

extension View {
    
    func loadingProgress(isLoadCompleted: Binding<Bool>) -> some View {
        modifier(LoadingProgress(isLoadCompleted: isLoadCompleted))
    }
}
