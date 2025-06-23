//
//  NoticeAndRetryTimer.swift
//  Core
//
//  Created by 윤형석 on 6/23/25.
//

import Foundation

public final class NoticeAndRetryTimer {
    public static let WAIT_NOTICE_FLOATER_TRIGGER_TIME: Int = 3
    public static let RETRY_TRIGGER_TIME: Int = 8
    
    private var timer: Timer?
    private var timerNum: Int = 0
    private var showWaitNoticeFloaterAction: (() -> Void)?
    private var showRetryNoticeFloaterAndRetryAction: (() -> Void)?
    
    public init() { }

    public func initTimer() {
        timer?.invalidate()
        timer = nil
        timerNum = 0
    }
    
    public func start(
        showWaitNoticeFloaterAction: @escaping () -> Void,
        showRetryNoticeFloaterAndRetryAction: @escaping () -> Void
    ) {
        initTimer()
        self.showWaitNoticeFloaterAction = showWaitNoticeFloaterAction
        self.showRetryNoticeFloaterAndRetryAction = showRetryNoticeFloaterAndRetryAction
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerPerSecondAction(timer:)), userInfo: nil, repeats: true)
    }
    
    @objc private func timerPerSecondAction(timer: Timer) {
        guard self.timer != nil else { return }
        self.timerNum += 1
        
        if timerNum == NoticeAndRetryTimer.WAIT_NOTICE_FLOATER_TRIGGER_TIME {
            showWaitNoticeFloaterAction?()
            
        } else if timerNum == NoticeAndRetryTimer.RETRY_TRIGGER_TIME {
            initTimer()
            showRetryNoticeFloaterAndRetryAction?()
        }
    }
}
