//
//  VeryShortTermForecastCategory.swift
//
//
//  Created by 윤형석 on 10/6/24.
//

import Foundation

// MARK: - 초단기예보 값 types

public enum VeryShortTermForecastCategory: String, Decodable {
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
