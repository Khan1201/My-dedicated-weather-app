//
//  NoticeFloaterPresenter.swift
//  Core
//
//  Created by 윤형석 on 6/23/25.
//

import Foundation

public final class NetworkFloaterPresenter: ObservableObject {
    static public let WAIT_NOTICE_FLOATER_MESSAGE: String = """
    조금만 기다려주세요.
    기상청 서버 네트워크에 따라 속도가 느려질 수 있습니다 :)
    """
    static public let RETRY_NOTICE_FLOATER_MESSAGE: String = """
    재시도 합니다.
    기상청 서버 네트워크에 따라 속도가 느려질 수 있습니다 :)
    """
    
    @Published public var isPresented: Bool = false
    @Published public private(set) var floaterMessage: String = ""
    
    public init() { }
    
    public func showWaitFloater() {
        setMessageAndShowFloater(NetworkFloaterPresenter.WAIT_NOTICE_FLOATER_MESSAGE)
    }
    
    public func showRetryFloater() {
        setMessageAndShowFloater(NetworkFloaterPresenter.RETRY_NOTICE_FLOATER_MESSAGE)
    }
    
    private func setMessageAndShowFloater(_ message: String) {
        isPresented = false
        self.floaterMessage = message
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.isPresented = true
            self.objectWillChange.send()
        }
    }
}
