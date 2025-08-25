//
//  DI.swift
//  SettingFeature
//
//  Created by 윤형석 on 8/25/25.
//

import Foundation

import Foundation
import Core

struct DI {
    static func settingVM() -> SettingVM {
        .init(noticeFloaterStore: DefaultNoticeFloaterStore.shared)
    }
}
