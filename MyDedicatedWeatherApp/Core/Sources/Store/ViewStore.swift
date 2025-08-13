//
//  ViewStore.swift
//  Core
//
//  Created by 윤형석 on 8/13/25.
//

import Foundation
import Domain

public enum ViewStoreAction {
    case hideLaunchScreenAfterFewSeconds
    case changeTab(to: TabBarType)
    case setIsTabBarTouchDisabled(_ value: Bool)
}

public final class ViewStoreState: ObservableObject {
    @Published public fileprivate(set) var currentTab: TabBarType = .current
    @Published public fileprivate(set) var isLaunchScreenPresented: Bool = true
    @Published public fileprivate(set) var isTabBarTouchDisabled: Bool = true
    @Published public fileprivate(set) var isTabBarTouchNoticeFloaterPresented: Bool = false
}

public final class DefaultViewStore: ViewStore {
    public static let shared: DefaultViewStore = .init()
    @Published public private(set) var state: ViewStoreState = .init()
    
    public func send(_ action: ViewStoreAction) {
        switch action {
        case .hideLaunchScreenAfterFewSeconds:
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.reduce(state: &self.state, action: action)
            }
            
        case .changeTab(_), .setIsTabBarTouchDisabled(_):
            reduce(state: &state, action: action)
        }
    }
    
    private func reduce(state: inout ViewStoreState, action: ViewStoreAction) {
        switch action {
        case .hideLaunchScreenAfterFewSeconds:
            state.isLaunchScreenPresented = false
            
        case .changeTab(let to):
            if state.isTabBarTouchDisabled {
                state.isTabBarTouchNoticeFloaterPresented = true
                
            } else {
                state.currentTab = to
            }
            
        case .setIsTabBarTouchDisabled(let value):
            state.isTabBarTouchDisabled = value
        }
    }
}
