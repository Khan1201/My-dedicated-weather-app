//
//  NoticeFloaterStore.swift
//  Core
//
//  Created by 윤형석 on 8/25/25.
//

import Foundation

public enum NoticeFloaterStoreAction {
    case showTabBarDisabledFloater
    case showNetworkWaitFloater
    case showNetworkReloadFloater
    case showAdditionalLocationNotExistFloater
    case showMailAppNotExistFloater
}

public final class NoticeFloaterStoreState: ObservableObject {
    fileprivate enum FloterMessage {
        static public let WAIT_FLOATER_MESSAGE: String = """
        조금만 기다려주세요.
        기상청 서버 네트워크에 따라 속도가 느려질 수 있습니다 :)
        """
        static public let RETRY_FLOATER_MESSAGE: String = """
        재시도 합니다.
        기상청 서버 네트워크에 따라 속도가 느려질 수 있습니다 :)
        """
        static public let TAB_BAR_DISABLED_FLOATER_MESSAGE: String = "현재 날씨 로딩후에 접근 가능합니다."
        static public let ADDITIONAL_LOCATION_NOT_EXIST_FLOATER_MESSAGE: String = "해당 위치에 대한 정보가 없습니다."
        static public let MAIL_APP_NOT_EXIST_FLOATER_MESSAGE: String = "기본 메일(Mail)앱이 존재하지 않습니다."
    }
    
    @Published fileprivate(set) var isPresented: Bool = false
    @Published fileprivate(set) var message: String = ""
}

public final class DefaultNoticeFloaterStore: NoticeFloaterStore {
    public static let shared: DefaultNoticeFloaterStore = .init()
    public private(set) var state: NoticeFloaterStoreState = .init()
    
    public func send(_ action: NoticeFloaterStoreAction) {
        reduce(state: &state, action: action)
    }
    
    private func reduce(state: inout NoticeFloaterStoreState, action: NoticeFloaterStoreAction) {
        state.isPresented = false
        state.message = ""
        
        switch action {
        case .showTabBarDisabledFloater:
            state.message = NoticeFloaterStoreState.FloterMessage.TAB_BAR_DISABLED_FLOATER_MESSAGE
        case .showNetworkWaitFloater:
            state.message = NoticeFloaterStoreState.FloterMessage.WAIT_FLOATER_MESSAGE
        case .showNetworkReloadFloater:
            state.message = NoticeFloaterStoreState.FloterMessage.RETRY_FLOATER_MESSAGE
        case .showAdditionalLocationNotExistFloater:
            state.message = NoticeFloaterStoreState.FloterMessage.ADDITIONAL_LOCATION_NOT_EXIST_FLOATER_MESSAGE
        case .showMailAppNotExistFloater:
            state.message = NoticeFloaterStoreState.FloterMessage.MAIL_APP_NOT_EXIST_FLOATER_MESSAGE
        }
        
        state.isPresented = true
    }
}
