//
//  GlobalNoticeFloaterEO.swift
//  Core
//
//  Created by 윤형석 on 8/25/25.
//

import Foundation

public final class GlobalNoticeFloaterEO: ObservableObject {
    @Published public var isPresented: Bool = false
    @Published public var message: String = ""
    private let noticeFloaterStore: any NoticeFloaterStore
    
    public init(noticeFloaterStore: any NoticeFloaterStore) {
        self.noticeFloaterStore = noticeFloaterStore
        
        noticeFloaterStore.state.$isPresented
            .assign(to: &$isPresented)
        
        noticeFloaterStore.state.$message
            .assign(to: &$message)
    }
}
