//
//  LeftOrRightAnimationView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/07/27.
//

import SwiftUI
import SwiftUIPager

struct LeftOrRightAnimationView: View {
    
    @Binding var page: Page
    @Binding var pageIndex: Int

    @State private var yOffset: CGFloat = -25
    
    var body: some View {
        
        let isFirstPage = pageIndex == 0
        
        Image("arrow_\(isFirstPage ? "right" : "left")")
            .resizable()
            .renderingMode(.template)
            .foregroundColor(.white)
            .frame(width: 30, height: 30)
            .offset(x: isFirstPage ? -18 : 18, y: yOffset)
            .onTapGesture {
                withAnimation {
                    isFirstPage ? page.update(.next) : page.update(.previous)
                }
                pageIndex = page.index
            }
            .onAppear {
                withAnimation(.linear(duration: 0.6).repeatForever()) {
                    yOffset = -15
                }
            }
    }
}

struct LeftOrRightAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        LeftOrRightAnimationView(page: .constant(.first()), pageIndex: .constant(1))
    }
}
