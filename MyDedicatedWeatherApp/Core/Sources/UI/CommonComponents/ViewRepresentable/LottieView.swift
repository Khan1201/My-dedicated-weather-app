//
//  LottieView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/05/15.
//

import SwiftUI
import Foundation
import UIKit
import Lottie

public struct LottieView: UIViewRepresentable {
    
    private let jsonName: String
    private let loopMode: LottieLoopMode
    private let speed: CGFloat
    
    public init(jsonName: String, loopMode: LottieLoopMode, speed: CGFloat = 1.0) {
        self.jsonName = jsonName
        self.loopMode = loopMode
        self.speed = speed
    }
    
    public func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        guard !jsonName.isEmpty else {
            return UIView()
        }
        let view = UIView(frame: .zero)
        
        let animationView = LottieAnimationView()
        let animation = LottieAnimation.named(jsonName)
        animationView.animation = animation
        // AspectFit으로 적절한 크기의 에니매이션을 불러옵니다.
        animationView.contentMode = .scaleAspectFit
        // 애니메이션은 기본으로 Loop합니다.
        animationView.loopMode = loopMode
        // 애니메이션을 재생합니다
        animationView.play()
        // 백그라운드에서 재생이 멈추는 오류를 잡습니다
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.animationSpeed = speed
        
        //컨테이너의 너비와 높이를 자동으로 지정할 수 있도록합니다. 로티는 컨테이너 위에 작성됩니다.
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(animationView)
        //레이아웃의 높이와 넓이의 제약
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        return view
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}

