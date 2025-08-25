//
//  SettingVM.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 11/8/23.
//

import Foundation
import MessageUI
import Domain
import Core

final class SettingVM: ObservableObject {
    
    @Published var openMailView: Bool = false
    @Published var navWeatherStandardView: Bool = false
    @Published var navOpenSourceView: Bool = false
    @Published var showMailOpenFailAlert: Bool = false
    
    // 앱 출시 후 사용
//    let images: [String] = ["questionmark.circle", "square.and.pencil", "plus.bubble", "bolt.horizontal", "v.square"]
//    let menus: [String] = ["도움말", "리뷰 등록하기", "오류 신고 및 기능 제안", "오픈소스 라이센스", "앱 버전"]
//    let subTexts: [String] = ["사용법을 알려드려요!", "리뷰는 개발자에 큰 힘이 됩니다💪", "소중한 의견 반영하겠습니다 :)", "오픈소스", "1.0.0"]
//    let rightIconShowIndexs: [Int] = [0, 1, 2, 3]
    
    let images: [String] = ["questionmark.circle", "plus.bubble", "bolt.horizontal", "v.square"]
    let menus: [String] = ["날씨 및 미세먼지 기준", "오류 신고 및 기능 제안", "오픈소스 라이센스", "앱 버전"]
    let subTexts: [String] = ["상세 기준을 알려드려요", "소중한 의견 반영하겠습니다 :)", "오픈소스", CommonUtil.shared.getCurrentVersion()]
    let rightIconShowIndexs: [Int] = [0, 1, 2]
    
    let openSourceTitles: [String] = ["날씨 정보", "미세먼지 정보", "Alamofire", "lottie-ios", "PopupView", "SwiftUIPager"]
    let openSourceSubTitles: [String] = [
        "기상청 제공",
        "한국환경공단(에어코리아) 제공",
        "https://github.com/Alamofire/Alamofire",
        "https://github.com/airbnb/lottie-ios",
        "https://github.com/exyte/PopupView",
        "https://github.com/fermoya/SwiftUIPager"
    ]
    let openSourceTapAvailableIndexes: [Int] = [2, 3, 4, 5]
    
    private let noticeFloaterStore: any NoticeFloaterStore
    
    public init(noticeFloaterStore: any NoticeFloaterStore) {
        self.noticeFloaterStore = noticeFloaterStore
    }
}

// MARK: - On tap geture funs..

extension SettingVM {
    
    // 앱 출시 후 사용
//    func buttonTapGesture(index: Int) {
//        switch index {
//            
//        case 0: // 도움말
//            ()
//            
//        case 1: // 리뷰 등록하기
//            ()
//            
//        case 2: // 오류 신고 및 기능 제안
//            if MFMailComposeViewController.canSendMail() {
//                openMailView = true
//                
//            } else {
//                showMailOpenFailAlert = true
//            }
//            
//        case 3: // 오픈소스 라이센스
//            navOpenSourceView = true
//            
//        default:
//            ()
//        }
//    }
    func buttonTapGesture(index: Int) {
        switch index {
            
        case 0:
            navWeatherStandardView = true
            
        case 1: // 오류 신고 및 기능 제안
            if MFMailComposeViewController.canSendMail() {
                openMailView = true
                
            } else {
                noticeFloaterStore.send(.showMailAppNotExistFloater)
            }
            
        case 2: // 오픈소스 라이센스
            navOpenSourceView = true
            
        default:
            ()
        }
    }
}

// MARK: - Return funcs..

extension SettingVM {
    func showRightIcon(_ index: Int) -> Bool {
        return rightIconShowIndexs.contains { $0 == index }
    }
}
