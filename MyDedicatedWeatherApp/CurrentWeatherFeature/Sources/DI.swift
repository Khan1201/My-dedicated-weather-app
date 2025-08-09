//
//  File.swift
//  
//
//  Created by 윤형석 on 12/14/24.
//

import Foundation
import Domain
import Data
import Core

struct DI {
    static func currentWeatherVM() -> CurrentWeatherVM {
        return .init(
            commonUtil: .shared,
            commonForecastUtil: .shared,
            veryShortForecastUtil: .shared,
            shortForecastUtil: .shared,
            midForecastUtil: .shared,
            fineDustLookUpUtil: .shared,
            veryShortForecastService: VeryShortForecastServiceImp(),
            shortForecastService: ShortForecastServiceImp(),
            dustForecastService: DustForecastServiceImp(),
            kakaoAddressService: KakaoAddressServiceImp(),
            userDefaultsService: UserDefaultsServiceImp(),
            networkFloaterStore: DefaultNetworkFloaterStore.shared,
            currentLocationStore: DefaultCurrentLocationStore.shared
        )
    }
}
