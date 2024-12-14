//
//  File.swift
//  
//
//  Created by 윤형석 on 12/14/24.
//

import Foundation
import Domain
import Data

struct DI {
    static func currentWeatherVM() -> CurrentWeatherVM {
        return .init(
            commonForecastUtil: CommonForecastUtil(),
            veryShortTermForecastUtil: VeryShortTermForecastUtil(),
            shortTermForecastUtil: ShortTermForecastUtil(),
            midTermForecastUtil: MidTermForecastUtil(),
            fineDustLookUpUtil: FineDustLookUpUtil(),
            veryShortForecastService: VeryShortForecastServiceImp(),
            shortForecastService: ShortForecastServiceImp(),
            dustForecastService: DustForecastServiceImp(),
            kakaoAddressService: KakaoAddressServiceImp()
        )
    }
}
