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
    @Published private(set) public var isLaunchScreenPresented: Bool = true
    @Published public var isTabBarTouchDisabled: Bool = true
    @Published public var isTabBarTouchNoticeFloaterPresented: Bool = false
          
    public init() {}
    
    public func tabBarItemOnTapGesture(_ type: TabBarType) {
        if isTabBarTouchDisabled {
            isTabBarTouchNoticeFloaterPresented = true
            
        } else {
            currentTab = type
        }
    }
    
    public func hideLaunchScreenAfterFewSeconds() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.isLaunchScreenPresented = false
        }
    }
}
