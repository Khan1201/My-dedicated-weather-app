//
//  ContentEO.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 10/23/23.
//

import Foundation
import Domain

public final class ContentEO: ObservableObject {
    @Published public var currentTab: TabBarType = .current
    @Published public var isLoading: Bool = true
    @Published public var disableTabBarTouch: Bool = true
    @Published public var showNoticePopup: Bool = false
    @Published public var isRefreshed: Bool = false
    @Published public var isLocationChanged: Bool = false
          
    public init() {}
}

// MARK: - On tap gestures..

extension ContentEO {
    public func tabBarItemOnTapGesture(_ type: TabBarType) {
        if disableTabBarTouch {
            showNoticePopup = true
            
        } else {
            currentTab = type
        }
    }
}

// MARK: - Life cycle funcs..

extension ContentEO {
    public func loadingOnAppearAction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.isLoading = false
        }
    }
}

// MARK: - Set funcs..

extension ContentEO {
    public func setIsRefreshedActionWhenRefreshStart() {
        isRefreshed = true
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) {
            self.isRefreshed = false
        }
    }
}
