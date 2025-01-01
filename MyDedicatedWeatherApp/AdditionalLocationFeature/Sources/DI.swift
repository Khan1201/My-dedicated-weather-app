//
//  DI.swift
//
//
//  Created by 윤형석 on 1/2/25.
//

import Foundation
import Data

struct DI {
    static func additionalLocationVM() -> AdditionalLocationVM {
        return .init(
            commonUtil: .shared,
            commonForecastUtil: .shared,
            veryShortForecastUtil: .shared,
            shortForecastUtil: .shared,
            veryShortForecastService: VeryShortForecastServiceImp(),
            shortForecastService: ShortForecastServiceImp()
        )
    }
}
