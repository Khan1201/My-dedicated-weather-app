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
    
    private let viewStore: any ViewStore
    private let noticeFloaterStore: any NoticeFloaterStore
    private var bag: Set<AnyCancellable> = []
          
    public init(viewStore: any ViewStore, noticeFloaterStore: any NoticeFloaterStore) {
        self.viewStore = viewStore
        self.noticeFloaterStore = noticeFloaterStore
        assignStoreValues()
    }
    
    public func tabBarItemOnTapGesture(_ type: TabBarType) {
        if viewStore.state.isTabBarTouchDisabled {
            noticeFloaterStore.send(.showTabBarDisabledFloater)
            return
        }
        
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
    }
}
