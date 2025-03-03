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
    @Published public var isLaunchScreenPresented: Bool = true
    @Published public var isTabBarTouchDisabled: Bool = true
    @Published public var isTabBarTouchNoticeFloaterPresented: Bool = false
    @Published public var isRefreshed: Bool = false
    @Published public var isLocationChanged: Bool = false
          
    public init() {}
}

// MARK: - On tap gestures..

extension ContentEO {
    public func tabBarItemOnTapGesture(_ type: TabBarType) {
        if isTabBarTouchDisabled {
            isTabBarTouchNoticeFloaterPresented = true
            
        } else {
            currentTab = type
        }
    }
}

// MARK: - Life cycle funcs..

extension ContentEO {
    public func hideLaunchScreenAfterFewSeconds() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.isLaunchScreenPresented = false
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
