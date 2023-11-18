//
//  ContentVM.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 10/23/23.
//

import Foundation

final class ContentVM: ObservableObject {
    
    @Published var currentTab: TabBarType = .current
    @Published var isLoading: Bool = true
    @Published var disableTabBarTouch: Bool = true
    @Published var showNoticePopup: Bool = false
    @Published var isRefreshed: Bool = false
}


// MARK: - On tap gestures..

extension ContentVM {
    func tabBarItemOnTapGesture(_ type: TabBarType) {
        if disableTabBarTouch {
            showNoticePopup = true
            
        } else {
            currentTab = type
        }
    }
}

// MARK: - Life cycle funcs..

extension ContentVM {
    func loadingOnAppearAction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.isLoading = false
        }
    }
}

// MARK: - Set funcs..

extension ContentVM {
    
    func setIsRefreshedActionWhenRefreshStart() {
        isRefreshed = true
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) {
            self.isRefreshed = false
        }
    }
}
