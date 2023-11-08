//
//  SettingVM.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 11/8/23.
//

import Foundation

final class SettingVM: ObservableObject {
    
    @Published var openMailView: Bool = false
    
    let images: [String] = ["questionmark.circle", "square.and.pencil", "plus.bubble", "bolt.horizontal", "v.square"]
    let menus: [String] = ["도움말", "리뷰 등록하기", "오류 신고 및 기능 제안", "오픈소스 라이센스", "앱 버전"]
    let subTexts: [String] = ["사용법을 알려드려요!", "리뷰는 개발자에 큰 힘이 됩니다💪", "소중한 의견 반영하겠습니다 :)", "오픈소스", "1.0.0"]
}

// MARK: - On tap geture funs..

extension SettingVM {
    func buttonTapGesture(index: Int) {
        switch index {
            
        case 0:
            ()
            
        case 1:
            ()
            
        case 2:
            featureSuggestButtonOnTapGesture()
            
        case 3:
            ()
            
        case 4:
            ()
            
        default:
            ()
        }
    }
    
    func featureSuggestButtonOnTapGesture() {
        openMailView = true
    }
}
