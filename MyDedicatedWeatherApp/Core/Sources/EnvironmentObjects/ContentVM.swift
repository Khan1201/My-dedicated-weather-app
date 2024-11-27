//
//  ContentVM.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 10/23/23.
//

import Foundation
import Domain

public final class ContentVM: ObservableObject {
    
    public static let shared = ContentVM()
    
    @Published public var currentTab: TabBarType = .current
    @Published public var isLoading: Bool = true
    @Published public var disableTabBarTouch: Bool = true
    @Published public var showNoticePopup: Bool = false
    @Published public var isRefreshed: Bool = false
    @Published public var isLocationChanged: Bool = false
    
    @Published public private(set) var skyType: APIValue?
    @Published public private(set) var isDayMode: Bool = false
    
    var commonForecastUtil = CommonForecastUtil()
    
    private init() {}
}


// MARK: - On tap gestures..

extension ContentVM {
    public func tabBarItemOnTapGesture(_ type: TabBarType) {
        if disableTabBarTouch {
            showNoticePopup = true
            
        } else {
            currentTab = type
        }
    }
}

// MARK: - Life cycle funcs..

extension ContentVM {
    public func loadingOnAppearAction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.isLoading = false
        }
    }
}

// MARK: - Set funcs..

extension ContentVM {
    
    public func setIsRefreshedActionWhenRefreshStart() {
        isRefreshed = true
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) {
            self.isRefreshed = false
        }
    }
    
    public func setIsDayMode(sunriseHHmm: String, sunsetHHmm: String) {
        let currentHHmm = Date().toString(format: "HHmm")
        let sunTime: SunTime = .init(
            currentHHmm: currentHHmm,
            sunriseHHmm: sunriseHHmm,
            sunsetHHmm: sunsetHHmm
        )
        isDayMode = sunTime.isDayMode
    }
    
    public func setSkyType(_ value: APIValue) {
        skyType = value
    }
}
