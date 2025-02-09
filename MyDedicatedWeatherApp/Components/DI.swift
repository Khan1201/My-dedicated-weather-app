//
//  DI.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2/9/25.
//

import Foundation
import Data
import Core

struct DI {
    static func currentLocationEO() -> CurrentLocationEO {
        .init(userDefaultsService: UserDefaultsServiceImp())
    }
}
