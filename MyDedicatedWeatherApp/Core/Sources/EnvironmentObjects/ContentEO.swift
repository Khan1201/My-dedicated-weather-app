//
//  ContentEO.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 10/23/23.
//

import Foundation
import Combine
import Domain

public final class ContentEO: ObservableObject {
    @Published public var currentTab: TabBarType = .current
    @Published public private(set) var isLaunchScreenPresented: Bool = true
    @Published public private(set) var isTabBarTouchDisabled: Bool = true
    @Published public var isTabBarTouchNoticeFloaterPresented: Bool = false
    
    public let viewStore: any ViewStore
    private var bag: Set<AnyCancellable> = []
          
    public init(viewStore: any ViewStore) {
        self.viewStore = viewStore
        assignStoreValues()
    }
    
    public func tabBarItemOnTapGesture(_ type: TabBarType) {
        viewStore.send(.changeTab(to: type))
    }
    
    public func hideLaunchScreenAfterFewSeconds() {
        viewStore.send(.hideLaunchScreenAfterFewSeconds)
    }
    
    private func assignStoreValues() {
        viewStore.state.$currentTab
            .assign(to: &$currentTab)
        
        viewStore.state.$isLaunchScreenPresented
            .assign(to: &$isLaunchScreenPresented)
        
        viewStore.state.$isTabBarTouchDisabled
            .assign(to: &$isTabBarTouchDisabled)
        
        viewStore.state.$isTabBarTouchNoticeFloaterPresented
            .assign(to: &$isTabBarTouchNoticeFloaterPresented)
    }
}
