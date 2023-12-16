//
//  ContentVM.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 10/23/23.
//

import Foundation

final class ContentVM: ObservableObject {
    
    static let shared = ContentVM()
    
    @Published var currentTab: TabBarType = .current
    @Published var isLoading: Bool = true
    @Published var disableTabBarTouch: Bool = true
    @Published var showNoticePopup: Bool = false
    @Published var isRefreshed: Bool = false
    @Published var isLocationChanged: Bool = false
    
    @Published private(set) var skyKeyword: String = ""
    @Published private(set) var isDayMode: Bool = false
    
    var commonForecastUtil = CommonForecastUtil()
    
    private init() {}
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
    
    @MainActor
    func setIsDayMode(sunrise: String, sunset: String) {
        let currentHHmm = Date().toString(format: "HHmm")
        let result = commonForecastUtil.isDayMode(hhMM: currentHHmm, sunrise: sunrise, sunset: sunset)
        isDayMode = result
    }
    
    func setSkyKeyword(_ value: String) {
        skyKeyword = value
    }
}
