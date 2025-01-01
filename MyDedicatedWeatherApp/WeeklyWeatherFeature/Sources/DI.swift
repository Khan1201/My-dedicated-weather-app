//
//  DI.swift
//
//
//  Created by 윤형석 on 12/14/24.
//

import Foundation
import Domain
import Data

struct DI {
    static func weeklyWeatherVM() -> WeeklyWeatherVM {
        .init(
            shortForecastUtil: .shared,
            commonForecastUtil: .shared,
            midForecastUtil: .shared,
            shortForecastService: ShortForecastServiceImp(),
            midtermForecastService: MidTermForecastServiceImp()
        )
    }
}
