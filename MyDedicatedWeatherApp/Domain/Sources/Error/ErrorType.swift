//
//  ErrorType.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/04/30.
//

import Foundation

public enum APIError: Error {
    case transportError
    case afError(error: Error)
}

public enum LocationError: Error {
    case notFound
    case unknown
}
