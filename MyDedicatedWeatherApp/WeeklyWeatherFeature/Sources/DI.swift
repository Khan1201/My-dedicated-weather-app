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
    static func weeklyWeatherVM() -> WeeklyWeatherVM {
        .init(
            shortTermForecastUtil: ShortTermForecastUtil(),
            commonForecastUtil: CommonForecastUtil(),
            midTermForecastUtil: MidTermForecastUtil()
        )
    }
}
