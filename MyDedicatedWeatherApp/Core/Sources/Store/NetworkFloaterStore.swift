//
//  NetworkFloaterStore.swift
//  Core
//
//  Created by 윤형석 on 8/8/25.
//

import Foundation

public enum NetworkFloaterStoreAction {
    case startTimerAndShowFloaterIfTimeOver(retryAction: () -> Void)
    case stopTimer
}

public class NetworkFloaterStoreState: ObservableObject {
    @Published public var presenter: NetworkFloaterPresenter  = .init()
    public var timer: NoticeAndRetryTimer = .init()
}

public final class DefaultNetworkFloaterStore: NetworkFloaterStore {
    public static let shared: DefaultNetworkFloaterStore = .init()
    @Published public private(set) var state: NetworkFloaterStoreState = .init()
    
    private init() {}
    
    public func send(_ action: NetworkFloaterStoreAction) {
        reduce(state: state, action: action)
    }
    
    private func reduce(state: NetworkFloaterStoreState, action: NetworkFloaterStoreAction) {
        switch action {
        case .startTimerAndShowFloaterIfTimeOver(let retryAction):
            state.timer.start(
                showWaitNoticeFloaterAction: state.presenter.showWaitFloater,
                showRetryNoticeFloaterAndRetryAction: {
                    state.presenter.showRetryFloater()
                    retryAction()
                }
            )
        case .stopTimer:
            state.timer.initTimer()
        }
    }
}
