//
//  Types.swift
//  WeatherWidgetExtension
//
//  Created by 윤형석 on 2023/09/12.
//

import Foundation
import SwiftUI

enum MidtermReqType {
    case temperature, skystate, news
}

// MARK: - 초단기예보, 단기예보 값 types

enum VeryShortTermForecastCategory: String, Codable {
    
    case T1H, // 기온
         RN1, // 1시간 강수량
         PTY, // 강수 형태
         SKY, // 하늘 상태
         REH, // 습도
         WSD,// 풍속
         UUU, // 동서 바람 성분 (사용 x)
         VVV, // 남북 바람 성분 (사용 x),
         LGT, // 낙뢰 (사용 x)
         VEC // 풍향 (사용 x)
}

enum ShortTermForecastCategory: String, Codable {
    
    case POP, // 강수 확률
         PTY, // 강수 형태
         PCP, // 1시간 강수량
         REH, // 습도
         SNO, // 1시간 신적설 (사용 x)
         SKY, // 하늘상태
         TMP, // 1시간 기온
         TMN, // 일 최저기온
         TMX, // 일 최고기온
         UUU, // 동서 바람 성분 (사용 x)
         VVV, // 남북 바람 성분 (사용 x),
         WAV, // 파고 (사용 x)
         VEC, // 풍향 (사용 x)
         WSD // 풍속
}

