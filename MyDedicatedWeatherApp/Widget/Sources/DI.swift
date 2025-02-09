//
//  DI.swift
//
//
//  Created by 윤형석 on 1/2/25.
//

import Foundation
import Data

struct DI {
    static func weatherWidgetVM() -> WeatherWidgetVM {
        .init(
            commonUtil: .shared,
            commonForecastUtil: .shared,
            findDustLookUpUtil: .shared,
            veryShortForecastUtil: .shared,
            shortForecastUtil: .shared,
            midForecastUtil: .shared,
            veryShortForecastService: VeryShortForecastServiceImp(),
            shortForecastService: ShortForecastServiceImp(),
            midTermForecastService: MidTermForecastServiceImp(),
            dustForecastService: DustForecastServiceImp(), 
            userDefaultsService: UserDefaultsServiceImp()
        )
    }
}
